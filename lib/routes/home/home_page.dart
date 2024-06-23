import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostr_pay/bloc/nwc_account/nwc_account_cubit.dart';
import 'package:nostr_pay/bloc/nwc_account/nwc_account_state.dart';
import 'package:nostr_pay/component_library/component_library.dart';
import 'package:nostr_pay/handlers/handler.dart';
import 'package:nostr_pay/handlers/handler_context_provider.dart';
import 'package:nostr_pay/handlers/payment_result_handler.dart';
import 'package:nostr_pay/routes/home/wallet_details_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HandlerContextProvider {
  final handlers = <Handler>[];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      handlers.addAll([
        PaymentResultHandler(),
      ]);
      for (var handler in handlers) {
        handler.init(this);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (var handler in handlers) {
      handler.dispose();
    }
    handlers.clear();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accountCubit = context.read<NWCAccountCubit>();

    return Scaffold(
      backgroundColor: NWCColors.white,
      body: BlocBuilder<NWCAccountCubit, NWCAccountState>(
          builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            await accountCubit.refresh();
          },
          child: ListView(
            children: [
              Column(
                children: [
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24),
                    margin:
                        const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                    decoration: const ShapeDecoration(
                      color: NWCColors.athens,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Balance",
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: NWCColors.woodSmoke),
                              ),
                              Text(
                                '${accountCubit.formatBalance(state.balance)} sats',
                                style: textTheme.headlineLarge
                                    ?.copyWith(color: NWCColors.woodSmoke),
                              ),
                            ],
                          ),
                        ),
                        ButtonRoundWithShadow(
                          nwcIcon: const NWCIcon(NWCIcons.command),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const WalletDetailsDialog();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        BoxWidget(
                          title: 'Send',
                          nwcIcon: const NWCIcon(
                            NWCIcons.arrow_up_right,
                            width: 24,
                            height: 24,
                          ),
                          onTap: () => _push(context, '/pay_invoice'),
                        ),
                        // SizedBox(width: 15),
                        BoxWidget(
                          title: '',
                          nwcIcon: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: NWCIcon(
                              NWCIcons.zap,
                            ),
                          ),
                          onTap: () {},
                        ),
                        BoxWidget(
                          title: 'Receive',
                          nwcIcon: const NWCIcon(
                            NWCIcons.arrow_down_left,
                            width: 24,
                            height: 24,
                          ),
                          onTap: () => _push(context, '/create_invoice'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  void _push(BuildContext context, String route) {
    final navigatorState = Navigator.of(context);
    navigatorState.pushNamed(route);
  }
}
