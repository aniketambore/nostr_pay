import 'package:flutter/material.dart';
import 'package:nostr_pay/component_library/component_library.dart';

class BoxWidget extends StatelessWidget {
  const BoxWidget({
    super.key,
    required this.title,
    required this.nwcIcon,
    this.onTap,
  });

  final String title;
  final Widget nwcIcon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: const ShapeDecoration(
              shadows: [
                BoxShadow(
                  color: NWCColors.woodSmoke,
                  offset: Offset(
                    0.0, // Move to right 10  horizontally
                    2.0, // Move to bottom 5 Vertically
                  ),
                )
              ],
              color: NWCColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                side: BorderSide(
                  color: NWCColors.woodSmoke,
                  width: 2,
                ),
              ),
            ),
            child: nwcIcon,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: NWCColors.woodSmoke,
            ),
          )
        ],
      ),
    );
  }
}
