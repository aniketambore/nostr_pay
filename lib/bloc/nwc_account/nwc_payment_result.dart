import 'package:nwc/nwc.dart';

class NWCPaymentResult {
  final NWCResultType? resultType;
  final Pay_Invoice_Result? payInvoiceResult;
  final Make_Invoice_Result? makeInvoiceResult;

  const NWCPaymentResult({
    this.resultType,
    this.payInvoiceResult,
    this.makeInvoiceResult,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NWCPaymentResult &&
          runtimeType == other.runtimeType &&
          resultType == other.resultType &&
          payInvoiceResult == other.payInvoiceResult &&
          makeInvoiceResult == other.makeInvoiceResult;

  @override
  int get hashCode =>
      resultType.hashCode ^
      payInvoiceResult.hashCode ^
      makeInvoiceResult.hashCode;
}
