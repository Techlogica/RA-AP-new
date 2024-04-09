import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rapid_app/res/utils/dynamic_fa_icons.dart';
import 'package:rapid_app/res/utils/generate_random_string.dart';

class HomeCardViewWidget extends StatelessWidget {
  const HomeCardViewWidget(
      {Key? key,
      required this.icon,
      required this.title,
      required this.iconColor,
      required this.backgroundColor,
      required this.index,
      this.onTap})
      : super(key: key);

  final String icon;
  final Color backgroundColor, iconColor;
  final String title;
  final VoidCallback? onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(

        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          color: GetTraceId().generateRandomColor(index),
          // color: Colors.cyan
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: viewIcon(
                      icon: icon,
                      iconColor: Theme.of(context).textTheme.headline2!.color!,
                      iconSize: 48),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 5,
                  left: 5,
                  bottom: 5,
                ),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.left,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget viewIcon(
    {required String icon, Color? iconColor, required double iconSize}) {
  if (icon.isEmpty) {
    return Icon(
      Icons.file_copy_outlined,
      size: iconSize,
      color: iconColor,
    );
  } else {
    String iconStr = icon.substring(icon.indexOf('-') + 1);
    String icnString = iconStr.split(' ').first;
    dynamic setIcon = DynamicFaIcons.getIconFromName(icnString);
    if (setIcon == null) {
      return Icon(
        Icons.file_copy_outlined,
        size: iconSize,
        color: iconColor,
      );
    } else {
      return FaIcon(
        setIcon,
        size: iconSize,
        color: iconColor,
      );
    }
  }
}
