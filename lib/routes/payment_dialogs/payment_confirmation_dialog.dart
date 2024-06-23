import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nwc_app_final/component_library/component_library.dart';
import 'package:nwc_app_final/models/decoded_invoice.dart';

class PaymentConfirmationDialog extends StatelessWidget {
  const PaymentConfirmationDialog(
    this.invoice,
    this._onCancel,
    this._onPaymentApproved, {
    super.key,
  });

  final DecodedInvoice invoice;
  final Function() _onCancel;
  final Function(String bolt11, int amount) _onPaymentApproved;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: NWCColors.bareleyWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(
          color: NWCColors.woodSmoke,
          width: 2,
        ),
      ),
      // contentPadding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _buildConfirmationDialog(context),
      ),
    );
  }

  Widget _buildConfirmationDialog(context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Payment Confirmation',
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: NWCColors.black,
          ),
        ),
        const SizedBox(height: 8),
        _buildContent(context),
        const SizedBox(height: 12),
        _buildActions(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final queryData = MediaQuery.of(context);

    return SizedBox(
      width: queryData.size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Are you sure you want to pay',
            textAlign: TextAlign.center,
          ),
          AutoSizeText.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${invoice.amount}',
                  style: textTheme.bodyLarge,
                ),
                const TextSpan(
                  text: ' sats ?',
                ),
              ],
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: NWCColors.white,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 33.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            side: const BorderSide(
              color: NWCColors.woodSmoke,
              width: 2,
            ),
          ),
          child: Text(
            'No',
            style: textTheme.labelSmall,
          ),
          onPressed: () => _onCancel(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: NWCColors.woodSmoke,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 33.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onPressed: () {
            _onPaymentApproved(
              invoice.bolt11,
              invoice.amount,
            );
          },
          child: Text(
            'Yes',
            style: textTheme.labelSmall?.copyWith(
              color: NWCColors.white,
            ),
          ),
        ),
        // ExpandedOutlinedButton(label: 'Cancel'),
      ],
    );
  }
}
