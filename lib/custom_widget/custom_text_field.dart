import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final double? size;
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatter;
  final TextEditingController? controller;
  final int? maxLines;
  final int? maxLength;
  final bool? autoFocus;
  final bool? readOnly;
  final bool? obscureText;
  final Color? fillColor;
  final bool? filled;
  final IconData? icon;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final VoidCallback? onPressed;
  final Color? textColor;
  final TextCapitalization? textCapitalization;
  final FontWeight? weight;
  final double? borderRadius;
  final Function(String)? onSubmitted;
  final bool? outline;
  final bool? enableSuggestions;
  final bool? autoCorrect;

  const CustomTextField({
    Key? key,
    this.size,
    required this.hintText,
    required this.onChanged,
    this.onPressed,
    this.inputType,
    this.inputFormatter,
    this.controller,
    this.maxLines,
    this.maxLength,
    this.autoFocus,
    this.readOnly,
    this.obscureText,
    this.fillColor,
    this.filled,
    this.icon,
    this.suffixIcon,
    this.suffixIconColor,
    this.textColor,
    this.textCapitalization,
    this.weight,
    this.borderRadius,
    this.onSubmitted,
    this.outline,
    this.enableSuggestions,
    this.autoCorrect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: key,
      enableSuggestions: enableSuggestions ?? true,
      autocorrect: autoCorrect ?? true,
      onSubmitted: onSubmitted,
      obscureText: obscureText ?? false,
      autofocus: autoFocus ?? false,
      readOnly: readOnly ?? false,
      controller: controller,
      onChanged: onChanged,
      keyboardType: inputType,
      inputFormatters: inputFormatter,
      textCapitalization: textCapitalization ?? TextCapitalization.sentences,
      textAlign: TextAlign.start,
      maxLength: maxLength,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        fontSize: size,
        color: textColor ?? Colors.white,
        fontWeight: weight,
      ),
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderSide: outline != null
              ? const BorderSide(color: Colors.red)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius ?? 3),
        ),
        labelText: hintText,
        alignLabelWithHint: true,
        labelStyle: TextStyle(
          height: 2,
          color: textColor ?? Colors.white,
        ),
        filled: filled ?? true,
        fillColor: fillColor ?? Colors.grey,
        hintText: hintText,
        icon: icon != null ? Icon(icon, size: 30, color: textColor) : null,
        suffixIcon: IconButton(
          onPressed: onPressed,
          icon: Icon(
            suffixIcon,
            size: 30,
            color: suffixIconColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
