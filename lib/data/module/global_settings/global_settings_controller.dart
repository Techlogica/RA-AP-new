import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/combo_concatenate.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/logs/logs.dart';

import '../../../res/utils/dynamic_default_value_generation/default_concatenator.dart';
import '../../../res/utils/dynamic_default_value_generation/default_value.dart';
import '../../../res/values/strings.dart';
import '../../model/combo_box_model/lookup_response.dart';
import '../../model/metadata_columns_model/metadata_columns_response.dart';
import '../subpage/tag_box_table_gridview/tag_box_table_grid_binding.dart';
import '../subpage/tag_box_table_gridview/tag_box_table_grid_page.dart';

class GlobalSettingsController extends RapidController {
  late String tableId,
      tableName,
      keyInfo,
      tableWhere,
      pkKeyName = '',
      pkKeyValue;

  List<MetadataColumnsResponse> allColumnList = [];
  RxList<MetadataColumnsResponse> visibleColumnList = RxList([]);
  Map<String, TextEditingController> textEditingControllerMap = {};
  RxMap<String, dynamic> allColumnsValueMap = RxMap({});
  RxBool isValueCheck = false.obs;
  RxBool isSaveBtnVisible = false.obs;

  RxMap<String, bool> checkBoxList = RxMap({});

  RxMap<String, List<LookupResponse>> lookupList = RxMap({});
  RxMap<String, String> lookupValue = RxMap({});

  Map<String, dynamic> selectedTagbox = {};
  RxMap<String, String> tagboxValue = RxMap({});

  /// editFlag = true --> edit data ,editFlag = false --> add data
  bool editFlag = false;

  Map<String, dynamic> saveMap = {};

  @override
  void onInit() {
    double? sysId = RapidPref().getGlobalSettingsTableId();
    if (sysId.toString().contains('.0')) {
      tableId = sysId.toString().replaceAll('.0', '');
    } else {
      tableId = sysId.toString();
    }

    getGlobalSettingsTable();
    super.onInit();
  }

  TextEditingController getControllerValue(String columnName, int index) {
    /// Checking if the controller is already created
    if (!textEditingControllerMap.containsKey(columnName)) {
      // Taking the initial value from the response
      String initialValue = '';
      for (var key in allColumnsValueMap.keys) {
        if (key.trim() == columnName.trim()) {
          initialValue = allColumnsValueMap[key].toString() == "null"
              ? ''
              : allColumnsValueMap[key].toString();
        }
      }

      /// creating new [TextEditingController] with [initialValue]
      textEditingControllerMap[columnName] =
          TextEditingController(text: initialValue);
    }

    return textEditingControllerMap[columnName]!;
  }

  Future<void> getGlobalSettingsTable() async {
    final response =
        await apiClient.rapidRepo.getMetaDataTableData(sysId: tableId);
    if (response.status) {
      isSaveBtnVisible.value = true;
      dynamic res = response.data[0];
      Map<String, dynamic> dataMap = res;
      tableName = dataMap['MDT_TBL_NAME'].toString();
      tableWhere = dataMap['MDT_DEFAULTWHERE'].toString();

      /// fetch columns
      getGlobalSettingsColumn();
    } else {
      isSaveBtnVisible.value = false;
    }
  }

  Future<void> fetchGlobalSettingsValue() async {
    String defaultValue =
        await defaultConcatenation(formula: tableWhere, prtTbName: tableName);
    final response = await apiClient.rapidRepo.getGlobalSettingValue(
      tableName: tableName,
      where: defaultValue,
    );
    if (response.status) {
      dynamic responseData = response.data;
      if (responseData.length == 0) {
        editFlag = false;
      } else {
        editFlag = true;
        allColumnsValueMap.value = responseData[0];
        pkKeyValue = allColumnsValueMap[pkKeyName].toString();

        int index = visibleColumnList.indexWhere((element) => element.mdcDatatype == 'LOOKUP');
        String columnName = visibleColumnList[index].mdcColName;
        dynamic valueField = allColumnsValueMap[columnName];

        lookupValue[columnName] = valueField.toString();
        List<LookupResponse> lookupArray = lookupList[columnName]!;
        if (lookupArray.isNotEmpty) {
          String tempVal = valueField.toString();
          if (tempVal.contains('.0')) {
            tempVal = tempVal.substring(0, tempVal.length - 2);
          }
          int index = lookupArray.indexWhere((element) =>
              element.valueField == valueField ||
              element.valueField == tempVal);
          allColumnsValueMap[columnName] = lookupArray[index].textField;
        }
      }
    }
    isValueCheck.value = true;
  }

