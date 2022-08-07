import 'package:flutter/material.dart';
import 'package:ssl_monitor/custom_widget/custom_text.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double? textSize;
  final Color? buttonColor;
  final Color? textColor;
  final EdgeInsets? padding;

  const CustomButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.padding,
      this.textSize = 18,
      this.buttonColor,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: key,
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: buttonColor ?? Colors.blue,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 15),
      ),
      child: CustomText(
        text: text,
        size: textSize,
        color: textColor ?? Colors.white,
      ),
    );
  }
}
