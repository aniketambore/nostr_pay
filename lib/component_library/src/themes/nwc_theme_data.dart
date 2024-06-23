import 'package:flutter/material.dart';
import 'package:nwc_app_final/component_library/component_library.dart';

abstract class NWCThemeData {
  ThemeData get materialThemeData;
}

class LightNWCThemeData extends NWCThemeData {
  @override
  ThemeData get materialThemeData => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black87,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 36,
            fontWeight: FontWeight.w800,
            height: 1.11,
            color: NWCColors.woodSmoke,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 27,
            fontWeight: FontWeight.w800,
            height: 1.18,
            color: NWCColors.woodSmoke,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 21,
            fontWeight: FontWeight.w500,
            height: 1.33,
            color: NWCColors.woodSmoke,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 17,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: NWCColors.woodSmoke,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.38,
            color: NWCColors.woodSmoke,
          ),
          labelSmall: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w800,
            height: 1.33,
            color: NWCColors.woodSmoke,
          ),
        ),
      );
}

class DarkNWCThemeData extends NWCThemeData {
  @override
  ThemeData get materialThemeData => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.dark,
        ),
      );
}
