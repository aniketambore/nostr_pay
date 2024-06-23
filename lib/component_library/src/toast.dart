import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

export 'package:toastification/toastification.dart';

Toastification showToast(
  BuildContext context, {
  required String title,
  ToastificationType? type = ToastificationType.success,
  ToastificationStyle? style = ToastificationStyle.minimal,
  Duration? autoCloseDuration = const Duration(seconds: 5),
  AlignmentGeometry? alignment,
}) {
  final textTheme = Theme.of(context).textTheme;

  Toastification? toastification;

  toastification = Toastification()
    ..show(
      context: context,
      type: type,
      style: style,
      title: Text(
        title,
        style: textTheme.bodyMedium,
      ),
      autoCloseDuration:
          autoCloseDuration == Duration.zero ? null : autoCloseDuration,
      alignment: alignment,
    );

  return toastification;
}
