// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nwc_app_final/bloc/nwc_account/nwc_account_cubit.dart';
import 'package:nwc_app_final/bloc/nwc_account/nwc_account_state.dart';
import 'package:nwc_app_final/component_library/component_library.dart';

class InitialWalkthroughPage extends StatefulWidget {
  const InitialWalkthroughPage({super.key});

  @override
  State<InitialWalkthroughPage> createState() => _InitialWalkthroughPageState();
}

class _InitialWalkthroughPageState extends State<InitialWalkthroughPage> {
  final _formKey = GlobalKey<FormState>();
  final _uriController = TextEditingController();

  String _validatorErrorMessage = "";

  @override
  void dispose() {
    _uriController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NWCColors.white,
      body: SingleChildScrollView(
        child: Container(
          height:
              MediaQuery.of(context).size.height, // Ensures full screen height
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/nostr_pay_logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _connectForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _connectForm() {
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nostr Pay',
            style: textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'With Nostr Pay, receiving and sending bitcoins is safe, easy and fast!',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          NWCTextField(
            hintText: 'nostr+walletconnect://',
            controller: _uriController,
            textInputAction: TextInputAction.done,
            validator: (_) => _validatorErrorMessage.isNotEmpty
                ? _validatorErrorMessage
                : null,
            prefixIcon: const NWCIcon(
              NWCIcons.nwc,
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(height: 48),
          ExpandedElevatedButton(
            label: 'Connect',
            onTap: () {
              final isValidUri = _validateUri(_uriController.text);
              if (isValidUri) {
                connect(_uriController.text);
              }
            },
            icon: const NWCIcon(NWCIcons.arrow_forward),
          )
        ],
      ),
    );
  }

  Future<void> connect(String connectionURI) async {
    // TODO: Access NWCAccountCubit instance from context

    final navigator = Navigator.of(context);
    var loaderRoute = createLoaderRoute(context);
    navigator.push(loaderRoute);

    try {
      // Simulate a delay for demonstration purposes.
      await Future.delayed(const Duration(seconds: 3), () async {
        // TODO: Call the connect method on NWCAccountCubit
      });

      // TODO: Replace the current route with the home screen
    } catch (error) {
      debugPrint('Error: $error');
      showToast(
        context,
        title: 'Something went wrong!',
        type: ToastificationType.error,
      );
    } finally {
      // Remove the loader route from the navigator stack.
      navigator.removeRoute(loaderRoute);
    }
  }

  bool _validateUri(String value) {
    if (value.isEmpty) {
      _setValidatorErrorMessage('URI cannot be empty');
      return false;
    }
    if (!value.startsWith('nostr+walletconnect://')) {
      _setValidatorErrorMessage('Invalid URI format');
      return false;
    }
    if (!value.contains('?')) {
      _setValidatorErrorMessage('Query parameters are missing');
      return false;
    }

    // Splitting the URI to get query parameters
    List<String> uriParts = value.split('?');
    String queryParams = uriParts.length > 1 ? uriParts[1] : '';

    if (!queryParams.contains('relay=')) {
      _setValidatorErrorMessage('Relay URL is missing');
      return false;
    }
    if (!queryParams.contains('secret=')) {
      _setValidatorErrorMessage('Secret is missing');
      return false;
    }

    // Lud16 is optional, so no need to check
    return true;
  }

  void _setValidatorErrorMessage(String errorMessage) {
    setState(() {
      _validatorErrorMessage = errorMessage;
    });
    _formKey.currentState?.validate();
  }
}
