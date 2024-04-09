import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rapid_app/data/model/advanced_search_model/advanced_search_child_response.dart';
import 'package:rapid_app/data/model/combo_box_model/lookup_response.dart';
import 'package:rapid_app/data/model/metadata_actions_model/metadata_actions_response.dart';
import 'package:rapid_app/data/model/metadata_columns_model/metadata_columns_response.dart';
import 'package:rapid_app/data/model/metadata_command_model/metadata_command_response.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/menu_advanced_search_grid/menu_detailed_advanced_search_grid_binding.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/menu_advanced_search_grid/menu_detailed_advanced_search_grid_page.dart';
import 'package:rapid_app/data/module/subpage/tag_box_table_gridview/tag_box_table_grid_binding.dart';
import 'package:rapid_app/data/module/subpage/tag_box_table_gridview/tag_box_table_grid_page.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/combo_concatenate.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';
import 'package:rapid_app/res/values/logs/logs.dart';
import 'package:rapid_app/res/values/strings.dart';

class MenuDetailedAdvancedSearchController extends RapidController {
  dynamic arguments = Get.arguments;

  TextEditingController openBracesController = TextEditingController();
  TextEditingController closeBracesController = TextEditingController();
  TextEditingController fieldNameController = TextEditingController();
  TextEditingController operatorController = TextEditingController();
  TextEditingController modifierController = TextEditingController();
  TextEditingController value1Controller = TextEditingController();
  TextEditingController value2Controller = TextEditingController();
  TextEditingController operationController = TextEditingController();
  TextEditingController addController = TextEditingController(text: '');

  RxList<AdvancedSearchChildModel> advancedSearchList = RxList([]);

  RxString query = ''.obs;
  RxBool value2Enabled = false.obs;
  RxBool modifierEnabled = false.obs;

  List<String> operatorList = [
    '=',
    '<>',
    '>',
    '>=',
    '<',
    '<=',
    'LIKE',
    'BETWEEN',
    'IN'
  ];
  List<String> modifierList = [
    'DATE',
    'YEAR',
    'MONTH',
    'DAY',
    'TODAY',
    'LASTDAYOFMONTH',
    'FIRSTDAYOFMONTH'
  ];
  List<String> filterOperator = ['AND', 'OR'];
  RxList<MetadataColumnsResponse> fieldList = RxList<MetadataColumnsResponse>([]);
  RxString selectedOperator = '='.obs;
  RxString selectedModifier = ''.obs;
  RxString selectedFilter = ''.obs;
  RxString selectedColumn = ''.obs;
  RxString fieldDataType = ''.obs;
  late MetadataColumnsResponse selectedField;
  List<MetadataColumnsResponse> gridTableTitles = [];
  RxList<MetadataColumnsResponse> metadataColumnsTable =
      RxList<MetadataColumnsResponse>([]);
  late int tableId;
  late String tableName;
  Map<String, dynamic> editData = {};
  RxList<MetadataCommandResponse> buttonsList = RxList([]);
  List<MetadataActionResponse> buttonActionsList = [];
  RxBool addBtnVisible = false.obs;

  RxString selectedFieldNameDataType = ''.obs;
  RxString selectedOperatorType = ''.obs;
  RxString selectedAndOrType = ''.obs;
  RxBool editMode = false.obs;
  RxInt index = 0.obs;
  RxMap<String, List<LookupResponse>> lookupList = RxMap({});
  RxMap<String, String> lookupValue = RxMap({});
  Map<String, dynamic> selectedTagbox = {};
  RxBool typeUpdated = false.obs;
  String selectedFieldColumnName = '', selectedFieldDataType = '';

  String value1ValueField = '';
  String value2ValueField = '';

  @override
  void onInit() {
    super.onInit();
    tableId = arguments['MDT_SYS_ID'];
    tableName = arguments['MENU_NAME'];
    getMetadataColumnFields();
    getButtonsActions();
    selectedOperator.value = operatorList[0].toString();
    selectedModifier.value = modifierList[0].toString();
    selectedFilter.value = filterOperator[0].toString();
  }

  void checkFields() {
    if (fieldNameController.text.isNotEmpty &&
        value1Controller.text.isNotEmpty) {
      addBtnVisible.value = true;
    } else {
      addBtnVisible.value = false;
    }
  }

