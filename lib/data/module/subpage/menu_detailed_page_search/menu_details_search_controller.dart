import 'dart:convert';
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rapid_app/data/model/combo_box_model/lookup_response.dart';
import 'package:rapid_app/data/model/metadata_actions_model/metadata_actions_response.dart';
import 'package:rapid_app/data/model/metadata_columns_model/metadata_columns_response.dart';
import 'package:rapid_app/data/model/metadata_command_model/metadata_command_response.dart';
import 'package:rapid_app/data/model/mt_data_validation_model/mt_data_validation_response.dart';
import 'package:rapid_app/data/module/subpage/tag_box_table_gridview/tag_box_table_grid_binding.dart';
import 'package:rapid_app/data/module/subpage/tag_box_table_gridview/tag_box_table_grid_page.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/combo_concatenate.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/default_concatenator.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/default_value.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';
import 'package:rapid_app/res/values/logs/logs.dart';
import 'package:rapid_app/res/values/strings.dart';

import '../../../../res/utils/generate_random_string.dart';
import '../../../model/metadata_table_group_model/metadata_table_group_response.dart';
import '../location_widget/location_binding.dart';
import '../location_widget/location_page.dart';

class MenuDetailsSearchController extends RapidController
    with GetSingleTickerProviderStateMixin {
  dynamic get argumentData => Get.arguments;
  late int metaTableId;
  late String newEditMode;
  late String metaTableName, metaTableDefaultWhere, metaTableKeyInfo;
  late String selectedTabName;

  bool backFlag = false;

  Map<String, TextEditingController> textEditingControllerMap = {};

  // all fields
  RxList<MetadataColumnsResponse> allColumnsList = RxList([]);

  RxList<MetadataColumnsResponse> selectedTabColumnsList = RxList([]);

  RxMap<String, dynamic> selectedItemsList = RxMap({});

  RxList<MetadataTableGroupResponse> columnTabsList = RxList([]);
  RxList<Tab> tabs = <Tab>[].obs;
  TabController? tabController;
  RxList<String> searchTabTable = RxList<String>([]);
  Rx<bool> isIndicatorVisibility = true.obs;

  RxMap<String, List<LookupResponse>> lookupList = RxMap({});
  RxMap<String, String> lookupValue = RxMap({});

  RxList<MetadataCommandResponse> buttonsList = RxList([]);
  List<MetadataActionResponse> buttonActionsList = [];

  RxMap<String, bool> checkBoxList = RxMap({});
///added
  Rx<bool> valueSetFlag = false.obs;
  Rx<bool> isChildTablePlusIcon = false.obs;
  RxMap<String, dynamic> columnsValueMap = RxMap({});
  Map<String, String> defaultValueQueryMap = {};
  Map<String, dynamic> parentRowData = {};
  late String parentTable='';
  List<String> requiredDataList = [];
  List<MtDataValidationResponse> validationButtonList = [];

  ///

  Map<String, dynamic> selectedTagbox = {};
  RxMap<String, String> tagboxValue = RxMap({});

  RxMap<String, String> imageValue = RxMap({});
  RxMap<String, String> fileValue = RxMap({});
  RxString pickedFileName = ''.obs;
  late io.File pickedImage;
  Map<String, dynamic> addFileMap = {};

  RxMap<String, bool> isObscureMap = RxMap({});

  Rx<bool> isButtonClickLoader = false.obs;

  @override
  void onInit() {
    super.onInit();
    metaTableId = argumentData['MDT_SYS_ID'];
    metaTableName = argumentData['MENU_NAME'];
    Logs.logData("sysId-menuName:::", metaTableId.toString() + " - " + metaTableName.toString());
    metaTableDefaultWhere = argumentData['MDT_DEFAULT_WHERE'];
    metaTableKeyInfo = argumentData['KEY_INFO'];
    newEditMode = Strings.kParamNew;

    /// fetch tabs
    getMetadataTabs();

    /// fetch table columns
    getMetadataColumnFields();

    /// fetch visible buttons
    getButtonsActions();
  }

  Future<void> getMetadataColumnFields() async {
    final response = await apiClient.rapidRepo
        .getMenuDetailsSearchFields(sysId: metaTableId);
    if (response.status) {
      List<dynamic> responseData = response.data;
      for (int i = 0; i < responseData.length; ++i) {
        final encode = json.encode(responseData[i]);
        final decode = json.decode(encode);
        MetadataColumnsResponse response =
            MetadataColumnsResponse.fromJson(decode);
        allColumnsList.add(response);

        if (allColumnsList[i].mdcDatatype == 'LOOKUP') {
          getLookup(
            fieldName: allColumnsList[i].mdcColName,
            query: allColumnsList[i].mdcComboqry!,
            where: allColumnsList[i].mdcCombowhere,
          );
        }
        if (allColumnsList[i].mdcDatatype == 'CHECKBOXSTR' ||
            allColumnsList[i].mdcDatatype == 'CHECKBOX') {
          checkBoxList[allColumnsList[i].mdcColName] = false;
        }
      }

      List<MetadataColumnsResponse> passwordIconFields = allColumnsList
          .where((element) =>
      element.mdcDatatype == 'STRING' && element.mdcEncbtnVisble == 'Y')
          .toList();
      for(int i=0;i<passwordIconFields.length;++i){
        isObscureMap[passwordIconFields[i].mdcColName] = true;
      }

      // first tab
      if (columnTabsList.isNotEmpty) {
        onTapTab(0);
      }
    } else {
      isIndicatorVisibility.value = false;
    }
  }
///getlookup
  // Future<void> getLookup({
  //   required String fieldName,
  //   required String query,
  //   String? where,
  // }) async {
  //   Map<String, dynamic> editData = {};
  //   String convertedWhere = await comboConcatenate(
  //       fformula: where!, obj: editData, ptbName: metaTableName);
  //   final response = await apiClient.rapidRepo
  //       .getLookupData(query: query, where: convertedWhere);
  //   if (response.status) {
  //     List<dynamic> dataResponse = response.data;
  //     List<LookupResponse> lookupData = [];
  //     for (int i = 0; i < dataResponse.length; ++i) {
  //       dynamic encodeData = json.encode(dataResponse[i]);
  //       final decode = json.decode(encodeData);
  //       LookupResponse response = LookupResponse.fromJson(decode);
  //       lookupData.add(response);
  //     }
  //     lookupList[fieldName] = lookupData;
  //     lookupValue[fieldName] = '';
  //   }
  // }

  Future<void> getLookup({
    required String fieldName,
    required String query,
    String? where,
    dynamic defaultValueMap,
  }) async {
    String convertedWhere = await comboConcatenate(
        fformula: where!, obj: defaultValueMap, ptbName: metaTableName);
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
      // lookupValue[fieldName] = '';
    } else {
      lookupList[fieldName] = [];
      lookupValue[fieldName] = '';
    }
  }















  Future<void> getMetadataTabs() async {
    final response = await apiClient.rapidRepo
        .getTableGroups(tableId: metaTableId.toString());
    if (response.status) {
      dynamic responseData = response.data;
      for (int i = 0; i < responseData.length; ++i) {
        String res = json.encode(responseData[i]);
        final jsonDecode = json.decode(res);
        MetadataTableGroupResponse data =
            MetadataTableGroupResponse.fromJson(jsonDecode);
        columnTabsList.add(data);
      }

      /// set tab
      setSearchTabs();
    } else {
      isIndicatorVisibility.value = false;
      setSearchTabs();
    }
  }

  void setSearchTabs() {
    List<String> distinctKeyTabs = [];
    for (int i = 0; i < columnTabsList.length; ++i) {
      distinctKeyTabs.add(columnTabsList[i].mtgGrpname);
    }

    if (distinctKeyTabs.isNotEmpty) {
      searchTabTable.clear();
      searchTabTable.addAll(distinctKeyTabs);
      tabs = getTabs(distinctKeyTabs);
      tabController = getTabController();
      onTapTab(0);
    } else {
      isIndicatorVisibility.value = false;
      showAllColumns();
    }
  }

  RxList<Tab> getTabs(List<String> chartTabs) {
    tabs.clear();
    for (int i = 0; i < chartTabs.length; i++) {
      tabs.add(getTab(chartTabs[i].toString()));
    }
    return tabs;
  }

  TabController getTabController() {
    return TabController(length: tabs.length, vsync: this);
  }

  Tab getTab(String name) {
    return Tab(
      text: name,
    );
  }

  void onTapTab(int index) {
    /// clear old tab columns
    selectedTabColumnsList.clear();

    /// fetch tab name
    selectedTabName = searchTabTable[index].toString();
    showSearchColumns(
      tabName: selectedTabName,
    );
  }

  @override
  void onClose() {
    super.onClose();
    tabController?.dispose();
    tabs.clear();
    searchTabTable.clear();
  }

  void showSearchColumns({required String tabName}) {
    List<MetadataColumnsResponse> list = allColumnsList
        .where((element) =>
            element.mdcMtgGrpname == tabName && element.mdcVisible == 'Y')
        .toList();
    selectedTabColumnsList.clear();
    selectedTabColumnsList.value = list;

    /// sort list data
    selectedTabColumnsList.sort((a, b) => a.mdcSeqnum.compareTo(b.mdcSeqnum));
  }

  void showAllColumns() {
    List<MetadataColumnsResponse> list =
        allColumnsList.where((element) => element.mdcVisible == 'Y').toList();
    selectedTabColumnsList.clear();
    selectedTabColumnsList.value = list;

    /// sort list data
    selectedTabColumnsList.sort((a, b) => a.mdcSeqnum.compareTo(b.mdcSeqnum));
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
            element.mdcdMdtSysId == metaTableId &&
            (element.mdcdType == 'Search' || element.mdcdType == 'Both'))
        .toList();
    buttonsList.value = visibleButtons;

    /// sort list data
    buttonsList.sort((a, b) => a.mdcdSeqnum.compareTo(b.mdcdSeqnum));
  }

  void onButtonClick(int mdcdSysId) {
    List<MetadataActionResponse> actionsList = buttonActionsList
        .where((element) => element.mdaMdcdSysId == mdcdSysId)
        .toList();
    actionsList.sort((a, b) => a.mdaSeqnum.compareTo(b.mdaSeqnum));

    for (int i = 0; i < actionsList.length; i++) {
      buttonActions(actionsList[i].mdaAction.toString());
    }
  }

  dynamic buttonActions(String action) {
    switch (action) {
      case 'Cancel':
        textEditingControllerMap.clear();
        break;
      case 'Close':
        Get.back();
        break;
      case 'Search':
        searchAllData();
        // searchData();
        break;
      case 'SearchAll':
        searchAllData();
        // searchData();
        break;
    }
  }

  void searchData() async {
    debugPrint("...............search");
    Map<String, String> searchDataMap = {};
    for (var key in textEditingControllerMap.keys) {
      int columnIndex = allColumnsList
          .indexWhere((element) => element.mdcColName.contains(key));
      String columnDataType =
          allColumnsList[columnIndex].mdcDatatype.toString().trim();

      if (columnDataType == 'LOOKUP') {
        // String value = lookupValue[key].toString();
        String value = selectedItemsList[key].toString().split(":").first.trim();
        if (value != '') {
          searchDataMap[key] = value;
        }
      } else if (columnDataType == 'TAGBOX') {
        String value = tagboxValue[key].toString();
        if (value != 'null' || value != '') {
          searchDataMap[key] = value;
        }
      } else if (columnDataType == 'DATE') {
        String value = textEditingControllerMap[key]!.value.text.toString();
        if (value != '') {
          var dateValue = value.split(' ');
          value = dateValue[0].trim().toString();
        }
      } else {
        String value = textEditingControllerMap[key]!.value.text.toString();
        if (value != '') {
          searchDataMap[key] = value;
        }
      }
    }

    /// generate query and param
    List<Map<String, dynamic>> paramsData = [];
    String params = '';
    for (var key in searchDataMap.keys) {
      dynamic keyValue = searchDataMap[key];
      dynamic prms = {Strings.kName: key, Strings.kValue: '%$keyValue%'};

      ///key-value param
      paramsData.add(prms);

      ///query param
      params = params + 'UPPER ($key) LIKE UPPER (:$key) OR ';
    }

    /// remove last 'OR'
    params = params.trim().substring(0, params.length - 3);

    /// encode key-value param list
    dynamic param = json.encode(paramsData);
    String query = '';
    if (metaTableDefaultWhere.isEmpty) {
      Logs.logData("where:", "No");
      query = 'WITH S AS (SELECT * FROM $metaTableName) '
          'SELECT * FROM S WHERE $params ORDER BY $metaTableKeyInfo DESC '
          'OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY';
      search(
        query: query,
        param: param,
      );

    } else {
      Logs.logData("where:", metaTableDefaultWhere);
      String whereCondition =
          await defaultConcatenation(formula: metaTableDefaultWhere);
      if (whereCondition.contains('.0')) {
        String splitVal = whereCondition.split('.').first;
        whereCondition = "$splitVal'";
      }
      query = 'WITH S AS (SELECT * FROM $metaTableName WHERE $whereCondition ) '
          'SELECT * FROM S WHERE $params ORDER BY $metaTableKeyInfo DESC '
          'OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY';
      search(
        query: query,
        param: param,
      );
    }
  }

  /// common search
  Future<void> search({
    required String query,
    required dynamic param,
  }) async {
    isButtonClickLoader.value = true;
    /// Getting meta data frm the API
    final menuDataResponse = await apiClient.rapidRepo.getCommonSearch(
      query: query,
      param: param,
    );
    if (menuDataResponse.status) {
      isButtonClickLoader.value = false;
      List<dynamic> menuColumnData = menuDataResponse.data;
      Get.back(result: {
        'MENU_COL_DATA': menuColumnData,
        'mode': Strings.kParamSearch,
      });
    } else {
      isButtonClickLoader.value = false;
      Get.snackbar(Strings.kMessage, menuDataResponse.message.toString());
    }
  }

  void searchAllData() async {
    // if (addFileMap.isNotEmpty) {
    //   fileUpload();
    // } else {
    searchData();
    // }
  }

  void getLocation(int i, TextEditingController _textEditingController) async {
    final data =
        await Get.to(() => const LocationPage(), binding: LocationBinding());
    _textEditingController.value = TextEditingValue(text: data['LOCATION']);
  }

  Future<FilePickerResult?> filePicker(FileType type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: type,
        allowedExtensions:
            type == FileType.custom ? ['jpg', 'jpeg', 'gif', 'png'] : []);

    // if (result != null) {
    //   pickedFileName.value = result.files.first.name.toString();
    // } else {
    //   // User canceled the picker
    // }
    return result;
  }

  void picker(TextEditingController _textEditingController, String title,
      FileType type) async {
    FilePickerResult? pickedFile = await filePicker(type);
    if (pickedFile != null) {
      _textEditingController.text = pickedFile.files.single.path!;
      imageValue[title] = _textEditingController.text.toString();
      Map<String, dynamic> body = {
        "FileName": pickedFile.files.single.name,
        "FileSize": pickedFile.files.single.size,
        "FileType": pickedFile.files.single.extension,
        "FileGuid": GetTraceId().generateRandomHexaString(),
        "Index": 0,
        "TotalCount": 1
      };
      final encode = jsonEncode(body);
      Map<String, dynamic> entryMap = {
        'File': encode,
        'Path': pickedFile.files.single.path.toString(),
      };
      Map<String, dynamic> dataMap = {
        title: entryMap,
      };
      addFileMap.addEntries(dataMap.entries);
    }
  }

  void fileUpload() async {
    // for (var key in addFileMap.keys) {
    //   await apiClient.rapidRepo.getImageUpload(body: addFileMap[key]);
    // }
  }

  TextEditingController getControllerValue(String columnName, int index, bool bool) {
    /// Checking if the controller is already created
    if (!textEditingControllerMap.containsKey(columnName)) {
      // Taking the initial value from the response
      String initialValue = '';

      /// creating new [TextEditingController] with [initialValue]
      textEditingControllerMap[columnName] =
          TextEditingController(text: initialValue);
    }

    return textEditingControllerMap[columnName]!;
  }

  // TextEditingController getControllerValue(
  //     String columnName, int index, bool colValUpdateFlag) {
  //   /// Checking if the controller is already created
  //   if (!textEditingControllerMap.containsKey(columnName)) {
  //     // Taking the initial value from the response
  //     String initialValue = '';
  //     for (var key in columnsValueMap.keys) {
  //       if (key.trim() == columnName.trim()) {
  //         initialValue = columnsValueMap[key].toString() == "null"
  //             ? ''
  //             : columnsValueMap[key].toString();
  //       }
  //     }
  //     /// creating new [TextEditingController] with [initialValue]
  //     textEditingControllerMap[columnName] =
  //         TextEditingController(text: initialValue);
  //   } else if (colValUpdateFlag) {
  //     textEditingControllerMap[columnName]?.text =
  //         columnsValueMap[columnName].toString();
  //   }
  //   return textEditingControllerMap[columnName]!;
  // }

  buttonValidation(String colName, String changedValue) {
    String editType = 'B';
    if (newEditMode == Strings.kParamNew) {
      editType = 'I';
    } else if (newEditMode == Strings.kParamEdit) {
      editType = 'E';
    }

    /// button validation
    List<MtDataValidationResponse> valBtn = validationButtonList
        .where((element) => element.mtdvFieldname == colName)
        .toList();
    if (valBtn.isNotEmpty) {
      for (int i = 0; i < valBtn.length; ++i) {
        if (valBtn[i].mtdvFieldData.toString() == changedValue &&
            (valBtn[i].mtdvEditType == editType ||
                valBtn[i].mtdvEditType == 'B')) {
          final tempList = buttonsList.value;
          tempList.removeWhere(
                  (element) => element.mdcdSysId == valBtn[i].mtdvValBtnid);
          buttonsList.value = tempList;
        }
      }
    }
  }




  Future<String> getTagboxValue({
    required String value,
    required String comboWhere,
    required String textField,
    required String comboQry,
    required String valueField,
    required String columnName,
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

  void getChildTable(
      int i, TextEditingController _textEditingController) async {
    if (selectedTabColumnsList[i].mdcDatatype == 'TAGBOX') {
      final result = await Get.to(() => const TagBoxTableGridPage(),
          binding: TagBoxTableGridBinding(),
          arguments: {
            'column': selectedTabColumnsList[i],
            'menuName': metaTableName,
            'rowData': newEditMode,
            'editValue': _textEditingController.text,
          });
      Map<String, dynamic> tagBoxMap = {};
      tagBoxMap.addAll(result['tagBox']);
      Logs.logData("tagbox:::", tagBoxMap.toString());

      /// store selected column text and value fields
      selectedTagbox[result['MDC_TEXTFIELDNAME']] =
          tagBoxMap[selectedTabColumnsList[i].mdcValuefieldname];
      tagboxValue[selectedTabColumnsList[i].mdcColName] =
          tagBoxMap[selectedTabColumnsList[i].mdcValuefieldname];

      /// set selected column textfield to controller
      _textEditingController.value = TextEditingValue(
        text: result['MDC_TEXTFIELDNAME'],
      );
    } else {
      Logs.logData('TagBox', 'else Case');
    }
  }


  void checkValidation(
      {
        required String changedValue,
        String? valueField,
        required String colName,
        required String dataType}) async {
    /// for default value replacing
    Map<String, dynamic> tempColumnsValueMap = {};
    tempColumnsValueMap = columnsValueMap;
    tempColumnsValueMap[colName] = valueField;

    /// load selected lookup defaultValue data
    List<MetadataColumnsResponse> lookupTypeList =
    allColumnsList.where((emt) => emt.mdcDatatype == 'LOOKUP').toList();
    for (int i = 0; i < lookupTypeList.length; ++i) {
      if (lookupTypeList[i].mdcComboqry!.contains("':[$colName]'") ||
          lookupTypeList[i].mdcCombowhere!.contains("':[$colName]'") ||
          lookupTypeList[i].mdcComboqry!.contains(":[$colName]") ||
          lookupTypeList[i].mdcCombowhere!.contains(":[$colName]")) {
        getLookup(
          fieldName: lookupTypeList[i].mdcColName,
          query: lookupTypeList[i].mdcComboqry!,
          where: lookupTypeList[i].mdcCombowhere,
          defaultValueMap: tempColumnsValueMap,
        );
      }
    }
    for (var key in lookupValue.keys) {
      if (tempColumnsValueMap.keys.contains(key)) {
        tempColumnsValueMap[key] = lookupValue[key];
      }
    }

    for (var key in tagboxValue.keys) {
      if (tempColumnsValueMap.keys.contains(key)) {
        tempColumnsValueMap[key] = tagboxValue[key];
      }
    }

    /// replace this column value in the all default value columns
    Logs.logData("defaultValueQueryMap::", defaultValueQueryMap.toString());

    for (var key in defaultValueQueryMap.keys) {
      String keyValue = defaultValueQueryMap[key].toString();

      if (keyValue.contains(':$colName') || keyValue.contains(":[$colName]")) {
        if (!keyValue.contains('=ENC:[$colName]')) {
          dynamic defaultVal = await getDefaultValues(
            keyValue,
            tempColumnsValueMap,
            parentTable,
            parentRowData,
            dataType,
          );
          if (defaultVal == 'null' || defaultVal == '' || defaultVal == null) {
            defaultVal = '';
          } else {
            defaultVal = defaultVal['val'];
          }
          columnsValueMap[key] = defaultVal;

          int index = selectedTabColumnsList
              .indexWhere((element) => element.mdcColName == key);
          if (index != -1) {
            getControllerValue(key, index, true);
            // textEditingControllerMap[key] =
            //     TextEditingController(text: defaultVal);
          }
        }
      }
    }

    String editType = 'B';
    if (newEditMode == Strings.kParamNew) {
      editType = 'I';
    } else if (newEditMode == Strings.kParamEdit) {
      editType = 'E';
    }

    /// column validation
    List<MtDataValidationResponse> valCol = validationButtonList
        .where((element) => element.mtdvFieldname == colName)
        .toList();
    if (dataType == 'LOOKUP' ||
        dataType == 'TAGBOX' ||
        dataType == 'SFTAGBOX') {
      changedValue = valueField!;
    }
    Logs.logData("valCol.len::", valCol.length.toString());
    if (valCol.isNotEmpty) {
      for (int i = 0; i < valCol.length; ++i) {
        Logs.logData('${valCol[i].mtdvFieldData}', changedValue);
        if (valCol[i].mtdvFieldData.toString() == changedValue &&
            (valCol[i].mtdvEditType == editType ||
                valCol[i].mtdvEditType == 'B')) {
          String columnName = valCol[i].mtdvValcolName;
          int index = selectedTabColumnsList
              .indexWhere((element) => element.mdcColName == columnName);

          String readOnly = valCol[i].mtdvReadonly!;
          Logs.logData(columnName, readOnly.toString());
          selectedTabColumnsList[index].mdcReadonly = readOnly.trim();
          selectedTabColumnsList.refresh();

          try {
            requiredDataList.remove(colName);
          } catch (e) {
            Logs.logData("required.remove.error::", e.toString());
          }

          if (valCol[i].mtdvDefaultValue != '') {
            dynamic value = await comboConcatenate(
              fformula: valCol[i].mtdvDefaultValue!,
              obj: columnsValueMap,
              ptbName: metaTableName,
            );
            columnsValueMap[columnName] = value;
          }
        }
      }
    } else {
      columnsValueMap[colName] = changedValue;
    }

    Logs.logData("columnsValueMap::", columnsValueMap.toString());

    /// button validation
    buttonValidation(colName, changedValue);
  }


}
