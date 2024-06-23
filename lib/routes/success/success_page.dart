import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nwc_app_final/component_library/component_library.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({
    super.key,
    this.title,
    this.description,
  });
  final String? title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NWCColors.white,
      body: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 161,
                    height: 161,
                    decoration: BoxDecoration(
                      color: NWCColors.carribeanGreen,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 4,
                        color: NWCColors.woodSmoke,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 54.0,
                        horizontal: 41,
                      ),
                      child: NWCIcon(NWCIcons.check),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _successContent(context),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: ExpandedElevatedButton(
                      label: 'Okay',
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  )
                ],
              ),
            ),
            Lottie.asset(
              'assets/lottie/confetti.json',
              repeat: false,
              fit: BoxFit.fitWidth,
              errorBuilder: (_, __, ___) {
                return const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _successContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        children: [
          Text(
            title ?? 'Success!',
            style: textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            description ??
                'Congratulations! Your request has been successfully processed.',
            style: textTheme.bodyLarge?.copyWith(color: NWCColors.trout),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
