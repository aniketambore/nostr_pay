import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostr_pay/bloc/nwc_account/nwc_account_cubit.dart';
import 'package:nostr_pay/bloc/nwc_account/nwc_account_state.dart';
import 'package:nostr_pay/component_library/component_library.dart';
import 'package:nostr_pay/routes/create_invoice/create_invoice_page.dart';
import 'package:nostr_pay/routes/home/home_page.dart';
import 'package:nostr_pay/routes/initial_walkthrough/initial_walkthrough_page.dart';
import 'package:nostr_pay/routes/pay_invoice/pay_invoice_page.dart';
import 'package:nostr_pay/routes/splash/splash_page.dart';

class NWCApp extends StatelessWidget {
  final _lightTheme = LightNWCThemeData();
  final _darkTheme = DarkNWCThemeData();

  final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();

  NWCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NWCTheme(
      lightTheme: _lightTheme,
      darkTheme: _darkTheme,
      child: BlocBuilder<NWCAccountCubit, NWCAccountState>(
        builder: (context, state) {
          return MaterialApp(
            theme: _lightTheme.materialThemeData,
            darkTheme: _darkTheme.materialThemeData,
            // TODO: change to dark mode
            themeMode: ThemeMode.light,
            title: "NWC",
            initialRoute: "splash",
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (RouteSettings settings) {
              debugPrint('New route: ${settings.name}');

              switch (settings.name) {
                case 'splash':
                  return FadeInRoute(
                    builder: (_) => SplashPage(
                      isInitial:
                          state.type == NWCConnectTypes.none ? true : false,
                    ),
                  );
                case '/intro':
                  return FadeInRoute(
                    builder: (_) => const InitialWalkthroughPage(),
                    settings: settings,
                  );
                case '/':
                  return FadeInRoute(
                    builder: (_) => NavigatorPopHandler(
                      onPop: () => _homeNavigatorKey.currentState!.maybePop(),
                      child: Navigator(
                        initialRoute: '/',
                        key: _homeNavigatorKey,
                        onGenerateRoute: (RouteSettings settings) {
                          debugPrint('New inner route: ${settings.name}');
                          switch (settings.name) {
                            case '/':
                              return FadeInRoute(
                                builder: (_) => const HomePage(),
                                settings: settings,
                              );
                            case '/create_invoice':
                              return FadeInRoute(
                                builder: (_) => const CreateInvoicePage(),
                                settings: settings,
                              );
                            case '/pay_invoice':
                              return FadeInRoute(
                                builder: (_) => const PayInvoicePage(),
                                settings: settings,
                              );
                          }
                          return null;
                        },
                      ),
                    ),
                    settings: settings,
                  );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
