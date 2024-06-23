import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nwc/nwc.dart';
import 'package:nostr_pay/bloc/nwc_account/nwc_account_cubit.dart';
import 'package:nostr_pay/bloc/nwc_account/nwc_account_state.dart';
import 'package:nostr_pay/component_library/component_library.dart';
import 'package:nostr_pay/models/decoded_invoice.dart';
import 'package:nostr_pay/routes/payment_dialogs/payment_request_dialog.dart';

class PayInvoicePage extends StatefulWidget {
  const PayInvoicePage({super.key});

  @override
  State<PayInvoicePage> createState() => _PayInvoicePageState();
}

class _PayInvoicePageState extends State<PayInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final _invoiceController = TextEditingController();

  String _invoiceErrorMessage = "";

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: NWCColors.white,
      appBar: const TitleOnlyAppBar(title: 'Send'),
      body: BlocConsumer<NWCAccountCubit, NWCAccountState>(
          listener: (context, state) {
        final resultType = state.resultType;
        if (resultType == NWCResultType.error &&
            state.nwcErrorResponse != null) {
          final errorMessage = state.nwcErrorResponse!.errorMessage;
          showToast(
            context,
            title: errorMessage,
            type: ToastificationType.error,
          );
        }
      }, builder: (context, state) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'To send funds or pay an invoice, please paste the BOLT11 invoice (also known as a lightning invoice) in the field below.',
                    style:
                        textTheme.bodyMedium?.copyWith(color: NWCColors.trout),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  NWCTextField(
                    hintText: 'lnbc1u...',
                    controller: _invoiceController,
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    style:
                        textTheme.bodyMedium?.copyWith(color: NWCColors.black),
                    validator: (value) {
                      if (_invoiceErrorMessage.isNotEmpty) {
                        return _invoiceErrorMessage;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExpandedButtonWithShadow(
              label: 'Pay Invoice',
              color: NWCColors.lighteningYellow,
              onTap: () async {
                final invoice = _validateInvoiceInput(_invoiceController.text);
                final navigator = Navigator.of(context);

                if (_formKey.currentState!.validate() && invoice != null) {
                  navigator.pop();
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return PaymentRequestDialog(
                        invoice: invoice,
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  DecodedInvoice? _validateInvoiceInput(String? input) {
    final accountCubit = context.read<NWCAccountCubit>();
    try {
      _setInvoiceErrorMessage('');

      if (input == null || input.isEmpty) {
        _setInvoiceErrorMessage('Invoice can\'t be empty');
        return null;
      }
      final decodedInvoice = accountCubit.decodeInvoice(input);
      if (decodedInvoice.amount == 0) {
        _setInvoiceErrorMessage('You can\'t pay 0-sats invoice');
        return null;
      }
      return decodedInvoice;
    } catch (e) {
      _setInvoiceErrorMessage('Invalid invoice format!');
      rethrow;
    }
  }

  void _setInvoiceErrorMessage(String errorMessage) {
    setState(() {
      _invoiceErrorMessage = errorMessage;
    });
    _formKey.currentState?.validate();
  }
}