  getGlobalSettingsColumn() async {
    final metadataColumnsTableResponse =
        await apiClient.rapidRepo.getMetadataColumns(sysId: tableId);
    if (metadataColumnsTableResponse.status) {
      final data = metadataColumnsTableResponse.data;
      for (int i = 0; i < data.length; ++i) {
        final encodeData = json.encode(data[i]);
        dynamic decodeData = json.decode(encodeData);
        MetadataColumnsResponse res =
            MetadataColumnsResponse.fromJson(decodeData);
        allColumnList.add(res);
      }

      /// sort list data
      allColumnList.sort((a, b) => a.mdcSeqnum.compareTo(b.mdcSeqnum));

      /// replace default Values
      for (int i = 0; i < allColumnList.length; ++i) {
        if (allColumnList[i].mdcKeyinfo == 'PK') {
          pkKeyName = allColumnList[i].mdcColName;
        }
        dynamic defaultVal = '';
        if (allColumnList[i].mdcDefaultvalue!.isNotEmpty) {
          defaultVal = await getDefaultValues(
            allColumnList[i].mdcDefaultvalue!,
            allColumnsValueMap,
            tableName,
            allColumnsValueMap,
            allColumnList[i].mdcDatatype!,
          );
          defaultVal = defaultVal['val'];
        }
        allColumnsValueMap[allColumnList[i].mdcColName] = defaultVal;
      }

      /// check where condition
      List<MetadataColumnsResponse> menuColumns =
          allColumnList.where((element) => element.mdcVisible == 'Y').toList();
      visibleColumnList.value = menuColumns;

      for (int i = 0; visibleColumnList.length > i; i++) {
        if (visibleColumnList[i].mdcDatatype == 'LOOKUP') {
          await getLookup(
            fieldName: visibleColumnList[i].mdcColName,
            query: visibleColumnList[i].mdcComboqry!,
            where: visibleColumnList[i].mdcCombowhere,
          );
        }
        if (visibleColumnList[i].mdcDatatype == 'CHECKBOXSTR' ||
            visibleColumnList[i].mdcDatatype == 'CHECKBOX') {
          checkBoxList[visibleColumnList[i].mdcColName] = false;
        }
      }

      /// fetch saved values
      await fetchGlobalSettingsValue();
    }
  }

  Future<void> getLookup({
    required String fieldName,
    required String query,
    String? where,
  }) async {
    String convertedWhere = await comboConcatenate(
        fformula: where!, obj: allColumnsValueMap, ptbName: tableName);
    final response = await apiClient.rapidRepo
        .getLookupData(query: query, where: convertedWhere);
    if (response.status) {
      List<dynamic> dataResponse = response.data;
      List<LookupResponse> lookupData = [];
      for (int i = 0; i < dataResponse.length; ++i) {
        dynamic encodeData = json.encode(dataResponse[i]);
        final decode = json.decode(encodeData);
        LookupResponse response = LookupResponse.fromJson(decode);
        lookupData.add(response);
      }
      lookupList[fieldName] = lookupData;
      lookupValue[fieldName] = '';
    }
  }

  void getChildTable(int i, TextEditingController textEditingController) async {
    if (visibleColumnList[i].mdcDatatype == 'TAGBOX' ||
        visibleColumnList[i].mdcDatatype == 'SFTAGBOX') {
      final result = await Get.to(() => const TagBoxTableGridPage(),
          binding: TagBoxTableGridBinding(),
          arguments: {
            'column': visibleColumnList[i],
            'menuName': tableName,
            'rowData': allColumnsValueMap,
            'editValue': textEditingController.text,
          });
      Map<String, dynamic> tagBoxMap = {};
      tagBoxMap.addAll(result['tagBox']);
      Logs.logData("tagbox:::", tagBoxMap.toString());

      /// store selected column text and value fields
      selectedTagbox[result['MDC_TEXTFIELDNAME']] =
          tagBoxMap[visibleColumnList[i].mdcValuefieldname];
      tagboxValue[visibleColumnList[i].mdcColName] =
          tagBoxMap[visibleColumnList[i].mdcValuefieldname];

      /// set selected column textfield to controller
      textEditingController.value = TextEditingValue(
        text: result['MDC_TEXTFIELDNAME'],
      );
    } else {
      Logs.logData('TagBox', 'else Case');
    }
  }

