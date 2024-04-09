import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/widget_conditions/widget_conditions.dart';
import '../../../../../res/values/strings.dart';

class AdvancedSearchEditTextWidget extends StatelessWidget {
  const AdvancedSearchEditTextWidget({
    Key? key,
    this.textAlign,
    required this.dataType,
    required this.hint,
    required TextEditingController controller,
    this.displayFormat,
    this.encryptType,
    this.iconVisible,
    this.readOnly,
    this.enabled,
  })  : _controller = controller,
        super(key: key);

  final String dataType, hint;
  final String? displayFormat, iconVisible, encryptType, readOnly;
  final TextEditingController _controller;
  final TextAlign? textAlign;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: Theme.of(Get.context!).textTheme.headline1!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            fontFamily: 'Roboto',
          ),
      decoration: _textFieldDecoration(),
      controller: _controller,
      keyboardType: isDataType(
        type: dataType,
        encrypted: encryptType,
      ),
      readOnly: isReadOnly(readOnly),
      cursorColor: Theme.of(context).backgroundColor,
      textAlign: textAlign ?? TextAlign.left,
    );
  }

  InputDecoration _textFieldDecoration() {
    return InputDecoration(
      enabledBorder: Theme.of(Get.context!).inputDecorationTheme.enabledBorder,
      focusedBorder: Theme.of(Get.context!).inputDecorationTheme.focusedBorder,
      focusColor: Theme.of(Get.context!).backgroundColor,
      labelText: hint,
      // hintText: hint,
      labelStyle: TextStyle(
        color: Theme.of(Get.context!).textTheme.headline1!.color!,
        fontSize: 15,
      ),
      enabled: enabled ?? true,
      suffixIcon: Visibility(
        visible: suffixIconVisibility(dataType, iconVisible),
        child: IconButton(
          onPressed: () => _selectDate(_controller, displayFormat),
          icon: suffixIcon(dataType, iconVisible, false),
        ),
      ),
    );
  }
}

void _selectDate(TextEditingController controller, String? displayFormat) {
  showDatePicker(
    context: Get.context!,
    initialDate: DateTime.now(),
    firstDate: DateTime(1950),
    lastDate: DateTime(2050),
    helpText: Strings.kSelectDate.tr.toUpperCase(),
    cancelText: Strings.kCancel.tr.toUpperCase(),
    confirmText: Strings.kOk.tr.toUpperCase(),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
  ).then(
    (value) => {
      if (value == null)
        {controller.text = ''.trim()}
      else
        {
          if (displayFormat == null)
            {
              controller.text = DateFormat('dd/MMM/yyyy').format(value),
            }
          else
            {
              controller.text = DateFormat(displayFormat).format(value),
            }
        }
    },
  );
}
