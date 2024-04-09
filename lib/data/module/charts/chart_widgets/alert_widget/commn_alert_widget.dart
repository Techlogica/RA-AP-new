import 'package:flutter/material.dart';

class AlertDialoge extends StatelessWidget {
  AlertDialoge({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final icon;
  String text;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.black,),
            const SizedBox(width: 5,),
            Text(
              text,
              style: const TextStyle(fontSize:14,color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
