import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  TextWidget(
      {super.key,
      required this.text,
      required this.color,
      required this.fontSize,
      this.isTitle = false,
      this.maxLines = 10,
      this.fontWeight});
  final String text;
  final Color color;
  final double fontSize;
  // ignore: prefer_typing_uninitialized_variables
  final fontWeight;
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
          fontWeight: fontWeight),
    );
  }
}
