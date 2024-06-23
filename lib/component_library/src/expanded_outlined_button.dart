import 'package:flutter/material.dart';
import 'package:nostr_pay/component_library/component_library.dart';

class ExpandedOutlinedButton extends StatelessWidget {
  // static const double _elevatedButtonHeight = 60;

  const ExpandedOutlinedButton({
    required this.label,
    this.onTap,
    this.icon,
    this.iconAlignment = IconAlignment.end,
    this.width = double.infinity,
    this.backgroundColor = NWCColors.white,
    super.key,
  });

  ExpandedOutlinedButton.inProgress({
    required String label,
    double? width = double.infinity,
    Color? backgroundColor,
    Key? key,
  }) : this(
          label: label,
          width: width,
          icon: Transform.scale(
            scale: 0.5,
            child: const CircularProgressIndicator(),
          ),
          backgroundColor: backgroundColor,
          key: key,
        );

  final VoidCallback? onTap;
  final String label;
  final Widget? icon;
  final IconAlignment iconAlignment;
  final double? width;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final icon = this.icon;
    return SizedBox(
      // height: _elevatedButtonHeight,
      width: width,
      child: icon != null
          ? OutlinedButton.icon(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                side: const BorderSide(
                  color: NWCColors.black,
                  width: 2,
                ),
                backgroundColor: backgroundColor,
              ),
              label: Text(
                label,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              icon: icon,
              iconAlignment: iconAlignment,
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                side: const BorderSide(
                  color: NWCColors.black,
                  width: 2,
                ),
                backgroundColor: backgroundColor,
              ),
              child: Text(
                label,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
    );
  }
}
