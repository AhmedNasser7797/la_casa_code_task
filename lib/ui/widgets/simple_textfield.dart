import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final String? label;
  final String? initialValue;
  final bool expand;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onChange;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final TextAlign? textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final List<String>? autofillHints;
  final TextInputType? textInputType;
  final bool obSecure;
  final Widget? suffixIcon;

  const SimpleTextField({
    Key? key,
    required this.onSaved,
    this.autofillHints,
    this.onChange,
    this.hintText,
    this.textAlign,
    this.errorText,
    this.initialValue,
    this.controller,
    this.inputFormatters,
    this.expand = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.validator,
    this.textInputType,
    this.obSecure = false,
    this.suffixIcon,
    this.maxLength,
    this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: autofillHints,
      onTap: onTap,
      obscureText: obSecure,
      controller: controller,
      enabled: onSaved != null,
      onChanged: onChange,
      validator: validator,
      onSaved: onSaved,
      inputFormatters: inputFormatters,
      maxLines: expand ? null : maxLines,
      keyboardType: textInputType,
      maxLength: maxLength,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
      initialValue: initialValue,
      textAlign: textAlign ?? TextAlign.start,
      readOnly: readOnly,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        fillColor: const Color(0xff055261).withOpacity(0.05),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        hintStyle: const TextStyle(
          fontSize: 12,
          color: Color(0x4d055261),
          fontWeight: FontWeight.w500,
        ),
        counter: const SizedBox(),
      ),
    );
  }
}
