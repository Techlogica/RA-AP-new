import 'package:flutter/material.dart';

class DrawerElevatedButtonWidget extends StatelessWidget {
  const DrawerElevatedButtonWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.colorIconTitle,
    required this.colorBackground,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Color colorIconTitle, colorBackground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextButton.icon(
        icon: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 24.0,
        ),
        label: Text(
          title,
          style: Theme.of(context).textTheme.headline2!.copyWith(
              fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.w600),
        ),
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(10),
        ),
        onPressed: onTap,
      ),
    );
  }
}
