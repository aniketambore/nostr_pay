import 'dart:async';
import 'dart:convert';

import 'package:bolt11_decoder/bolt11_decoder.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nwc_app_final/bloc/nwc_account/nwc_account_state.dart';
import 'package:nwc_app_final/models/decoded_invoice.dart';
import 'package:rxdart/rxdart.dart';

import 'nwc_credentials_manager.dart';
import 'nwc_payment_result.dart';

const syncInterval = 60;

class NWCAccountCubit extends Cubit<NWCAccountState> with HydratedMixin {
  // TODO: Instance of the Nostr Wallet Connect class
  final dynamic _nwc;

  final NWCCredentialsManager _credentialsManager;

  // TODO: Change balance controller and stream type to Get_Balance_Result
  final BehaviorSubject<dynamic> _walletBalanceController =
      BehaviorSubject<dynamic>();

  Stream<dynamic> get walletBalanceStream => _walletBalanceController.stream;

  // Stream controller for handling payment result events.
  final StreamController<NWCPaymentResult> _paymentResultStreamController =
      StreamController<NWCPaymentResult>();

  // Stream providing payment result events to listeners.
  Stream<NWCPaymentResult> get paymentResultStream =>
      _paymentResultStreamController.stream;

  final formatter = NumberFormat('#,##,000');

  NWCAccountCubit(this._nwc, this._credentialsManager)
      : super(NWCAccountState.initial()) {
    // Hydrate the state from the stored data.
    hydrate();

    // TODO: Listen to account changes and emit updated state

    // TODO: Disable unnecessary logs from the logger utils

    // TODO: Connect if the current state type is not none
  }

  Stream<NWCAccountState> _watchAccountChanges() {
    // TODO: Update the types to match the actual data type
    return Rx.combineLatest<dynamic, NWCAccountState>([walletBalanceStream],
        (values) {
      // TODO: Check if wallet balance result is not null

      // Return the current state if balance result is null
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
      // TODO: Parse the Nostr Connect URI

      // TODO: Derive the public key from the parsed URI secret

      // TODO: Store the secret using the credentials manager

      // TODO: Emit the new state with the updated properties
    }

    await _checkAndHandleConnection();
  }

  Future _checkAndHandleConnection() async {
    await _initializeConnection();

    // in case we failed to start (lack of internet connection probably)
    if (state.connectionStatus == ConnectionStatus.DISCONNECTED) {
      StreamSubscription<List<ConnectivityResult>>? subscription;
      subscription = Connectivity().onConnectivityChanged.listen((event) async {
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

    // TODO: Initialize the relays service with the relay URL

    // TODO: Create a subscription filter for events

    // TODO: Start the events subscription using the relays service

    // TODO: Restore the secret from the credentials manager

    // TODO: Listen to the nostr stream for events

    emit(state.copyWith(connectionStatus: ConnectionStatus.CONNECTED));
  }

  void _onConnected() async {
    debugPrint("on connected");
    var lastSync = DateTime.fromMillisecondsSinceEpoch(0);
    await refresh();
    FGBGEvents.stream.listen((event) async {
      if (event == FGBGType.foreground &&
          DateTime.now().difference(lastSync).inSeconds > syncInterval) {
        await refresh();
        lastSync = DateTime.now();
      }
    });
  }

  Future<void> refresh() async {
    await _sync();
  }

  Future<void> _sync() async {
    debugPrint('sync');

    // TODO: Define a message to request balance

    // TODO: Call the _sentToRelay function to send the balance message
  }

  Future<void> makeInvoice({
    required int amountInSats,
    String? description,
  }) async {
    final desc = (description != null && description.trim().isNotEmpty)
        ? description
        : 'Nostr Pay';

    debugPrint("makeInvoice: $desc, $amountInSats");

    // TODO: Construct the request object for making an invoice

    // TODO: Send the request to the relay using _sentToRelay
  }

  Future<void> payInvoice(String invoice) async {
    debugPrint('Pay invoice: $invoice');

    // TODO: Construct the message to pay the invoice

    // TODO: Send the payment request to the relay using _sentToRelay
  }

  Future<void> lookupInvoice(String invoice) async {
    debugPrint('Lookup invoice: $invoice');

    // TODO: Construct the message to lookup the invoice

    // TODO: Send the lookup request to the relay using _sentToRelay
  }

  Future<void> _sentToRelay(Map message) async {
    debugPrint('_sentToRelay()');
    // TODO: Restore the secret from the credentials manager

    // TODO: Encrypt the message using NIP04

    // TODO: Create an event request with the encrypted content

    // TODO: Send the event to relays with a timeout
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
