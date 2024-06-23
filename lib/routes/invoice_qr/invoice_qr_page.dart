import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nwc/nwc.dart';
import 'package:nostr_pay/bloc/nwc_account/nwc_account_cubit.dart';
import 'package:nostr_pay/bloc/nwc_account/nwc_account_state.dart';
import 'package:nostr_pay/component_library/component_library.dart';
import 'package:nostr_pay/routes/success/success_page.dart';
import 'package:nostr_pay/services/device.dart';

class InvoiceQrPage extends StatefulWidget {
  const InvoiceQrPage({
    super.key,
    required this.makeInvoiceResult,
  });
  final Make_Invoice_Result makeInvoiceResult;

  @override
  State<InvoiceQrPage> createState() => _InvoiceQrPageState();
}

class _InvoiceQrPageState extends State<InvoiceQrPage> {
  final toast = Toastification();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }

  void _startPolling() {
    final cubit = context.read<NWCAccountCubit>();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await cubit.lookupInvoice(widget.makeInvoiceResult.invoice);
    });
  }

  void _stopPolling() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: NWCColors.white,
      body: BlocConsumer<NWCAccountCubit, NWCAccountState>(
          listener: (context, state) {
        final resultType = state.resultType;
        final result = state.lookupInvoiceResult;
        if (resultType == NWCResultType.lookup_invoice && result != null) {
          final isPaid = result.settledAt != null ? true : false;
          if (isPaid) {
            final navigator = Navigator.of(context);
            navigator.popUntil((route) => route.settings.name == "/");
            navigator.push(
              MaterialPageRoute(
                builder: (_) => const SuccessPage(
                  title: 'Payment Received Successfully',
                  description:
                      'Congratulations! You have successfully received sats from the sender.',
                ),
              ),
            );
          }
        } else if (resultType == NWCResultType.error &&
            state.nwcErrorResponse != null) {
          final errorMessage = state.nwcErrorResponse!.errorMessage;
          showToast(
            context,
            title: errorMessage,
            type: ToastificationType.error,
          );
        }
      }, builder: (context, state) {
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 56,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Invoice',
                            style: textTheme.headlineLarge,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          InvoiceQR(bolt11: widget.makeInvoiceResult.invoice),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              left: 24,
              top: 80,
              child: ButtonRoundWithShadow(
                nwcIcon: const NWCIcon(NWCIcons.close),
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExpandedElevatedButton(
              label: 'Copy Invoice',
              icon: const NWCIcon(
                NWCIcons.copy,
              ),
              iconAlignment: IconAlignment.start,
              onTap: () {
                Device().setClipboardText(widget.makeInvoiceResult.invoice);
                showToast(
                  context,
                  title: 'Invoice data was copied to your clipboard.',
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
            ExpandedOutlinedButton(
              label: 'Share Invoice',
              icon: const NWCIcon(
                NWCIcons.share_black,
              ),
              iconAlignment: IconAlignment.start,
              onTap: () {
                Device()
                    .shareText("lightning:${widget.makeInvoiceResult.invoice}");
              },
            ),
          ],
        ),
      ),
    );
  }
}