  Future<void> getMetadataColumnFields() async {
    final response =
        await apiClient.rapidRepo.getMenuDetailsSearchFields(sysId: tableId);
    if (response.status) {
      List<dynamic> responseData = response.data;
      List<MetadataColumnsResponse> allFields = [];
      for (int i = 0; i < responseData.length; ++i) {
        final encode = json.encode(responseData[i]);
        final decode = json.decode(encode);
        MetadataColumnsResponse response =
            MetadataColumnsResponse.fromJson(decode);
        allFields.add(response);
      }
      List<MetadataColumnsResponse> visibleList =
          allFields.where((element) => element.mdcVisible == 'Y').toList();
      fieldList.value = visibleList;
    }
    selectedField = fieldList[0];
    selectedFieldNameDataType.value = fieldList[0].mdcDatatype!;
    selectedColumn.value = selectedField.mdcMetatitle;
    fieldDataType.value = selectedField.mdcDatatype.toString();
    if (selectedField.mdcDatatype == 'LOOKUP') {
      getLookup(
        fieldName: selectedField.mdcColName,
        query: selectedField.mdcComboqry!,
        where: selectedField.mdcCombowhere,
      );
    }
  }

  Future<void> getLookup({
    required String fieldName,
    required String query,
    String? where,
  }) async {
    String convertedWhere =
        await comboConcatenate(fformula: where!, obj: editData, ptbName: tableName);
    final response = await apiClient.rapidRepo.getLookupData(query: query, where: convertedWhere);

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
      Logs.logData('lookupList[fieldName]', lookupList[fieldName].toString());
    }else {
      lookupList[fieldName] = [];
      lookupValue[fieldName] = '';
    }
  }

  Future<String> getTagboxValue({
    required String value,
    required String comboWhere,
    required String textField,
    required String comboQry,
    required String valueField,
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
      return textData;
    } else {
      return value;
    }
  }

  void getChildTable(String hint, TextEditingController textEditingController,
      String valueField) async {
    if (selectedField.mdcDatatype == 'TAGBOX') {
      final result = await Get.to(() => const TagBoxTableGridPage(),
          binding: TagBoxTableGridBinding(),
          arguments: {
            'column': selectedField,
            'menuName': tableName,
            'rowData': editData,
            'editValue': textEditingController.text,
          });
      Map<String, dynamic> tagBoxMap = {};
      tagBoxMap.addAll(result['tagBox']);
      Logs.logData("tagbox1:::", tagBoxMap.toString());
      Logs.logData("valueField2:::", tagBoxMap[valueField].toString());

      /// store selected column text and value fields
      selectedTagbox[result['MDC_TEXTFIELDNAME']] =
          tagBoxMap[selectedField.mdcValuefieldname];
        if (hint == 'Value 2') {
          value2ValueField = tagBoxMap[valueField].toString();
        } else {
          value1ValueField = tagBoxMap[valueField].toString();
        }

      /// set selected column textfield to controller
      textEditingController.value = TextEditingValue(
        text: result['MDC_TEXTFIELDNAME'],
      );
    } else {
      Logs.logData('TagBox', 'else Case');
    }
  }

  void onFieldChange(MetadataColumnsResponse? data) {
    value1Controller = TextEditingController(text: '');
    value2Controller = TextEditingController(text: '');
    typeUpdated.value = true;
    selectedField = data!;
    selectedFieldDataType = selectedField.mdcDatatype.toString();
    fieldDataType.value = selectedField.mdcDatatype.toString();
    selectedFieldColumnName = selectedField.mdcColName;
    // get field data type
    selectedFieldNameDataType.value =
        selectedField.mdcDatatype.toString().trim();
    if (selectedField.mdcDatatype == 'DATE') {
      modifierEnabled.value = true;
    } else {
      modifierEnabled.value = false;
      modifierController = TextEditingController(text: '');
    }
    Logs.logData('dataType', fieldDataType.value.toString());
    if (fieldDataType.value == 'LOOKUP') {
      getLookup(
        fieldName: selectedField.mdcColName,
        query: selectedField.mdcComboqry!,
        where: selectedField.mdcCombowhere,
      );
    }
    checkFields();
    typeUpdated.value = false;
  }

  void onOperatorChange(String? data) {
    selectedOperator.value = data!;
    selectedOperatorType.value = data;
    if (selectedOperator.value == 'BETWEEN') {
      value2Enabled.value = true;
    } else {
      value2Enabled.value = false;
      value2Controller = TextEditingController(text: '');
    }
  }

  void onModifierChange(String? data) {
    selectedModifier.value = data!;
  }

  void onFilterChange(String? data) {
    selectedFilter.value = data!;
    selectedAndOrType.value = data;
    checkFields();
  }

  void getButtonsActions() async {
    Box box = await dbAccess.openDatabase();
    // clear both lists
    buttonsList.clear();
    buttonActionsList.clear();
    // fetch button actions from local Db
    buttonActionsList = box
        .get(Strings.kMetadataActions)
        .toList()
        .cast<MetadataActionResponse>();
    // fetch buttons from local db
    List<MetadataCommandResponse> btnAll = box
        .get(Strings.kMetadataCommands)
        .toList()
        .cast<MetadataCommandResponse>();
    // filter used buttons by type
    List<MetadataCommandResponse> visibleButtons = btnAll
        .where((element) =>
            element.mdcdMdtSysId == tableId &&
            (element.mdcdType == 'Search' || element.mdcdType == 'Both'))
        .toList();
    buttonsList.value = visibleButtons;

    /// sort list data
    buttonsList.sort((a, b) => a.mdcdSeqnum.compareTo(b.mdcdSeqnum));
  }

  void addRow() async {
    if (fieldNameController.text.isNotEmpty &&
        value1Controller.text.isNotEmpty &&
        operatorController.text.isNotEmpty) {
      AdvancedSearchChildModel advancedSearchChildModel =
          AdvancedSearchChildModel(
              open: openBracesController.text,
              fieldName: fieldNameController.text,
              operator: operatorController.text,
              modifier: modifierController.text,
              value1: value1Controller.text,
              value1ValueField: value1ValueField,
              value2: value2Controller.text,
              value2ValueField: value2ValueField,
              operation: operationController.text,
              close: closeBracesController.text,
              columnName: selectedFieldColumnName,
              dataType: selectedFieldDataType);
      if (editMode.value) {
        advancedSearchList.insert(index.value, advancedSearchChildModel);
        editMode.value = false;
      } else {
        advancedSearchList.add(advancedSearchChildModel);
      }
      final data = await Get.to(
        () => const MenuDetailedAdvancedSearchGridPage(),
        binding: MenuDetailedAdvancedSearchGridBinding(),
        arguments: {
          'search_query': advancedSearchList,
          'MDT_SYS_ID': tableId,
          'MENU_NAME': tableName,
        },
      );
      clearFields();
      if (data != null) {
        AdvancedSearchChildModel advancedSearchChildModel = data['edit_query'];
        editRows(advancedSearchChildModel);
        index.value = data['index'];
        editMode.value = true;
        advancedSearchList.removeAt(data['index']);
      }
    }
  }

  void editRows(AdvancedSearchChildModel advancedSearchChildModel) {
    openBracesController.value =
        TextEditingValue(text: advancedSearchChildModel.open.toString());
    fieldNameController.value =
        TextEditingValue(text: advancedSearchChildModel.fieldName.toString());
    operatorController.value =
        TextEditingValue(text: advancedSearchChildModel.operator.toString());
    modifierController.value =
        TextEditingValue(text: advancedSearchChildModel.modifier.toString());
    value1Controller.value =
        TextEditingValue(text: advancedSearchChildModel.value1.toString());
    value2Controller.value =
        TextEditingValue(text: advancedSearchChildModel.value2.toString());
    operationController.value =
        TextEditingValue(text: advancedSearchChildModel.operation.toString());
    closeBracesController.value =
        TextEditingValue(text: advancedSearchChildModel.close.toString());
    selectedFieldColumnName = advancedSearchChildModel.columnName.toString();
    selectedFieldDataType = advancedSearchChildModel.dataType.toString();
    selectedFieldNameDataType.value = selectedFieldDataType;
    value1ValueField = advancedSearchChildModel.value1ValueField.toString();
    value2ValueField = advancedSearchChildModel.value2ValueField.toString();
  }

  void clearFields() {
    openBracesController.clear();
    fieldNameController.clear();
    operatorController.clear();
    modifierController.clear();
    value1Controller.clear();
    value2Controller.clear();
    operationController.clear();
    closeBracesController.clear();
  }

  dynamic buttonActions(String action) {
    switch (action) {
      case 'Cancel':
        addController.clear();
        break;
      case 'Close':
        Get.back();
        break;
    }
  }
}
