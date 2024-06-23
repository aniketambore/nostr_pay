import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nostr_pay/component_library/component_library.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    required this.isInitial,
  });
  final bool isInitial;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // If it's the initial app launch, navigate to the introduction route after a delay;
    // otherwise, navigate to the main route.
    if (widget.isInitial) {
      Timer(const Duration(milliseconds: 3600), () {
        Navigator.of(context).pushReplacementNamed('/intro');
      });
    } else {
      // For subsequent launches, navigate to the main route after the first frame is rendered.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(54.0),
        child: LogoRotationLoaderLoader(),
      ),
    );
  }
}
