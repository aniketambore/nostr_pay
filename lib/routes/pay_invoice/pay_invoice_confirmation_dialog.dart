import 'package:flutter/material.dart';
import 'package:nwc_app_final/component_library/component_library.dart';

class PayInvoiceConfirmationDialog extends StatelessWidget {
  const PayInvoiceConfirmationDialog({
    super.key,
    required this.title,
    required this.description,
    this.onYesPressed,
  });

  final String title;
  final String description;
  final Function()? onYesPressed;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              title,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: NWCColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
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
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NWCColors.woodSmoke,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 33.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: onYesPressed,
                  child: Text(
                    'Yes',
                    style: textTheme.labelSmall?.copyWith(
                      color: NWCColors.white,
                    ),
                  ),
                ),
                // ExpandedOutlinedButton(label: 'Cancel'),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
