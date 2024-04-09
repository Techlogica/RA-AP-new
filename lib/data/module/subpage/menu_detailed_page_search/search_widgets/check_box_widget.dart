import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    Key? key,
    required this.hint,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  final String hint;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              hint,
              style: Theme.of(Get.context!).textTheme.headline1!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto'),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Checkbox(
            activeColor: Theme.of(context).backgroundColor,
            value: isChecked,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

