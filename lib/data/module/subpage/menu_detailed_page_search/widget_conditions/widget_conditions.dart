import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool isReadOnly(String? type) {
  if (type == 'Y') {
    return true;
  } else {
    return false;
  }
}

dynamic isDataType({String? type, String? encrypted}) {
  switch (type) {
    case 'DECIMAL':
      return TextInputType.number;
    case 'STRING':
      return encrypted == 'Y' ? TextInputType.visiblePassword : TextInputType.name;
    case 'DATE':
      return TextInputType.none;
    case 'INT':
      return TextInputType.number;
    case 'LOCATION':
      return TextInputType.name;
    case 'TAGBOX':
      return TextInputType.none;
    case 'SFTAGBOX':
      return TextInputType.none;
    default:
      return TextInputType.name;
  }
}

Icon suffixIcon(
    String dataType, String? encryptedPasswordIcon, bool obscureText) {
  switch (dataType) {
    case 'DATE':
      return const Icon(Icons.calendar_today_outlined);
    case 'STRING':
      return (encryptedPasswordIcon == 'Y')
          ? obscureText
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.remove_red_eye)
          : const Icon(Icons.clear);
    default:
      return const Icon(Icons.clear);
  }
}

bool suffixIconVisibility(String dataType, String? encryptedPasswordIcon) {
  switch (dataType) {
    case 'DATE':
      return true;
    case 'STRING':
      return (encryptedPasswordIcon == 'Y') ? true : false;
    default:
      return false;
  }
}

dynamic buttonAction({
  required String action,
  RxList<TextEditingController>? requiredFieldController,
}) {
  switch (action) {
    case 'Alert':
      break;
    case 'BeginTrans':
      break;
    case 'Cancel':
      requiredFieldController?.clear();
      break;
    case 'Close':
      Get.back();
      break;
    case 'CommitTrans':
      break;
    case 'DbProcedure':
      break;
    case 'Message':
      break;
    case 'RefreshChild':
      break;
    case 'Report':
      break;
    case 'SMS':
      break;
    case 'Save':
      break;
    case 'Search':
      break;
    case 'SearchAll':
      break;
    case 'Task':
      break;
    case 'URL':
      break;
    case 'Update':
      break;
  }
}
