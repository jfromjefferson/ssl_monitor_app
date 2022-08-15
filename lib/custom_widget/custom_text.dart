import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextAlign? align;
  final Color? color;
  final FontWeight? weight;
  final double? size;
  final double? spacing;
  final TextOverflow? overflow;
  final bool? softWrap;

  const CustomText({
    Key? key,
    required this.text,
    this.align,
    this.color,
    this.weight,
    this.size,
    this.spacing,
    this.overflow,
    this.softWrap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      key: key,
      text,
      overflow: overflow,
      softWrap: softWrap,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontWeight: weight,
        fontSize: size,
        letterSpacing: spacing,
      ),
    );
  }
}
