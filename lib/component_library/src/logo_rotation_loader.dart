import 'package:flutter/material.dart';
import 'package:nostr_pay/component_library/component_library.dart';

class LogoRotationLoaderLoader extends StatefulWidget {
  const LogoRotationLoaderLoader({super.key});

  @override
  State<LogoRotationLoaderLoader> createState() =>
      _LogoRotationLoaderLoaderState();
}

class _LogoRotationLoaderLoaderState extends State<LogoRotationLoaderLoader>
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
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: NWCColors.woodSmoke,
          image: DecorationImage(
            image: AssetImage('assets/images/nostr_pay_logo.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
