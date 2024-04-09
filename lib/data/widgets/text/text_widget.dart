import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    Key? key,
    required this.text,
    required this.textSize,
    this.alignment,
    required this.textColor,
  }) : super(key: key);

  final String text;
  final double textSize;
  final TextAlign? alignment;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: alignment,
        style: Theme.of(context).textTheme.subtitle2!.copyWith(
              fontSize: textSize,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: textColor,
            ));
  }
}
