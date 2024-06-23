import 'package:flutter/material.dart';
import 'package:nostr_pay/component_library/component_library.dart';
import 'package:nostr_pay/routes/payment_dialogs/processing_payment_loader.dart';

class ProcessingPaymentContent extends StatelessWidget {
  const ProcessingPaymentContent({
    super.key,
    this.title,
    this.subtitle,
  });
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      backgroundColor: NWCColors.bareleyWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(
          color: NWCColors.woodSmoke,
          width: 2,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const ProcessingPaymentLoader(),
            const SizedBox(height: 28),
            Text(
              title ?? 'Processing Payment',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              subtitle ?? 'Please wait while your payment is being processed',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
