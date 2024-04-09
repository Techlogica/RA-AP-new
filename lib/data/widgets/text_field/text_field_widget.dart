import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.hint,
    this.validate = false,
    this.readOnlyVal = false,
    this.needCloseIcon = false,
    this.errorMessage,
    required TextEditingController controller,
    this.onTextChange,
  })  : _controller = controller,
        super(key: key);

  final String hint;
  final TextEditingController _controller;
  final Function? onTextChange;
  final bool validate;
  final String? errorMessage;
  final bool? readOnlyVal;
  final bool? needCloseIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: Theme.of(context).textTheme.headline1!.copyWith(
          fontSize: 15, fontWeight: FontWeight.normal, fontFamily: 'Roboto'),
      decoration: InputDecoration(
        suffix: needCloseIcon!
            ? InkWell(
                onTap: () {
                  _controller.clear();
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.grey,
                  size: 25,
                ),
              )
            : const SizedBox(),
        labelText: hint,
        errorText: validate ? errorMessage : null,
        labelStyle: Theme.of(context).textTheme.headline1!.copyWith(
            fontSize: 15, fontWeight: FontWeight.normal, fontFamily: 'Roboto'),
        enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
      ),
      controller: _controller,
      keyboardType: TextInputType.name,
      obscureText: false,
      cursorColor: Theme.of(context).backgroundColor,
      onChanged: (text) {
        onTextChange!(text);
      },
      readOnly: readOnlyVal!,
    );
  }
}
