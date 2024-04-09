import 'package:flutter/material.dart';

class LoginTextFieldWidget extends StatelessWidget {
  // hint,icon,controller
  const LoginTextFieldWidget({
    Key? key,
    required this.hint,
    required TextEditingController controller,
    this.prefixIcon,
    required this.keyboardType,
    required this.obscureText,
    this.obscureClick,
    this.shouldDisplayEyeIcon = false,
  })  : _controller = controller,
        super(key: key);

  final String hint;
  final TextEditingController _controller;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final VoidCallback? obscureClick;
  final bool shouldDisplayEyeIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: Theme.of(context).textTheme.headline1!.copyWith(
          fontSize: 20, fontWeight: FontWeight.normal, fontFamily: 'Roboto'),
      cursorColor: Theme.of(context).backgroundColor,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: Theme.of(context).textTheme.headline1!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              fontFamily: 'Roboto',
            ),
        prefixIcon: Icon(
          prefixIcon,
          color: Theme.of(context).backgroundColor,
        ),
        suffixIcon: Visibility(
          visible: shouldDisplayEyeIcon,
          child: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).backgroundColor,
            ),
            onPressed: obscureClick,
          ),
        ),
      ),
      controller: _controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}
