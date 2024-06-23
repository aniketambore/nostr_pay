import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostr_pay/bloc/nwc_account/nwc_account_cubit.dart';
import 'package:nostr_pay/models/decoded_invoice.dart';
import 'package:nostr_pay/routes/payment_dialogs/payment_confirmation_dialog.dart';
import 'package:nostr_pay/routes/payment_dialogs/processing_payment_dialog.dart';

enum PaymentRequestState {
  PAYMENT_REQUEST,
  WAITING_FOR_CONFIRMATION,
  PROCESSING_PAYMENT,
  USER_CANCELLED,
  PAYMENT_COMPLETED
}

class PaymentRequestDialog extends StatefulWidget {
  const PaymentRequestDialog({
    super.key,
    required this.invoice,
  });

  final DecodedInvoice invoice;

  @override
  State<PaymentRequestDialog> createState() => _PaymentRequestDialogState();
}

class _PaymentRequestDialogState extends State<PaymentRequestDialog> {
  late NWCAccountCubit accountCubit;
  PaymentRequestState? _state;

  ModalRoute? _currentRoute;

  @override
  void initState() {
    super.initState();
    accountCubit = context.read<NWCAccountCubit>();
    _state = PaymentRequestState.PAYMENT_REQUEST;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute ??= ModalRoute.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) async {
        if (_state == PaymentRequestState.PROCESSING_PAYMENT) {
          return;
        } else {
          final NavigatorState navigator = Navigator.of(context);
          if (_currentRoute != null && _currentRoute!.isActive) {
            navigator.removeRoute(_currentRoute!);
          }
          return;
        }
      },
      child: showPaymentRequestDialog(),
    );
  }

  Widget showPaymentRequestDialog() {
    if (_state == PaymentRequestState.PROCESSING_PAYMENT) {
      return ProcessingPaymentDialog(
        paymentFunc: () => accountCubit.payInvoice(
          widget.invoice.bolt11,
        ),
        onStateChange: (state) => _onStateChange(state),
      );
    } else {
      return PaymentConfirmationDialog(
        widget.invoice,
        () => _onStateChange(PaymentRequestState.USER_CANCELLED),
        (bolt11, amount) => setState(() {
          _onStateChange(PaymentRequestState.PROCESSING_PAYMENT);
        }),
      );
    }
  }

  void _onStateChange(PaymentRequestState state) {
    if (state == PaymentRequestState.PAYMENT_COMPLETED) {
      Navigator.of(context).pop();
      return;
    }
    if (state == PaymentRequestState.USER_CANCELLED) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _state = state;
    });
  }
}
