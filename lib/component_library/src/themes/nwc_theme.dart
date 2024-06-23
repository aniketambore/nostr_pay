import 'package:flutter/material.dart';
import 'package:nwc_app_final/component_library/src/themes/nwc_theme_data.dart';

class NWCTheme extends InheritedWidget {
  const NWCTheme({
    required super.child,
    required this.lightTheme,
    required this.darkTheme,
    super.key,
  });

  final NWCThemeData lightTheme;
  final NWCThemeData darkTheme;

  @override
  bool updateShouldNotify(NWCTheme oldWidget) {
    return oldWidget.lightTheme != lightTheme ||
        oldWidget.darkTheme != darkTheme;
  }

  static NWCThemeData of(BuildContext context) {
    final NWCTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<NWCTheme>();
    assert(inheritedTheme != null, 'No NWCTheme found in context');
    final currentBrightness = Theme.of(context).brightness;
    return currentBrightness == Brightness.dark
        ? inheritedTheme!.darkTheme
        : inheritedTheme!.lightTheme;
  }
}
