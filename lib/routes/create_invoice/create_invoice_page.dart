import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nwc/nwc.dart';
import 'package:nwc_app_final/bloc/nwc_account/nwc_account_cubit.dart';
import 'package:nwc_app_final/bloc/nwc_account/nwc_account_state.dart';
import 'package:nwc_app_final/component_library/component_library.dart';
import 'package:nwc_app_final/routes/invoice_qr/invoice_qr_page.dart';

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  State<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _descriptionFocusNode = FocusNode();
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: NWCColors.white,
      appBar: const TitleOnlyAppBar(title: 'Receive'),
      body: BlocConsumer<NWCAccountCubit, NWCAccountState>(
        // TODO: Take a look at the listener
        listener: (context, state) {
          final resultType = state.resultType;

          // TODO: Handle the case when the result type is 'make_invoice' and the makeInvoiceResult is not null

          // TODO: Handle the case when the result type is 'error' and the nwcErrorResponse is not null
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'To receive funds, please enter the amount and a description for the payment to generate a BOLT11 invoice (lightning invoice).',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: NWCColors.trout),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    _buildAmountContainer(),
                    const SizedBox(
                      height: 24,
                    ),
                    _buildDescriptionContainer(),
                    const SizedBox(
                      height: 40,
                    ),
                    ExpandedButtonWithShadow(
                      label: 'Create Invoice',
                      color: NWCColors.lighteningYellow,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _createInvoice();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmountContainer() {
    return NWCTextField(
      hintText: "Amount in Satoshi...",
      controller: _amountController,
      focusNode: _amountFocusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      textInputAction: TextInputAction.next,
      validator: (val) {
        final value = _amountController.text;
        if (value.trim().isEmpty) {
          return 'Please enter the amount in sats';
        }

        int amount = int.tryParse(value) ?? 0;
        if (amount <= 0) {
          return 'Invalid amount';
        }

        return null;
      },
    );
  }

  Widget _buildDescriptionContainer() {
    return NWCTextField(
      hintText: 'Add a description',
      controller: _descriptionController,
      focusNode: _descriptionFocusNode,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      maxLines: 1,
      maxLength: 90,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
    );
  }

  void _createInvoice() async {
    debugPrint(
        "Create invoice: description=${_descriptionController.text}, amount=${_amountController.text}");

    // TODO: Access NWCAccountCubit instance from context

    final navigator = Navigator.of(context);
    var loaderRoute = createLoaderRoute(context);
    navigator.push(loaderRoute);

    try {
      await Future.delayed(const Duration(seconds: 3), () async {
        // TODO: Call the makeInvoice method on NWCAccountCubit
      });
    } catch (error) {
      debugPrint('Error: $error');
    }
  }
}
