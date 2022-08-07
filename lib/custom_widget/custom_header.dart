import 'package:flutter/material.dart';
import 'package:ssl_monitor/custom_widget/custom_text.dart';

class CustomHeader extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final IconData actionIcon;
  final String text;
  final double? textSize;
  final Color cardColor;
  final Color? textColor;
  final Widget? leadingWidget;

  const CustomHeader({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.actionIcon,
    required this.text,
    required this.cardColor,
    this.textSize,
    this.textColor,
    this.leadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(13),
          ),
          child: leadingWidget,
        ),
        CustomText(
          text: text,
          size: textSize ?? 18,
          color: textColor ?? Colors.white,
        ),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(13),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              actionIcon,
              size: 30,
              color: textColor ?? Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
