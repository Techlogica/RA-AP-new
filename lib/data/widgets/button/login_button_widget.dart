import 'package:flutter/material.dart';

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({
    Key? key,
    this.onTap,
    required this.label,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        fixedSize: Size(
          MediaQuery.of(context).size.width,
          50,
        ),
        //primary: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).backgroundColor,
        textStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: onTap,
      child: Text(label.toUpperCase()),
    );
  }
}
