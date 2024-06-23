import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nwc/nwc.dart';
import 'package:nwc_app_final/bloc/nwc_account/nwc_account_cubit.dart';
import 'package:nwc_app_final/bloc/nwc_account/nwc_payment_result.dart';
import 'package:nwc_app_final/handlers/handler.dart';
import 'package:nwc_app_final/routes/success/success_page.dart';
import 'package:rxdart/rxdart.dart';

import 'handler_context_provider.dart';

class PaymentResultHandler extends Handler {
  StreamSubscription<NWCPaymentResult>? _subscription;

  @override
  void init(HandlerContextProvider contextProvider) {
    super.init(contextProvider);
    debugPrint("PaymentResultHandler inited");
    _subscription = contextProvider
        .getBuildContext()!
        .read<NWCAccountCubit>()
        .paymentResultStream
        .delay(const Duration(seconds: 1))
        .listen(_listen);
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
    _subscription = null;
  }

  void _listen(NWCPaymentResult paymentResult) async {
    debugPrint('Received paymentResult: $paymentResult');

    final context = contextProvider?.getBuildContext();
    if (context == null) {
      debugPrint("Failed to proceed because context is null");
      return;
    }

    final resultType = paymentResult.resultType;

    if (resultType == NWCResultType.pay_invoice) {
      final navigatorState = Navigator.of(context);
      navigatorState.push(
        MaterialPageRoute(
          builder: (context) => const SuccessPage(
            title: 'Payment Successful!',
            description: 'Your payment has been successfully processed!',
          ),
        ),
      );
    } else {
      debugPrint("paymentResult is null and error is null");
    }
  }
}
