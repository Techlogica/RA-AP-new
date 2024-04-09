import 'package:flutter/material.dart';

class IconUnselectedBackgroundWidget extends StatefulWidget {
  const IconUnselectedBackgroundWidget({
    Key? key,
    this.icon,
    required this.backgroundColor,
    required this.iconColor,
  }) : super(key: key);

  final IconData? icon;
  final Color backgroundColor, iconColor;

  @override
  State<IconUnselectedBackgroundWidget> createState() => _IconUnselectedBackgroundWidgetState();
}

class _IconUnselectedBackgroundWidgetState extends State<IconUnselectedBackgroundWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        alignment: Alignment.center,
        width: 40,
        height: 40,
        // margin: const EdgeInsets.only(right: 10),
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
