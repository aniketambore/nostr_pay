import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nwc/nwc.dart';
import 'package:nwc_app_final/bloc/nwc_account/nwc_account_cubit.dart';
import 'package:nwc_app_final/bloc/nwc_account/nwc_account_state.dart';
import 'package:nwc_app_final/component_library/component_library.dart';
import 'package:nwc_app_final/routes/success/success_page.dart';
import 'package:nwc_app_final/services/device.dart';

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
    // TODO: Access NWCAccountCubit instance from context

    // Start a periodic timer to poll for invoice lookup.
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      // TODO: Call the lookupInvoice method on NWCAccountCubit with the invoice ID
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

        // TODO: Handle the case when the result type is 'lookup_invoice' and the result is not null

        // TODO: Handle the case when the result type is 'error' and the nwcErrorResponse is not null
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
