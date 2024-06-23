import 'package:flutter/material.dart';
import 'package:nostr_pay/component_library/component_library.dart';
import 'package:nostr_pay/routes/payment_dialogs/payment_request_dialog.dart';

import 'processing_payment_content.dart';

class ProcessingPaymentDialog extends StatefulWidget {
  const ProcessingPaymentDialog({
    super.key,
    this.popOnCompletion = false,
    required this.paymentFunc,
    this.onStateChange,
  });

  final bool popOnCompletion;
  final Future Function() paymentFunc;
  final Function(PaymentRequestState state)? onStateChange;

  @override
  State<ProcessingPaymentDialog> createState() =>
      _ProcessingPaymentDialogState();
}

class _ProcessingPaymentDialogState extends State<ProcessingPaymentDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  bool _animating = false;
  ModalRoute? _currentRoute;

  @override
  void initState() {
    super.initState();
    _payAndClose();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    controller!.value = 1.0;
    controller!.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        if (widget.popOnCompletion) {
          Navigator.of(context).removeRoute(_currentRoute!);
        }
        widget.onStateChange?.call(PaymentRequestState.PAYMENT_COMPLETED);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute ??= ModalRoute.of(context);
  }

  void _payAndClose() {
    final navigator = Navigator.of(context);
    widget.paymentFunc().then((payResult) async {
      await _animateClose();
    }).catchError((err) {
      if (widget.popOnCompletion) {
        navigator.removeRoute(_currentRoute!);
      }
      widget.onStateChange?.call(PaymentRequestState.PAYMENT_COMPLETED);
      // if (err is FfiException) {
      //   if (_currentRoute != null && _currentRoute!.isActive) {
      //     navigator.removeRoute(_currentRoute!);
      //   }
      showToast(
        context,
        title: 'Something went wrong!',
        type: ToastificationType.error,
      );
    });
  }

  Future _animateClose() {
    return Future.delayed(const Duration(milliseconds: 50)).then((_) {
      setState(() {
        _animating = true;
        controller!.reverse();
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _animating ? const SizedBox() : const ProcessingPaymentContent();
  }
}
