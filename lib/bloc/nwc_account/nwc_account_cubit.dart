import 'dart:async';
import 'dart:convert';

import 'package:bolt11_decoder/bolt11_decoder.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nwc/nwc.dart';
import 'package:nostr_pay/bloc/nwc_account/nwc_account_state.dart';
import 'package:nostr_pay/models/decoded_invoice.dart';
import 'package:rxdart/rxdart.dart';

import 'nwc_credentials_manager.dart';
import 'nwc_payment_result.dart';

const syncInterval = 60;

class NWCAccountCubit extends Cubit<NWCAccountState> with HydratedMixin {
  final NWC _nwc;

  final NWCCredentialsManager _credentialsManager;

  final BehaviorSubject<Get_Balance_Result?> _walletBalanceController =
      BehaviorSubject<Get_Balance_Result?>();

  Stream<Get_Balance_Result?> get walletBalanceStream =>
      _walletBalanceController.stream;

  // Stream controller for handling payment result events.
  final StreamController<NWCPaymentResult> _paymentResultStreamController =
      StreamController<NWCPaymentResult>();

  // Stream providing payment result events to listeners.
  Stream<NWCPaymentResult> get paymentResultStream =>
      _paymentResultStreamController.stream;

  // Number format for balance display
  final formatter = NumberFormat('#,##,000');

  NWCAccountCubit(this._nwc, this._credentialsManager)
      : super(NWCAccountState.initial()) {
    // Hydrate the state from the stored data.
    hydrate();

    _watchAccountChanges().listen((acc) {
      debugPrint('State changed: $acc');
      emit(acc);
    });

    _nwc.loggerUtils.disableLogs();

    if (state.type != NWCConnectTypes.none) connect();
  }

  Stream<NWCAccountState> _watchAccountChanges() {
    return Rx.combineLatest<Get_Balance_Result?, NWCAccountState>(
        [walletBalanceStream], (values) {
      if (values.first != null) {
        return assembleNWCAccountState(
              values.first!.balance,
              values.first!.maxAmount ?? 0,
              state,
            ) ??
            state;
      }
      return state;
    });
  }

  Future connect({
    String? connectionURI,
    bool restored = false,
    NWCConnectTypes? type,
  }) async {
    debugPrint(
        "connect new wallet: ${connectionURI != null}, restored: $restored");
    if (connectionURI != null) {
      final parsedUri = _nwc.nip47.parseNostrConnectUri(connectionURI);
      final myPubkey =
          _nwc.keysService.derivePublicKey(privateKey: parsedUri.secret);
      await _credentialsManager.storeSecret(secret: parsedUri.secret);
      emit(state.copyWith(
        type: type,
        walletPubkey: parsedUri.pubkey,
        myPubkey: myPubkey,
        relay: parsedUri.relay,
        lud16: parsedUri.lud16,
      ));
    }

    await _checkAndHandleConnection();
  }

  Future _checkAndHandleConnection() async {
    await _initializeConnection();

    // in case we failed to start (lack of internet connection probably)
    if (state.connectionStatus == ConnectionStatus.DISCONNECTED) {
      StreamSubscription<List<ConnectivityResult>>? subscription;
      subscription = Connectivity().onConnectivityChanged.listen((event) async {
        // we should try fetch the selected lsp information when internet is back.
        if (event.contains(ConnectivityResult.none) &&
            state.connectionStatus == ConnectionStatus.DISCONNECTED) {
          await _initializeConnection();
          if (state.connectionStatus == ConnectionStatus.CONNECTED) {
            subscription!.cancel();
            _onConnected();
          }
        }
      });
    } else {
      _onConnected();
    }
  }

