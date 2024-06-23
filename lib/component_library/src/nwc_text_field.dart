import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nostr_pay/component_library/component_library.dart';

class NWCTextField extends StatelessWidget {
  const NWCTextField({
    super.key,
    // required this.label,
    required this.hintText,
    this.style,
    this.controller,
    this.focusNode,
    this.maxLines = 1,
    this.textInputAction,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.autocorrect = true,
    this.enabled,
    this.errorText,
    this.readOnly = false,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.maxLengthEnforcement,
  });
  // final String label;
  final String hintText;
  final TextStyle? style;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final TextInputType? keyboardType;
  final NWCIcon? suffixIcon;
  final NWCIcon? prefixIcon;
  final Function(String)? onChanged;
  final bool autocorrect;
  final bool? enabled;
  final String? errorText;
  final bool readOnly;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final MaxLengthEnforcement? maxLengthEnforcement;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      maxLines: maxLines,
      style: style ?? textTheme.bodyLarge?.copyWith(color: NWCColors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textTheme.bodyLarge,
        contentPadding: const EdgeInsets.all(16),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: NWCColors.black,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: NWCColors.black),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: NWCColors.black),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: prefixIcon,
              )
            : null,
      ),
      cursorColor: NWCColors.woodSmoke,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      autocorrect: autocorrect,
      enabled: enabled,
      readOnly: readOnly,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLengthEnforcement: maxLengthEnforcement,
    );
  }
}
