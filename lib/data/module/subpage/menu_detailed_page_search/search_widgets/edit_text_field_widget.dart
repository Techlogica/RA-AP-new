import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/widget_conditions/widget_conditions.dart';
import 'package:rapid_app/res/values/strings.dart';

class EditTextFieldWidget extends StatelessWidget {
  const EditTextFieldWidget({
    Key? key,
    required TextEditingController controller,
    required this.dataType,
    required this.hint,
    required this.editMode,
    this.displayFormat,
    this.iconVisible,
    this.encryptType,
    this.readOnly,
    this.enabled,
    this.keyInfo,
    required this.obscureText,
    this.obscureClick,
    this.onValueChanged,
    required this.dateClick,
  })  : _controller = controller,
        super(key: key);

  final String dataType, hint, editMode;
  final String? displayFormat, iconVisible, encryptType, readOnly, keyInfo;
  final TextEditingController _controller;
  final bool? enabled;
  final bool obscureText;
  final VoidCallback? obscureClick;
  final VoidCallback dateClick;
  final ValueChanged<String>? onValueChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: Theme.of(Get.context!).textTheme.headline1!.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: 'Roboto',
      ),
      decoration: _textFieldDecoration(),
      // enabled: enabled ?? true,
      enabled: readOnly == 'Y' ? false : true,
      controller: controllerValue(_controller, displayFormat, dataType),
      keyboardType: isDataType(
        type: dataType,
        encrypted: encryptType,
      ),
      obscureText: encryptType == 'Y' ? true : false,
      readOnly: isReadOnly(readOnly),
      cursorColor: Theme.of(context).backgroundColor,
      textInputAction: TextInputAction.next,
      textAlign: dataType == 'INT' || dataType == 'DECIMAL'
          ? TextAlign.right
          : TextAlign.left,
      onChanged: onValueChanged,
    );
  }

  InputDecoration _textFieldDecoration() {
    return InputDecoration(
      enabledBorder: Theme.of(Get.context!).inputDecorationTheme.enabledBorder,
      disabledBorder:
      Theme.of(Get.context!).inputDecorationTheme.disabledBorder,
      focusedBorder: Theme.of(Get.context!).inputDecorationTheme.focusedBorder,
      focusColor: Theme.of(Get.context!).backgroundColor,
      labelText: hint,
      hintText: hint,
      labelStyle: TextStyle(
        color: Theme.of(Get.context!).textTheme.headline1!.color!,
        fontSize: 12,
      ),
      suffixIcon: Visibility(
        visible: suffixIconVisibility(dataType, iconVisible),
        child: IconButton(
          onPressed: () {
            // if (readOnly != 'Y') {
            if (dataType == 'DATE') {
              _selectDate(_controller, displayFormat, dateClick);
            } else {
              if (obscureClick != null) {
                obscureClick!();
              }
            }
            // }
          },
          icon: suffixIcon(dataType, iconVisible, obscureText),
        ),
      ),
    );
  }
}

TextEditingController controllerValue(
    TextEditingController controller, String? displyFormat, String? dataType) {
  if (dataType == 'DATE') {
    return setControllerValue(controller, displyFormat);
  } else if (dataType == 'INT') {
    String value = controller.text ?? '';
    controller.value = TextEditingValue(text: value);
    if (value != '') {
      var arr = value.split('.').first;
      controller.value = TextEditingValue(text: arr.toString());
    }
    return controller;
  } else {
    return controller;
  }
}

TextEditingController setControllerValue(
    TextEditingController controller, String? displyFormat) {
  if (controller.text.isEmpty || controller.text == 'null') {
    print('....................date');
    return controller;
  } else {
    if (displyFormat.toString().isEmpty) {
      try {
        DateTime date = DateTime.parse(controller.text.toString());
        print('....................date$date');
        dynamic value = DateFormat('dd/MMM/yy').format(date).toString();
        controller.value = TextEditingValue(text: value);
        return controller;
      } catch (error) {
        return controller;
      }
    } else {
      try {
        DateTime date = DateTime.parse(controller.text.toString());
        print('.............date$date');
        dynamic value = DateFormat(displyFormat).format(date).toString();
        controller.value = TextEditingValue(text: value);
        return controller;
      } catch (error) {
        return controller;
      }
    }
  }
}

_selectDate(TextEditingController controller, String? displayFormat,
    VoidCallback dateClick) {
  showDatePicker(
    context: Get.context!,
    initialDate: DateTime.now(),
    firstDate: DateTime(190),
    lastDate: DateTime(2050),
    helpText: Strings.kSelectDate.tr.toUpperCase(),
    cancelText: Strings.kCancel.tr.toUpperCase(),
    confirmText: Strings.kOk.tr.toUpperCase(),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
  ).then(
        (value) => {
      if (value == null)
        {
          controller.text = controller.text.trim(),
          dateClick(),
        }
      else
        {
          if (displayFormat == null || displayFormat.isEmpty)
            {
              controller.text =
                  DateFormat('dd/MMM/yy').format(value).toString(),
              dateClick(),
            }
          else
            {
              controller.text =
                  DateFormat(displayFormat).format(value).toString(),
              dateClick(),
            }
        }
    },
  );
}