  Future<String> getTagboxValue({
    required String value,
    required String comboWhere,
    required String textField,
    required String comboQry,
    required String valueField,
    required columnName,
  }) async {
    String query = '';
    if (comboWhere == '') {
      query = "SELECT $textField FROM ($comboQry) WHERE "
          "$valueField = '$value'";
    } else {
      query = "SELECT $textField FROM ($comboQry WHERE "
          "$comboWhere) WHERE $valueField = '$value'";
    }

    final response = await apiClient.rapidRepo.getBaseData(query);
    if (response.status) {
      String textData = response.data[0][textField].toString();
      selectedTagbox[textData] = value;
      tagboxValue[columnName] = value;
      return textData;
    } else {
      return value;
    }
  }

  void saveGlobalSettingValue() async {
    bool flagUpdate = true;
    saveMap.clear();

    for (var key in allColumnsValueMap.keys) {
      saveMap[key] = allColumnsValueMap[key];
    }

    for (int i = 0; i < allColumnList.length; ++i) {
      if (allColumnList[i].mdcKeyinfo == 'CRDT') {
        /// get current date
        var now = DateTime.now();
        var formatter = DateFormat("dd/MMM/yy");
        String currentDate = formatter.format(now);
        saveMap[allColumnList[i].mdcColName] = currentDate;
      }
    }

    String globalKey = '';
    String globalValue = '';
    for (var key in textEditingControllerMap.keys) {
      int columnIndex = visibleColumnList
          .indexWhere((element) => element.mdcColName.contains(key));
      String columnDataType =
          visibleColumnList[columnIndex].mdcDatatype.toString().trim();
      if (columnDataType == 'LOOKUP') {
        String value = lookupValue[key].toString();
        if (value == '') {
          flagUpdate = false;
          Get.snackbar(
            Strings.kMessage,
            'Wrong ${visibleColumnList[columnIndex]..mdcMetatitle}',
            duration: const Duration(seconds: 10),
          );
        } else {
          saveMap[key] = value;
          debugPrint("...........if:${saveMap[key]}");
        }
      } else if (columnDataType == 'TAGBOX' || columnDataType == 'SFTAGBOX') {
        String value = tagboxValue[key].toString();
        if (value == 'null') {
          flagUpdate = false;
          Get.snackbar(
            Strings.kMessage,
            'Wrong ${visibleColumnList[columnIndex]..mdcMetatitle}',
            duration: const Duration(seconds: 10),
          );
        } else {
          saveMap[key] = value;
        }
      } else {
        saveMap[key] = textEditingControllerMap[key]!.value.text;
        debugPrint("...........${saveMap[key]}");
      }
      globalKey = key;
      globalValue = saveMap[key].toString();
      debugPrint("...........$globalValue");
    }

    /// remove empty and null values
    saveMap.removeWhere((key, value) => '$value'.isEmpty);
    saveMap.removeWhere((key, value) => '$value' == 'null');

    if (flagUpdate) {
      RapidPref().setGlobalSettingKey(globalKey);
      RapidPref().setGlobalSettingValue(globalValue);
      if (editFlag) {
        /// update
        updateQuery(saveMap);
      } else {
        /// add
        final encodeBody = jsonEncode(saveMap);
        addOrEdit(tableName: tableId, body: encodeBody);
      }
    }
  }

  void updateQuery(Map<String, dynamic> saveMap) {
    String updateData = '';
    for (var key in saveMap.keys) {
      updateData = updateData + ", $key = '${saveMap[key]}'";
      debugPrint('...................$updateData');
    }

    /// remove first ','
    updateData = updateData.trim().replaceFirst(',', '').trim();

    /// query
    String queryData =
        "UPDATE $tableName SET $updateData WHERE $pkKeyName='$pkKeyValue'";

    /// body
    dynamic queryBody = {Strings.kQuery: queryData};
    dynamic body = json.encode(queryBody);
    addOrEdit(tableName: 'UpdateData', body: body);
  }

  /// add or edit
  Future<void> addOrEdit({
    required String tableName,
    required dynamic body,
  }) async {
    /// Getting meta data frm the API
    final menuDataResponse = await apiClient.rapidRepo
        .getInsertData(body: body, tableName: tableName);
    if (menuDataResponse.status) {
      if (!editFlag) {
        dynamic insertId = menuDataResponse.data;
        pkKeyValue = insertId.toString();
      }
      editFlag = true;
      Get.snackbar(Strings.kMessage, Strings.kUpdateMessage);
      Get.offAllNamed(Strings.kHomePage);
    } else {
      Get.snackbar(Strings.kMessage, menuDataResponse.message,
          duration: const Duration(seconds: 15));
    }
  }
}
