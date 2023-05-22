import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  TextWidget({
    super.key,
    required this.text,
    required this.color,
    required this.fontSize,
    this.isTitle = false,
    this.maxLines = 10,
  });
  final String text;
  final Color color;
  final double fontSize;
  bool isTitle;
  int maxLines = 10;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          overflow: TextOverflow.ellipsis,
          color: color,
          fontSize: fontSize,
          fontWeight: isTitle ? FontWeight.w300 : FontWeight.normal),
    );
  }
}
