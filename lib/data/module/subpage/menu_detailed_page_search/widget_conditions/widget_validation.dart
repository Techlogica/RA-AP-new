// flag --->  I-insert,E-edit & B-both
import 'dart:convert';
import 'package:rapid_app/data/api/api_client.dart';
import 'package:rapid_app/data/model/base/base_response.dart';
import 'package:rapid_app/res/values/strings.dart';

bool isEmail({required String eMail}) {
  bool isValid = false;
  isValid =
      RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))'
              r'@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|('
              r'([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(eMail);
  return isValid;
}

bool isMobileNumber({required String mobNumber}) {
  bool isValid = false;
  if (mobNumber.isNotEmpty) {
    isValid =
        RegExp(r'(^^((\+){0,1}91(\s){0,1}(\-){0,1}(\s){0,1}){0,1}[6,7,8,9][0-9]'
                r'(\s){0,1}(\-){0,1}(\s){0,1}[0-9]{1}[0-9]{7}$)')
            .hasMatch(mobNumber);
    return isValid;
  }
  return isValid;
}

bool isPinCode({required String pinCode}) {
  bool isValid = false;
  if (pinCode.isNotEmpty) {
    isValid = RegExp(r'^[1-9][0-9]{5}$').hasMatch(pinCode);
    return isValid;
  }
  return isValid;
}

bool isNumber({required String number}) {
  bool isValid = false;
  if (number.isNotEmpty) {
    isValid = RegExp(r'^-?[0-9]+$').hasMatch(number);
    return isValid;
  }
  return isValid;
}

bool isMinLength({required String value, int? colLength}) {
  bool isValid = false;
  if (value.length >= colLength!) {
    isValid = true;
  }
  return isValid;
}

bool isMaxLength({required String value, int? colLength}) {
  bool isValid = false;
  if (value.length <= colLength!) {
    isValid = true;
  }
  return isValid;
}

bool isGreaterThan({required String value, int? colLength}) {
  bool isValid = false;
  if (value.length > colLength!) {
    isValid = true;
  }
  return isValid;
}

bool isGreaterThanEqual({required String value, int? colLength}) {
  bool isValid = false;
  if (value.length >= colLength!) {
    isValid = true;
  }
  return isValid;
}

bool isLessThan({required String value, int? colLength}) {
  bool isValid = false;
  if (value.length < colLength!) {
    isValid = true;
  }
  return isValid;
}

bool isLessThanEqual({required String value, int? colLength}) {
  bool isValid = false;
  if (value.length <= colLength!) {
    isValid = true;
  }
  return isValid;
}

bool isDate({required String value}) {
  bool isValid = false;
  if (value.isNotEmpty) {
    isValid = true;
  }
  return isValid;
}

bool isConfirmPassword({required String value, String? condition}) {
  bool isValid = false;
  if (value == condition) {
    isValid = true;
  }
  return isValid;
}

Future<bool> isQueryValue({required String value, String? valQuery}) async {
  bool isValid = false;
  if (value.isNotEmpty && valQuery!.isNotEmpty) {
    final response = await executeQuery(query: valQuery, param: []);
    if (response.status) {
      if (response.data.length != 0) {
        isValid = true;
      }
    }
  }
  return isValid;
}

Future<bool> isQueryParam(
    {required String value,
    String? valQuery,
    required dynamic saveDataMap}) async {
  bool isValid = false;
  if (value.isNotEmpty && valQuery!.isNotEmpty) {
    List<Map<String, dynamic>> paramsData = [];
    Map<String, String> allColumns = saveDataMap;

    for (var key in allColumns.keys) {
      if (valQuery.contains(key)) {
        String keyValue = allColumns[key].toString();
        dynamic prms = {Strings.kName: key, Strings.kValue: '%$keyValue%'};

        ///key-value param
        paramsData.add(prms);
      }
    }

    /// encode key-value param list
    dynamic param = json.encode(paramsData);
    final response = await executeQuery(query: valQuery, param: param);
    if (response.status) {
      if (response.data.length != 0) {
        isValid = true;
      }
    }
  }
  return isValid;
}

Future<bool> isUnique(
    {required String value, String? valQuery, String? columnName}) async {
  bool isValid = false;
  if (value.isNotEmpty && valQuery!.isNotEmpty) {
    String query = "$valQuery WHERE $columnName = '$value'";
    final response = await executeQuery(query: query, param: []);
    if (response.status) {
      if (response.data.length == 0) {
        isValid = true;
      }
    }
  }
  return isValid;
}

Future<BaseResponse> executeQuery({
  required String query,
  required dynamic param,
}) async {
  /// Getting meta data from the API
  BaseResponse result = await ApiClient().rapidRepo.getCommonSearch(
        query: query,
        param: param,
      );
  return result;
}
