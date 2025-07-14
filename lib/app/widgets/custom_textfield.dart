import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.hintStyle,
    required this.controller,
    this.validatorMessage,
    this.obsecure = false,
    this.readOnly = false,
    this.prefixIcon,
    this.iconSuffix,
    this.textInputType,
    this.textInputAction,
    this.onChanged,
    this.focusNode,
  });

  final String hintText;
  final TextStyle? hintStyle;
  final TextEditingController controller;
  final String? Function(String?)? validatorMessage;
  final bool obsecure;
  final Icon? prefixIcon;
  final Widget? iconSuffix;
  final TextInputType? textInputType;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      onChanged: onChanged,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      readOnly: readOnly,
      controller: controller,
      obscureText: obsecure,
      style: const TextStyle(height: 1.0),
      decoration: InputDecoration(
        suffixIcon: iconSuffix,
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        isDense: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: hintText,
        hintStyle: hintStyle?.copyWith(
          height: 1.0, // Pastikan height 1.0
        ),
      ),
      validator: validatorMessage,
    );
  }
}
