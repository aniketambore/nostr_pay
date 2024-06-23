import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nwc_app_final/bloc/nwc_account/nwc_account_cubit.dart';
import 'package:nwc_app_final/bloc/nwc_account/nwc_account_state.dart';
import 'package:nwc_app_final/component_library/component_library.dart';

class WalletDetailsDialog extends StatelessWidget {
  const WalletDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: NWCColors.bareleyWhite,
      titlePadding: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      title: const WalletDetailsDialogTitle(),
      contentPadding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
      content: BlocBuilder<NWCAccountCubit, NWCAccountState>(
          builder: (context, state) {
        return SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WalletDetailsDialogAmount(balance: state.balance),
                WalletDetailsDialogRelay(relay: state.relay),
                WalletDetailsDialogMaxpay(
                    maxAllowedToPay: state.maxAllowedToPay),
                WalletDetailsDialogWalletPubKey(
                  walletPubKey: state.walletPubkey,
                ),
                WalletDetailsDialogLnAddress(lnAddress: state.lud16),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class WalletDetailsDialogTitle extends StatelessWidget {
  const WalletDetailsDialogTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Stack(
      children: [
        Container(
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
            ),
            color: NWCColors.white,
          ),
          height: 64.0,
          width: mediaQuery.size.width,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 32.0),
          child: Center(
            child: CircleAvatar(
              radius: 32,
              backgroundColor: NWCColors.bareleyWhite,
              child: NWCIcon(NWCIcons.command),
            ),
          ),
        ),
      ],
    );
  }
}

class WalletDetailsDialogAmount extends StatelessWidget {
  const WalletDetailsDialogAmount({
    super.key,
    required this.balance,
  });
  final int balance;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cubit = context.read<NWCAccountCubit>();

    return Container(
      height: 56.0,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AutoSizeText(
              'Amount',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: NWCColors.black,
              ),
              textAlign: TextAlign.left,
              maxLines: 1,
              // group: labelAutoSizeGroup,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: AutoSizeText(
                '${cubit.formatBalance(balance)} sats',
                style: textTheme.bodyMedium,
                textAlign: TextAlign.right,
                maxLines: 1,
                // group: valueAutoSizeGroup,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WalletDetailsDialogRelay extends StatelessWidget {
  const WalletDetailsDialogRelay({
    super.key,
    required this.relay,
  });
  final String relay;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 56.0,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AutoSizeText(
              'Relay',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: NWCColors.black,
              ),
              textAlign: TextAlign.left,
              maxLines: 1,
              // group: labelAutoSizeGroup,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: AutoSizeText(
                relay,
                style: textTheme.bodySmall,
                textAlign: TextAlign.right,
                maxLines: 1,
                // group: valueAutoSizeGroup,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WalletDetailsDialogWalletPubKey extends StatelessWidget {
  const WalletDetailsDialogWalletPubKey({
    super.key,
    required this.walletPubKey,
  });

  final String walletPubKey;

  @override
  Widget build(BuildContext context) {
    return ShareablePaymentRow(
      title: 'Wallet Pubkey',
      sharedValue: walletPubKey,
      hideCopyShare: true,
    );
  }
}

class WalletDetailsDialogLnAddress extends StatelessWidget {
  const WalletDetailsDialogLnAddress({
    super.key,
    this.lnAddress,
  });

  final String? lnAddress;

  @override
  Widget build(BuildContext context) {
    if (lnAddress != null && lnAddress!.isNotEmpty) {
      return ShareablePaymentRow(
        title: 'Lightning Address',
        sharedValue: lnAddress!,
      );
    } else {
      return Container();
    }
  }
}

class WalletDetailsDialogMaxpay extends StatelessWidget {
  const WalletDetailsDialogMaxpay({
    super.key,
    required this.maxAllowedToPay,
  });

  final int maxAllowedToPay;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NWCAccountCubit>();

    return ShareablePaymentRow(
      title: 'Max allowed to pay',
      sharedValue: '${cubit.formatBalance(maxAllowedToPay)} sats',
      hideCopyShare: true,
    );
  }
}
