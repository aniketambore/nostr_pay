import 'package:flutter/material.dart';
import 'package:nostr_pay/component_library/component_library.dart';

class ButtonRoundWithShadow extends StatelessWidget {
  const ButtonRoundWithShadow({
    super.key,
    this.onTap,
    this.size = 48,
    this.shadowColor = NWCColors.woodSmoke,
    this.borderColor = NWCColors.woodSmoke,
    this.color = NWCColors.white,
    required this.nwcIcon,
  });
  final Function()? onTap;
  final double? size;
  final Color shadowColor;
  final Color color;
  final Color borderColor;
  final NWCIcon nwcIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        padding: EdgeInsets.all(size != null ? 8 : 16),
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
          shape: CircleBorder(
            side: BorderSide(color: borderColor, width: 2),
          ),
        ),
        child: nwcIcon,
      ),
    );
  }
}
