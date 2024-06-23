import 'package:flutter/material.dart';
import 'package:nostr_pay/component_library/component_library.dart';

class ProcessingPaymentLoader extends StatefulWidget {
  const ProcessingPaymentLoader({super.key});

  @override
  State<ProcessingPaymentLoader> createState() =>
      _ProcessingPaymentLoaderState();
}

class _ProcessingPaymentLoaderState extends State<ProcessingPaymentLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Adjust the duration as needed
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // color: NWCColors.woodSmoke,
          border: Border.all(
            color: NWCColors.trout,
            width: 2,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: NWCIcon(NWCIcons.nwc),
        ),
      ),
    );
  }
}
