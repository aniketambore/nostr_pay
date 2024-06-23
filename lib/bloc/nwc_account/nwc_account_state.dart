import 'dart:convert';

import 'package:nwc/nwc.dart';

enum NWCConnectTypes {
  alby,
  nwc,
  none,
}

enum ConnectionStatus { CONNECTING, CONNECTED, DISCONNECTED }

class NWCAccountState {
  final NWCConnectTypes type;
  final int balance;
  final int maxAllowedToPay;
  final String walletPubkey;
  final String myPubkey;
  final String relay;
  final String? lud16;
  final NWCResultType? resultType;
  final Make_Invoice_Result? makeInvoiceResult;
  final Pay_Invoice_Result? payInvoiceResult;
  final Lookup_Invoice_Result? lookupInvoiceResult;
  final NWC_Error_Result? nwcErrorResponse;
  final ConnectionStatus? connectionStatus;

  const NWCAccountState({
    required this.type,
    required this.balance,
    required this.maxAllowedToPay,
    required this.walletPubkey,
    required this.myPubkey,
    required this.relay,
    required this.lud16,
    required this.resultType,
    this.makeInvoiceResult,
    this.payInvoiceResult,
    this.lookupInvoiceResult,
    this.nwcErrorResponse,
    required this.connectionStatus,
  });

  NWCAccountState.initial()
      : this(
          type: NWCConnectTypes.none,
          balance: 0,
          maxAllowedToPay: 0,
          walletPubkey: '',
          myPubkey: '',
          relay: '',
          lud16: null,
          resultType: NWCResultType.idle,
          makeInvoiceResult: null,
          payInvoiceResult: null,
          lookupInvoiceResult: null,
          nwcErrorResponse: null,
          connectionStatus: null,
        );

  NWCAccountState copyWith({
    NWCConnectTypes? type,
    int? balance,
    int? maxAllowedToPay,
    String? walletPubkey,
    String? myPubkey,
    String? relay,
    String? lud16,
    NWCResultType? resultType,
    Make_Invoice_Result? makeInvoiceResult,
    Pay_Invoice_Result? payInvoiceResult,
    Lookup_Invoice_Result? lookupInvoiceResult,
    NWC_Error_Result? nwcErrorResponse,
    ConnectionStatus? connectionStatus,
  }) {
    return NWCAccountState(
      type: type ?? this.type,
      balance: balance ?? this.balance,
      maxAllowedToPay: maxAllowedToPay ?? this.maxAllowedToPay,
      walletPubkey: walletPubkey ?? this.walletPubkey,
      myPubkey: myPubkey ?? this.myPubkey,
      relay: relay ?? this.relay,
      lud16: lud16 ?? this.lud16,
      resultType: resultType ?? this.resultType,
      makeInvoiceResult: makeInvoiceResult ?? this.makeInvoiceResult,
      payInvoiceResult: payInvoiceResult ?? this.payInvoiceResult,
      lookupInvoiceResult: lookupInvoiceResult ?? this.lookupInvoiceResult,
      nwcErrorResponse: nwcErrorResponse ?? this.nwcErrorResponse,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }

  Map<String, dynamic>? toJson() {
    return {
      "type": type.index,
      "balance": balance,
      "maxAllowedToPay": maxAllowedToPay,
      "walletPubkey": walletPubkey,
      "myPubkey": myPubkey,
      "relay": relay,
      "lud16": lud16,
      "connectionStatus": connectionStatus?.index,
    };
  }

  factory NWCAccountState.fromJson(Map<String, dynamic> json) {
    return NWCAccountState(
      type: json["type"] != null
          ? NWCConnectTypes.values[json["type"]]
          : NWCConnectTypes.none,
      balance: json["balance"],
      maxAllowedToPay: json["maxAllowedToPay"],
      walletPubkey: json["walletPubkey"],
      myPubkey: json['myPubkey'],
      relay: json["relay"],
      lud16: json["lud16"],
      resultType: null,
      connectionStatus: json["connectionStatus"] != null
          ? ConnectionStatus.values[json["connectionStatus"]]
          : ConnectionStatus.CONNECTING,
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}

NWCAccountState? assembleNWCAccountState(
  int balance,
  int maxAllowedToPay,
  NWCAccountState state,
) {
  return state.copyWith(
    type: state.type,
    balance: balance ~/ 1000,
    maxAllowedToPay: maxAllowedToPay ~/ 1000,
    connectionStatus: ConnectionStatus.CONNECTED,
  );
}
