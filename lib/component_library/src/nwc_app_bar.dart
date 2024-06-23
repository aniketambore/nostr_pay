import 'package:flutter/material.dart';
import 'package:nostr_pay/component_library/component_library.dart';

class TitleOnlyAppBar extends StatelessWidget implements PreferredSize {
  @override
  Size get preferredSize => const Size.fromHeight(120);

  const TitleOnlyAppBar({
    super.key,
    this.color = NWCColors.white,
    required this.title,
    this.onPressed,
  });
  final Color color;
  final String title;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return NWCAppBar(
      height: preferredSize.height,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: ButtonRoundWithShadow(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  nwcIcon: const NWCIcon(NWCIcons.arrow_back),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  title,
                  style: textTheme.headlineMedium,
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(
              width: 20,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget get child => Container();
}

class NWCAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final Color color;
  final double height;

  const NWCAppBar({
    super.key,
    required this.child,
    required this.color,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      // alignment: Alignment.topCenter,
      // color: color,
      child: child,
    );
  }
}
