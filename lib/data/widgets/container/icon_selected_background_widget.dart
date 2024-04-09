import 'package:flutter/material.dart';
import 'package:rapid_app/res/values/colours.dart';
import '../shadow/inner_shadow.dart';

class IconSelectedBackgroundWidget extends StatefulWidget {
  const IconSelectedBackgroundWidget({
    Key? key,
    this.icon,
    required this.backgroundColor,
    required this.iconColor,
  }) : super(key: key);

  final IconData? icon;
  final Color backgroundColor, iconColor;

  @override
  State<IconSelectedBackgroundWidget> createState() =>
      _IconSelectedBackgroundWidgetState();
}

class _IconSelectedBackgroundWidgetState
    extends State<IconSelectedBackgroundWidget> {
  @override
  Widget build(BuildContext context) {
    return InnerShadow(
      blur: 1,
      color: colours.black,
      offset: const Offset(1, 1),
      child: Container(
        alignment: Alignment.center,
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
          color: widget.backgroundColor,
        ),
        child: Icon(
          widget.icon,
          size: 24,
          color: widget.iconColor,
        ),
      ),
    );
  }
}
