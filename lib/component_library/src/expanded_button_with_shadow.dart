import 'package:flutter/material.dart';
import 'package:nostr_pay/component_library/component_library.dart';

class ExpandedButtonWithShadow extends StatelessWidget {
  const ExpandedButtonWithShadow({
    super.key,
    required this.label,
    this.onTap,
    this.width = double.infinity,
    this.height = 60,
    this.shadowColor = NWCColors.woodSmoke,
    this.borderColor = NWCColors.woodSmoke,
    this.color = NWCColors.white,
  });

  final VoidCallback? onTap;
  final String label;
  final double? width;
  final double? height;
  final Color shadowColor;
  final Color borderColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
            shadows: [
              BoxShadow(
                color: shadowColor,
                offset: const Offset(
                  0.0, // Move to right 10  horizontally
                  4.0, // Move to bottom 5 Vertically
                ),
              )
            ],
            color: color,
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                side: BorderSide(color: borderColor, width: 2))),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: NWCColors.woodSmoke,
            ),
          ),
        ),
      ),
    );
  }
}