  Future<void> _initializeConnection() async {
    emit(state.copyWith(connectionStatus: ConnectionStatus.CONNECTING));
    await _nwc.relaysService.init(relaysUrl: [state.relay]);

    final subToFilter = Request(
      filters: [
        Filter(
          kinds: const [23195],
          authors: [state.walletPubkey],
          since: DateTime.now(),
        )
      ],
    );

    final nostrStream = _nwc.relaysService.startEventsSubscription(
      request: subToFilter,
      onEose: (relay, eose) =>
          debugPrint('subscriptionId: ${eose.subscriptionId}, relay: $relay'),
    );

    final secret = await _credentialsManager.restoreSecret();

    nostrStream.stream.listen((Event event) {
      debugPrint("Listenning");
      if (event.kind == 23195 && event.content != null) {
        final decryptedContent = _nwc.nip04.decrypt(
          secret,
          state.walletPubkey,
          event.content!,
        );

        debugPrint('Content: $decryptedContent');

        final content = _nwc.nip47.parseResponseResult(decryptedContent);

        if (content.resultType == NWCResultType.get_balance) {
          final balanceResult = content.result as Get_Balance_Result;
          _walletBalanceController.add(balanceResult);
          debugPrint('balance: ${balanceResult.balance}');
        } else if (content.resultType == NWCResultType.make_invoice) {
          final invoiceResult = content.result as Make_Invoice_Result;
          debugPrint('invoice: ${invoiceResult.invoice}');
          emit(
            state.copyWith(
              resultType: NWCResultType.make_invoice,
              makeInvoiceResult: invoiceResult,
            ),
          );
        } else if (content.resultType == NWCResultType.pay_invoice) {
          final invoiceResult = content.result as Pay_Invoice_Result;
          debugPrint('preimage: ${invoiceResult.preimage}');
          _paymentResultStreamController.add(
            NWCPaymentResult(
              resultType: NWCResultType.pay_invoice,
              payInvoiceResult: invoiceResult,
            ),
          );
          emit(
            state.copyWith(
              resultType: NWCResultType.pay_invoice,
              payInvoiceResult: invoiceResult,
            ),
          );
        } else if (content.resultType == NWCResultType.lookup_invoice) {
          final result = content.result as Lookup_Invoice_Result;
          debugPrint(
              'Invoice paid: ${result.settledAt != null ? true : false}');
          emit(state.copyWith(
            resultType: NWCResultType.lookup_invoice,
            lookupInvoiceResult: result,
          ));
        } else if (content.resultType == NWCResultType.error) {
          final error = content.result as NWC_Error_Result;
          debugPrint('error message: ${error.errorMessage}');
          emit(state.copyWith(
            resultType: NWCResultType.error,
            nwcErrorResponse: error,
          ));
        }
      }
    });

    emit(state.copyWith(connectionStatus: ConnectionStatus.CONNECTED));
  }

  void _onConnected() async {
    debugPrint("on connected");
    var lastSync = DateTime.fromMillisecondsSinceEpoch(0);
    await refresh();
    FGBGEvents.stream.listen((event) async {
      if (event == FGBGType.foreground &&
          DateTime.now().difference(lastSync).inSeconds > syncInterval) {
        await _sync();
        lastSync = DateTime.now();
      }
    });
  }

  Future<void> refresh() async {
    await _sync();
  }

  Future<void> _sync() async {
    debugPrint('sync');

    // Message 1: Get Balance
    final balanceMessage = {"method": "get_balance"};
    await _sentToRelay(balanceMessage);
  }

  Future<void> makeInvoice({
    required int amountInSats,
    String? description,
  }) async {
    final desc = (description != null && description.trim().isNotEmpty)
        ? description
        : 'Nostr Pay';

    debugPrint("makeInvoice: $desc, $amountInSats");

    final req = {
      "method": "make_invoice",
      "params": {
        "amount": amountInSats * 1000, // value in msats
        "description": desc, // invoice's description, optional
      }
    };

    await _sentToRelay(req);
  }

  Future<void> payInvoice(String invoice) async {
    debugPrint('Pay invoice: $invoice');

    final message = {
      "method": "pay_invoice",
      "params": {
        "invoice": invoice,
      }
    };

    await _sentToRelay(message);
  }

  Future<void> lookupInvoice(String invoice) async {
    debugPrint('Lookup invoice: $invoice');

    final message = {
      "method": "lookup_invoice",
      "params": {
        "invoice": invoice,
      }
    };

    await _sentToRelay(message);
  }

  Future<void> _sentToRelay(Map message) async {
    debugPrint('_sentToRelay()');
    final secret = await _credentialsManager.restoreSecret();

    final content = _nwc.nip04.encrypt(
      secret,
      state.walletPubkey,
      jsonEncode(message),
    );

    final request = Event.fromPartialData(
      kind: 23194,
      content: content,
      tags: [
        ['p', state.walletPubkey]
      ],
      createdAt: DateTime.now(),
      keyPairs: KeyPairs(private: secret),
    );

    final okCommand = await _nwc.relaysService.sendEventToRelays(
      request,
      timeout: const Duration(seconds: 3),
    );

    debugPrint('okCommand: $okCommand');
  }

  String formatBalance(int balance) {
    return formatter.format(balance);
  }

  DecodedInvoice decodeInvoice(String invoice) {
    String description = '';
    int amountInSats = 0;

    try {
      final req = Bolt11PaymentRequest(invoice);
      for (TaggedField? tag in req.tags) {
        if (tag!.type == 'description') {
          description = tag.data as String;
        }
      }

      amountInSats = (req.amount.toDouble() * 100000000).round();

      return DecodedInvoice(
        amount: amountInSats,
        description: description,
        bolt11: invoice,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  NWCAccountState? fromJson(Map<String, dynamic> json) {
    return NWCAccountState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(NWCAccountState state) {
    return state.toJson();
  }
}
