import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'dart:io' as io;
import 'package:rapid_app/data/model/combo_box_model/lookup_response.dart';
import 'package:rapid_app/data/model/metadata_actions_model/metadata_actions_response.dart';
import 'package:rapid_app/data/model/metadata_columns_model/metadata_columns_response.dart';
import 'package:rapid_app/data/model/metadata_command_model/metadata_command_response.dart';
import 'package:rapid_app/data/model/metadata_table_model/metadata_table_ischild_response.dart';
import 'package:rapid_app/data/model/metadata_validation_model/metadata_validation_response.dart';
import 'package:rapid_app/data/model/mt_data_validation_model/mt_data_validation_response.dart';
import 'package:rapid_app/data/module/subpage/location_widget/location_binding.dart';
import 'package:rapid_app/data/module/subpage/location_widget/location_page.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/widget_conditions/widget_validation.dart';
import 'package:rapid_app/data/module/subpage/tag_box_table_gridview/tag_box_table_grid_binding.dart';
import 'package:rapid_app/data/module/subpage/tag_box_table_gridview/tag_box_table_grid_page.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/combo_concatenate.dart';
import 'package:rapid_app/res/utils/encryp_decrypt/aes_encrypt_decrypt.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/logs/logs.dart';
import 'package:rapid_app/res/values/strings.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../res/utils/dynamic_default_value_generation/default_value.dart';
import '../../../model/metadata_table_group_model/metadata_table_group_response.dart';

class MenuDetailsNewEditController extends RapidController
    with GetSingleTickerProviderStateMixin {
  dynamic get argumentData => Get.arguments;
  String mode = '';
  late int metaTableId;
  late String selectedTabName;
  late String metaTableName, newEditMode, pkKeyName, parentTable = '';
  dynamic pkKeyValue;
  RxMap<String, dynamic> columnsValueMap = RxMap({});
  Map<String, dynamic> columnsValueParentMap = {};

  // Map<String, dynamic> lookupMap = controller.lookupList.toMap();
  Map<String, dynamic> parentRowData = {}; // parent table data
  RxString valueFeild = ''.obs, textFeild = ''.obs;

  List<dynamic> recallResponse = [];
  RxString valPlusText = ''.obs;
  Map<String, TextEditingController> textEditingControllerMap = {};

  RxList<MetadataColumnsResponse> allColumnsList = RxList([]);

  Rx<bool> valueSetFlag = false.obs;

  RxList<MetadataTableGroupResponse> columnTabsList = RxList([]);
  RxList<MetadataColumnsResponse> selectedTabColumnsList = RxList([]);

  RxList<Tab> tabs = <Tab>[].obs;
  TabController? tabController;
  RxList<String> searchTabTable = RxList<String>([]);
  Rx<bool> isIndicatorVisibility = true.obs;

  RxBool isLocation = false.obs;
  Rx<bool> isButtonClickLoader = false.obs;

  RxMap<String, List<LookupResponse>> lookupList = RxMap({});
  RxMap<String, List<LookupResponse>> tempLookupList = RxMap({});
  RxMap<String, String> lookupValue = RxMap({});

  List<MetadataCommandResponse> parentButtonList = []; // parent table data
  RxList<MetadataCommandResponse> buttonsList = RxList([]);
  List<MetadataActionResponse> buttonActionsList = [];

  RxMap<String, bool> checkBoxList = RxMap({});

  Rx<bool> isChildTablePlusIcon = false.obs;
  RxList<MetadataTableIsChild> childTables = RxList([]);

  Map<String, dynamic> selectedTagbox = {};
  RxMap<String, String> tagboxValue = RxMap({});

  RxMap<String, List<LookupResponse>> fetchedItemsList = RxMap({});
  RxString fetchedColName = ''.obs;
  RxInt fetchedIndex = 0.obs;

  RxMap<String, dynamic> selectedItemsList = RxMap({});
  RxString colName = ''.obs;
  RxInt index = 0.obs;

  // int indexx=0;
  List<MetadataValidationResponse> validationDataList = [];
  List<String> requiredDataList = [];

  List<MtDataValidationResponse> validationColumnsList = [];
  List<MtDataValidationResponse> validationButtonList = [];
  Map<String, String> defaultValueQueryMap = {};

  RxString pickedFileName = ''.obs;
  late io.File pickedImage;
  RxMap<String, String> imageValue = RxMap({});
  RxMap<String, String> fileValue = RxMap({});

  RxMap<String, bool> isObscureMap = RxMap({});

  @override
  void onInit() {
    super.onInit();
    metaTableId = argumentData['MDT_SYS_ID'];
    metaTableName = argumentData['MENU_NAME'];
    newEditMode = argumentData[Strings.kMode];
    Logs.logData("sysId-menuName:::",
        metaTableId.toString() + " - " + metaTableName.toString());
    if (argumentData['BUTTON_LIST'] != null) {
      parentButtonList = argumentData['BUTTON_LIST'];
    }
    if (argumentData['PARENT_ROW'] != null) {
      parentRowData = argumentData['PARENT_ROW'];
    }
    if (argumentData['PARENT_TABLE'] != null) {
      parentTable = argumentData['PARENT_TABLE'];
    }

    ///  fetch visible buttons
    fetchButtons();

    /// fetch tabs
    getMetadataTabs();

    /// fetch table columns
    getMetadataColumnFields();

    // Future.delayed(const Duration(seconds: 3), () {
    //   selectedItemsList[colName.value] =
    //       getControllerValue(colName.value, index.value, true).text;
    // });

    // checkBoxList[selectedTabColumnsList[index.value].mdcColName.toString()]=false;
  }

  void fetchButtons() async {
    final isButtonEmpty =
        await dbAccess.isTableEmpty(Strings.kMetadataCommands);
    if (isButtonEmpty) {
      await fetchMetadataCommandsFromApi();
    }
    final isButtonActionEmpty =
        await dbAccess.isTableEmpty(Strings.kMetadataActions);
    if (isButtonActionEmpty) {
      await fetchMetadataActionsFromApi();
    }
    getButtonsActions(newEditMode);
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
      showAllColumns();
    }
  }

  Future<void> getMetadataColumnFields() async {
    final response = await apiClient.rapidRepo
        .getMenuDetailsSearchFields(sysId: metaTableId);
    if (response.status) {
      List<dynamic> responseData = response.data;
      String mdcSysIdListStr = '';
      for (int i = 0; i < responseData.length; ++i) {
        final encode = json.encode(responseData[i]);
        final decode = json.decode(encode);
        MetadataColumnsResponse response =
            MetadataColumnsResponse.fromJson(decode);
        allColumnsList.add(response);
        if (allColumnsList[i].mdcDatatype == 'CHECKBOXSTR' ||
            allColumnsList[i].mdcDatatype == 'CHECKBOX') {
          checkBoxList[allColumnsList[i].mdcColName] = false;
        }
        mdcSysIdListStr =
            mdcSysIdListStr + "," + allColumnsList[i].mdcSysId.toString();
      }

      /// sort list data
      allColumnsList.sort((a, b) => a.mdcSeqnum.compareTo(b.mdcSeqnum));

      allColumnsList.sort((a, b) => a.mdcVisible!.compareTo(b.mdcVisible!));

      List<MetadataColumnsResponse> passwordIconFields = allColumnsList
          .where((element) =>
              element.mdcDatatype == 'STRING' && element.mdcEncbtnVisble == 'Y')
          .toList();
      for (int i = 0; i < passwordIconFields.length; ++i) {
        isObscureMap[passwordIconFields[i].mdcColName] = true;
      }

      /// replace default Values
      Map<String, dynamic> defaultValueMap = {};
      for (int i = 0; i < allColumnsList.length; ++i) {
        dynamic defaultVal = '';
        Logs.logData(
            "mdcDefaultValue:::",
            allColumnsList[i].mdcMetatitle +
                '--' +
                allColumnsList[i].mdcColName +
                '--' +
                allColumnsList[i].mdcDefaultvalue.toString());

        defaultValueQueryMap[allColumnsList[i].mdcColName] =
            allColumnsList[i].mdcDefaultvalue.toString();

        if (allColumnsList[i].mdcDatatype == 'DATE') {
          if (allColumnsList[i].mdcDefaultvalue.toString() == 'Null') {
            defaultVal = '';
          } else {
            /// get current date
            var now = DateTime.now();
            var formatter = DateFormat("dd/MMM/yy");
            String currentDate = formatter.format(now);
            defaultVal = currentDate;
            debugPrint("............currentdate$currentDate");
          }
        }
        if (allColumnsList[i].mdcDatatype == 'LOOKUP') {
          await getLookup(
            fieldName: allColumnsList[i].mdcColName,
            query: allColumnsList[i].mdcComboqry!,
            where: allColumnsList[i].mdcCombowhere,
            defaultValueMap: defaultValueMap,
          );
          debugPrint("??????????????$defaultValueMap");
        }
        if (allColumnsList[i].mdcDefaultvalue!.isNotEmpty) {
          defaultVal = await getDefaultValues(
            allColumnsList[i].mdcDefaultvalue!,
            defaultValueMap,
            parentTable,
            parentRowData,
            allColumnsList[i].mdcDatatype!,
          );
          if (defaultVal == 'null' || defaultVal == '' || defaultVal == null) {
            defaultVal = '';
          } else {
            defaultVal = defaultVal['val'];
            if (defaultVal == 'Null') {
              defaultVal = '';
            }
          }
        }
        defaultValueMap[allColumnsList[i].mdcColName] = defaultVal;
        // debugPrint("..........................${defaultValueMap[allColumnsList[i].mdcColName]}");

        /// in lookup read only case, the widget have no readonly mode available.so remove other data in the list
        if (allColumnsList[i].mdcDatatype == 'LOOKUP' &&
            allColumnsList[i].mdcReadonly == 'Y') {
          try {
            List<LookupResponse>? resList =
                lookupList[allColumnsList[i].mdcColName];
            if (resList != null) {
              List<String> unBoundColumns = resList
                  .where((element) => element.valueField == defaultVal)
                  .map((e) => e.valueField)
                  .toList();
              resList.removeWhere(
                  (element) => !unBoundColumns.contains(element.valueField));
            }
            lookupList[allColumnsList[i].mdcColName] = resList!;
          } catch (e) {
            Logs.logData("msg", "something missing in the function");
          }
        }
      }

      /// remove empty and null values
      defaultValueQueryMap.removeWhere((key, value) => value.isEmpty);
      defaultValueQueryMap.removeWhere((key, value) => value == 'null');

      List<MetadataColumnsResponse> lookupColNames =
          allColumnsList.where((emt) => emt.mdcDatatype == 'LOOKUP').toList();

      /// lookup value fields are replaced to text fields
      for (int i = 0; i < lookupColNames.length; ++i) {
        String colName = lookupColNames[i].mdcColName;
        if (defaultValueMap[colName] == '') {
          continue;
        } else {
          String defaultValue = defaultValueMap[colName].toString();
          if (defaultValue.contains('.0')) {
            defaultValue = defaultValue.substring(0, defaultValue.length - 2);
          }
          lookupValue[colName] = defaultValue;
          debugPrint('...........lookupdefaultValue:${lookupValue[colName]}');
          if (lookupList.containsKey(colName)) {
            List<LookupResponse> lookupArray = lookupList[colName]!;
            for (int i = 0; i < lookupArray.length; ++i) {
              Logs.logData(lookupArray[i].textField, lookupArray[i].valueField);
            }
            if (lookupArray.isNotEmpty) {
              if (lookupArray
                  .any((element) => element.valueField == defaultValue)) {
                int index = lookupArray.indexWhere(
                    (element) => element.valueField == defaultValue);
                defaultValue = lookupArray[index].textField;
                defaultValueMap[colName] = defaultValue;
                debugPrint(
                    '...........defaultValue:${defaultValueMap[colName]}');
              }
            }
          }
        }
      }

      /// set display data
      columnsValueMap.addAll(defaultValueMap);
      debugPrint('...........columsValuemap1$columnsValueMap');
      debugPrint('...........defaultValueMap1$defaultValueMap');
      if (newEditMode == Strings.kParamEdit) {
        Logs.logData("edit data:::::::", argumentData['EDIT_DATA'].toString());
        Map<String, dynamic> editData = argumentData['EDIT_DATA'];
        for (var key in editData.keys) {
          String kVal = editData[key].toString();
          if (kVal.contains('.0')) {
            kVal = kVal.substring(0, kVal.length - 2);
            editData[key] = kVal;
          }
        }

        columnsValueMap.addAll(editData);
        debugPrint('**********************$columnsValueMap');
        debugPrint('**********************$editData');

        columnsValueParentMap.addAll(editData);
        debugPrint('**********************$columnsValueParentMap');
        debugPrint('**********************$editData');
        isChildTableAvailable();
        checkEditDataButtonVisibility(editData);

        /// replace lookup & tagbox values
        List<MetadataColumnsResponse> lookupTagbox =
            allColumnsList.where((p0) => p0.mdcDatatype == 'LOOKUP').toList();
        Map<String, dynamic> tempColumnsValueMap = columnsValueMap.value;
        for (int i = 0; i < lookupTagbox.length; ++i) {
          String colName = lookupTagbox[i].mdcColName;
          if (tempColumnsValueMap.keys.contains(colName)) {
            if (tempColumnsValueMap[colName] != '') {
              await getLookup(
                fieldName: colName,
                query: lookupTagbox[i].mdcComboqry!,
                where: lookupTagbox[i].mdcCombowhere,
                defaultValueMap: tempColumnsValueMap,
              );
              debugPrint("!!!!!!!!!!!!!!!!!!!$defaultValueMap");
              List<LookupResponse> tempLookupList = lookupList[colName]!;
              if (tempLookupList.isNotEmpty) {
                try {
                  String lookupVal = tempLookupList
                      .where((elt) =>
                          elt.textField == tempColumnsValueMap[colName])
                      .first
                      .valueField
                      .toString();

                  lookupValue[colName] = lookupVal;
                  tempColumnsValueMap[colName] = lookupVal;

                  editData = tempColumnsValueMap;
                  debugPrint("..........columap$editData");
                } catch (e) {
                  Logs.logData("templkup::", tempLookupList.length.toString());
                }
              }
            }
          }
        }
        Logs.logData("edit data:::::::", columnsValueMap.toString());
      }

      /// fetch PK
      List<MetadataColumnsResponse> colName =
          allColumnsList.where((p0) => p0.mdcKeyinfo == 'PK').toList();
      // set PK key
      pkKeyName = colName[0].mdcColName;
      // set PK value
      newEditMode == Strings.kParamEdit
          ? pkKeyValue = columnsValueMap[pkKeyName]
          : pkKeyValue = '';

      /// call 1st tab data
      if (columnTabsList.isNotEmpty) {
        onTapTab(0);
      } else {
        showAllColumns();
      }

      valueSetFlag.value = true;

      ///validation fields
      if (mdcSysIdListStr.trim().isNotEmpty) {
        /// remove first ','
        mdcSysIdListStr = mdcSysIdListStr.trim().replaceFirst(',', '').trim();

        /// validation apis
        getValidationFields(mdcSysId: mdcSysIdListStr);
        getMtValidationColumns(mdcSysId: mdcSysIdListStr);
      }
    } else {
      isIndicatorVisibility.value = false;
    }
  }

  Future<void> getLookup({
    required String fieldName,
    required String query,
    String? where,
    dynamic defaultValueMap,
  }) async {
    String convertedWhere = await comboConcatenate(
        fformula: where!, obj: defaultValueMap, ptbName: metaTableName);
    debugPrint(".................combowhere$where");
    debugPrint(".................wherequery$convertedWhere");
    final response = await apiClient.rapidRepo
        .getLookupData(query: query, where: convertedWhere);
    debugPrint(".................combodefaultmap$defaultValueMap");
    debugPrint(".................comboptbName$metaTableName");
    debugPrint(".................query$query");
    debugPrint(".................responsegetlookup${jsonEncode(response)}");
    if (response.status) {
      // debugPrint(".............if");
      List<dynamic> dataResponse = response.data;
      List<LookupResponse> lookupData = [];
      for (int i = 0; i < dataResponse.length; ++i) {
        dynamic encodeData = json.encode(dataResponse[i]);
        final decode = json.decode(encodeData);
        LookupResponse response = LookupResponse.fromJson(decode);
        lookupData.add(response);
      }
      lookupList[fieldName] = lookupData;
      // debugPrint(".............look${jsonEncode(lookupList[fieldName])}");
      // lookupValue[fieldName] = '';
    } else {
      // debugPrint(".............lookelse");
      lookupList[fieldName] = [];
      lookupValue[fieldName] = '';
    }
  }

  Future<dynamic> encryptValue(int index, String value) async {
    /// fetch default value
    dynamic defaultVal = await getDefaultValues(
      selectedTabColumnsList[index].mdcDefaultvalue!,
      columnsValueMap,
      parentTable,
      parentRowData,
      selectedTabColumnsList[index].mdcDatatype!,
    );
    dynamic responseData = '';
    if (defaultVal == 'null' || defaultVal == '' || defaultVal == null) {
      defaultVal = '';
    } else {
      defaultVal = defaultVal['val'];

      ///decrypt value
      responseData = await AesEncryption().decrypt(value, defaultVal);
      if (responseData ==
              'javax.crypto.BadPaddingException: error:1e000065:Cipher functions:OPENSSL_internal:BAD_DECRYPT' ||
          responseData ==
              'java.security.spec.InvalidKeySpecException: Could not generate secret key') {
        responseData = value;
      }
    }
    return responseData;
  }

  String getPageCaption() {
    String captionColumnName = '';
    RxString caption = 'Details'.obs;

    /// set page title
    for (int i = 0; i < allColumnsList.length; ++i) {
      if (allColumnsList[i].mdcKeyinfo == 'CAPTION') {
        captionColumnName = allColumnsList[i].mdcColName;
      }
    }
    if (captionColumnName.isNotEmpty && columnsValueMap.isNotEmpty) {
      String menuTitle = columnsValueMap[captionColumnName] ?? '';
      if (newEditMode == Strings.kParamNew) {
        caption.value = 'Add $menuTitle Details';
      } else {
        caption.value = 'Edit $menuTitle Details';
      }
      return caption.value;
    } else {
      if (newEditMode == Strings.kParamNew) {
        caption.value = 'Add ${argumentData['MENU_TITLE']} Details';

        ///****///
      } else {
        caption.value = 'Edit ${argumentData['MENU_TITLE']} Detail';
      }
      return caption.value;
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
      // showSearchColumns(
      //     tabName: searchTabTable[searchTabTable.length].toString());
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
    List<MetadataColumnsResponse> list = [];
    if (parentRowData.isEmpty) {
      list = allColumnsList
          .where((element) =>
              element.mdcMtgGrpname == tabName && element.mdcVisible == 'Y')
          .toList();
    } else {
      list = allColumnsList
          .where((element) =>
              element.mdcMtgGrpname == tabName && element.mdcGridVisible == 'Y')
          .toList();
    }

    selectedTabColumnsList.clear();
    selectedTabColumnsList.value = list;

    /// sort list data
    selectedTabColumnsList.sort((a, b) => a.mdcSeqnum.compareTo(b.mdcSeqnum));
  }

  void showAllColumns() {
    List<MetadataColumnsResponse> list = [];
    if (parentRowData.isEmpty) {
      list =
          allColumnsList.where((element) => element.mdcVisible == 'Y').toList();
    } else {
      list = allColumnsList
          .where((element) => element.mdcGridVisible == 'Y')
          .toList();
    }
    selectedTabColumnsList.clear();
    selectedTabColumnsList.value = list;

    /// sort list data
    selectedTabColumnsList.sort((a, b) => a.mdcSeqnum.compareTo(b.mdcSeqnum));
  }

  Future<void> getValidationFields({required String mdcSysId}) async {
    final response =
        await apiClient.rapidRepo.getValidation(mdcSysIds: mdcSysId);
    if (response.status) {
      dynamic dataResponse = response.data;
      if (dataResponse.isNotEmpty) {
        for (int i = 0; i < dataResponse.length; ++i) {
          String res = json.encode(dataResponse[i]);
          final jsonDecode = json.decode(res);
          MetadataValidationResponse data =
              MetadataValidationResponse.fromJson(jsonDecode);
          validationDataList.add(data);
          if (data.mdvValType == 'REQUIRED') {
            requiredDataList.add(data.mdvMdcColName);
          }
        }
      }
    }
  }

  Future<void> getMtValidationColumns({required String mdcSysId}) async {
    final response =
        await apiClient.rapidRepo.getMtValidationColumns(mdcSysIds: mdcSysId);
    if (response.status) {
      dynamic dataResponse = response.data;
      if (dataResponse.isNotEmpty) {
        for (int i = 0; i < dataResponse.length; ++i) {
          String res = json.encode(dataResponse[i]);
          final jsonDecode = json.decode(res);
          MtDataValidationResponse data =
              MtDataValidationResponse.fromJson(jsonDecode);
          validationColumnsList.add(data);
        }
      }
    }
  }

  Future<void> getMtValidationButtons({required String mdcSysId}) async {
    final response =
        await apiClient.rapidRepo.getMtValidationButtons(mdcSysIds: mdcSysId);
    if (response.status) {
      dynamic dataResponse = response.data;
      if (dataResponse.isNotEmpty) {
        for (int i = 0; i < dataResponse.length; ++i) {
          String res = json.encode(dataResponse[i]);
          final jsonDecode = json.decode(res);
          MtDataValidationResponse data =
              MtDataValidationResponse.fromJson(jsonDecode);
          validationButtonList.add(data);
        }
      }
    }
  }

  void checkValidation(
      {required String changedValue,
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
        debugPrint("lookupdefauktmaplok:$tempColumnsValueMap");
      }
    }
    for (var key in lookupValue.keys) {
      if (tempColumnsValueMap.keys.contains(key)) {
        tempColumnsValueMap[key] = lookupValue[key];
        debugPrint("lookupdefauktmap:${tempColumnsValueMap[key]}");
      }
    }

    for (var key in tagboxValue.keys) {
      if (tempColumnsValueMap.keys.contains(key)) {
        tempColumnsValueMap[key] = tagboxValue[key];
        debugPrint("lookupdefauktmapTAG:${tempColumnsValueMap[key]}");
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
          print('defaultvalue..............$defaultVal');
          if (defaultVal == 'null' || defaultVal == '' || defaultVal == null) {
            defaultVal = '';
          } else {
            defaultVal = defaultVal['val'];
          }
          columnsValueMap[key] = defaultVal;
          debugPrint("getcontrol:::${defaultVal}");
          int index = selectedTabColumnsList
              .indexWhere((element) => element.mdcColName == key);
          if (index != -1) {
            getControllerValue(key, index, true);
            debugPrint("getcontrol:::${getControllerValue(key, index, true)}");
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
    List<MtDataValidationResponse> valCol = validationColumnsList
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
            debugPrint('.................1${columnsValueMap[columnName]}');
          }
        }
      }
    } else {
      columnsValueMap[colName] = changedValue;
      debugPrint('.................2${columnsValueMap[colName]}');
    }

    Logs.logData("columnsValueMap::", columnsValueMap.toString());

    /// button validation
    buttonValidation(colName, changedValue);
  }

  void getButtonsActions(String modeType) async {
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
    if (parentButtonList.isNotEmpty) {
      buttonsList.value = parentButtonList;
    } else {
      if (modeType == Strings.kParamNew) {
        // filter used buttons by type=New
        List<MetadataCommandResponse> visibleButtons = btnAll
            .where((element) =>
                element.mdcdMdtSysId == metaTableId &&
                (element.mdcdType == Strings.kParamNew ||
                    element.mdcdType == Strings.kParamBoth))
            .toList();
        buttonsList.value = visibleButtons;
      } else if (modeType == Strings.kParamEdit) {
        // filter used buttons by type=Edit
        List<MetadataCommandResponse> visibleButtons = btnAll
            .where((element) =>
                element.mdcdMdtSysId == metaTableId &&
                (element.mdcdType == Strings.kParamEdit ||
                    element.mdcdType == Strings.kParamBoth))
            .toList();
        buttonsList.value = visibleButtons;
      }
    }

    if (buttonsList.isNotEmpty) {
      /// sort list data
      buttonsList.sort((a, b) => a.mdcdSeqnum.compareTo(b.mdcdSeqnum));
      List<MetadataCommandResponse> buttons = [];
      buttons.addAll(buttonsList);

      List<int> sysIds =
          buttonsList.map((element) => element.mdcdSysId).toList();
      String sysIdStr = sysIds.toString();
      String btnSysId1 = sysIdStr.replaceAll('[', '').trim();
      String btnSysId = btnSysId1.replaceAll(']', '').trim();
      getMtValidationButtons(mdcSysId: btnSysId);
    }
  }

  void isChildTableAvailable() async {
    final response = await apiClient.rapidRepo.getChild(sysId: metaTableId);
    childTables.clear();
    if (response.status) {
      List<dynamic> dataResponse = response.data;
      if (dataResponse.isNotEmpty) {
        isChildTablePlusIcon.value = true;
        for (int i = 0; i < dataResponse.length; ++i) {
          dynamic encodeData = json.encode(dataResponse[i]);
          final decodeData = json.decode(encodeData);
          MetadataTableIsChild rep = MetadataTableIsChild.fromJson(decodeData);
          childTables.add(rep);
        }
        final childResponse =
            await apiClient.rapidRepo.getChildTable(sysId: metaTableId);
        if (childResponse.status) {
          List<dynamic> childDataResponse = childResponse.data;
          for (int i = 0; i < childDataResponse.length; i++) {
            dynamic encodeData = json.encode(childDataResponse[i]);
            final decodeData = json.decode(encodeData);
            MetadataTableIsChild rep =
                MetadataTableIsChild.fromJson(decodeData);
            childTables.add(rep);
          }
        }

        List<MetadataTableIsChild> childList =
            childTables.where((p0) => p0.mdtChildRowCond != '').toList();
        for (int i = 0; i < childList.length; ++i) {
          dynamic query = await comboConcatenate(
              fformula: childList[i].mdtChildRowCond!,
              obj: columnsValueMap,
              ptbName: metaTableName);
          final childCondResp =
              await apiClient.rapidRepo.getChartGraph(query: query.toString());
          if (childCondResp.status) {
            if (childCondResp.data.length == 0) {
              /// remove corresponding child table
              childTables.removeWhere(
                  (element) => element.mdtTblName == childList[i].mdtTblName);
            }
          }
        }
      } else {
        isChildTablePlusIcon.value = false;
      }
    }
  }

  void onButtonClick(int mdcdSysId) {
    List<MetadataActionResponse> actionsList = buttonActionsList
        .where((element) => element.mdaMdcdSysId == mdcdSysId)
        .toList();
    actionsList.sort((a, b) => a.mdaSeqnum.compareTo(b.mdaSeqnum));

    for (int i = 0; i < actionsList.length; i++) {
      String action = actionsList[i].mdaAction.toString();
      String arg1 = actionsList[i].mdaArg1.toString();
      String arg2 = actionsList[i].mdaArg2.toString();
      String arg3 = actionsList[i].mdaArg3.toString();
      if (action == 'BeginTrans' || action == 'CommitTrans') {
        continue;
      } else if (action == 'Message') {
        Get.snackbar(Strings.kMessage, actionsList[i].mdaArg1.toString());
      } else if (action == 'Alert') {
        bool? alertResponse = showAlert(
          message: actionsList[i].mdaArg1.toString(),
        );
        if (alertResponse!) {
          continue;
        } else {
          break;
        }
      } else if (action == 'Cancel') {
        // clearTypedData();
        Get.back(result: {
          'sysId': pkKeyValue,
          'mode': mode,
          'MENU_COL_DATA': recallResponse,
        });
        break;
      } else if (action == 'Close') {
        Get.back(result: {
          'sysId': pkKeyValue,
          'mode': mode,
          'MENU_COL_DATA': recallResponse,
        });
        // Get.back();
        break;
      } else if (action == 'Report') {
        reportData(arg3);
        break;
      } else {
        String nextAction = actionsList[i].mdaAction.toString();
        String message = '';
        if (nextAction == 'CommitTrans') {
          i = i + 2;
          String nxtAction = actionsList[i].mdaAction.toString();
          if (nxtAction == 'Message') {
            try {
              message = actionsList[i + 1].mdaArg1.toString();
            } catch (e) {
              message = actionsList[i].mdaArg1.toString();
            }
          }
        } else if (nextAction == 'Message') {
          try {
            message = actionsList[i + 1].mdaArg1.toString();
            // message = actionsList[i + 1].mdaArg1.toString();
          } catch (e) {
            message = actionsList[i].mdaArg1.toString();
          }
          i++;
        }
        buttonActions(action, arg3, message, arg1, arg2);
      }
    }
  }

  bool? showAlert({required String message}) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(
        top: 20,
        bottom: 10,
      ),
      contentPadding: const EdgeInsets.all(20.0),
      radius: 15.0,
      titleStyle: Theme.of(Get.context!)
          .textTheme
          .headline1!
          .copyWith(fontSize: 16, fontWeight: FontWeight.normal),
      backgroundColor: Theme.of(Get.context!).primaryColor,
      barrierDismissible: false,
      title: message,
      textCancel: Strings.kCancel,
      textConfirm: Strings.kOk,
      buttonColor: Theme.of(Get.context!).backgroundColor,
      cancelTextColor: Theme.of(Get.context!).backgroundColor,
      confirmTextColor: Theme.of(Get.context!).primaryColor,
      onCancel: () => onAlertCancel(),
      onConfirm: () => onAlertOk(),
    );
    return null;
  }

  bool onAlertCancel() {
    Get.back();
    return false;
  }

  bool onAlertOk() {
    Get.back();
    return true;
  }

  dynamic buttonActions(
      String action, String arg3, String message, String arg1, String arg2) {
    switch (action) {
      case 'Save':
        addEditData(message);
        debugPrint(".......add");
        break;
      case 'Update':
        addEditData(message);
        debugPrint(".......update");
        break;
      case 'DbProcedure':
        Logs.logData("dbProcedure:::", '$arg1-$arg2-$message');
        dbProcedure(arg1, arg2, message);
        break;
    }
  }

  Future<dynamic> fetchAllColumnsData() async {
    Map<String, String> saveDataMap = {};
    for (var key in textEditingControllerMap.keys) {
      int columnIndex = allColumnsList
          .indexWhere((element) => element.mdcColName.contains(key));
      String columnDataType =
          allColumnsList[columnIndex].mdcDatatype.toString().trim();
      if (columnDataType == 'LOOKUP') {
        String value = textEditingControllerMap[key]!
            .value
            .text
            .toString()
            .split(":")
            .first
            .trim();
        // String value = tagboxValue[key].toString();
        // String value = lookupValue[key].toString();
        // String value = selectedItemsList[key].toString().split(":").first.trim();
        debugPrint("..............StringTextlookup:$value");
        if (value != '') {
          saveDataMap[key] = value;
        }
      } else if (columnDataType == 'TAGBOX' || columnDataType == 'SFTAGBOX') {
        String value = tagboxValue[key].toString();
        debugPrint("..............StringText:$value");
        if (value != 'null') {
          saveDataMap[key] = value;
        }
      } else {
        if (key.contains("FLAG")) {
          textEditingControllerMap[key]!.value =
              const TextEditingValue(text: "N");
          debugPrint(
              ".............text:::${textEditingControllerMap[key]!.text}");
        }
        // String value = selectedItemsList[key].toString().split(":").first.trim();
        String value = textEditingControllerMap[key]!.value.text.toString();
        debugPrint("..........Stringtext$value,$key");
        if (value != '') {
          saveDataMap[key] = value;
        }
      }
    }

    ///  required validation with error message
    if (requiredDataList.isNotEmpty) {
      for (var item in requiredDataList) {
        if (saveDataMap.keys.contains(item)) {
        } else {
          List<MetadataValidationResponse> validationMessage =
              validationDataList
                  .where((element) => element.mdvMdcColName == item)
                  .toList();

          List<MetadataColumnsResponse> colNames =
              allColumnsList.where((emt) => emt.mdcColName == item).toList();

          if (colNames.isNotEmpty) {
            String message = '';
            for (int i = 0; i < validationMessage.length; ++i) {
              message = validationMessage[i].mdvValMessage.toString() +
                  "\n" +
                  message;
            }
            Get.snackbar(
              colNames[0].mdcMetatitle + " Field ",
              message.trim(),
            );
            break;
          }
        }
      }
    }

    /// other validation with error message
    String valFlag = '';
    newEditMode == Strings.kEdit ? valFlag = 'E' : valFlag = 'I';
    for (var key in saveDataMap.keys) {
      String columnName = key;
      List<MetadataValidationResponse> validations = validationDataList
          .where((element) => element.mdvMdcColName == columnName)
          .toList();
      for (int j = 0; j < validations.length; ++j) {
        /// check validation type where I-insert,E-edit & B-both
        if (validations[j].mdvValType == valFlag ||
            validations[j].mdvValType == 'B') {
          /// check all validations except requered
          dynamic validationStatus = await columnValidations(
            colValue: saveDataMap[key]!,
            colLength: validations[j].mdvColLength,
            valTye: validations[j].mdvValType,
            valQry: validations[j].mdvValQuery,
            condition: validations[j].mdvCondition == ''
                ? ''
                : saveDataMap[validations[j].mdvCondition],
            colName: key,
            saveDataMap: saveDataMap,
          );

          /// check data valid or not
          if (validationStatus != true) {
            Get.snackbar(
                Strings.kMessage, validations[j].mdvValMessage.toString());
            break;
          }
        }
      }
    }
    if (saveDataMap.isNotEmpty) {
      return saveDataMap;
    } else {
      saveDataMap.clear();
      return saveDataMap;
    }
  }

  void dbProcedure(String arg1, String arg2, String message) async {
    Map<String, String> saveDataMap = {};
    saveDataMap = await fetchAllColumnsData();
    if (saveDataMap.isNotEmpty) {
      String prodcr = "";
      var tmp = "";
      var tmp2 = "";
      prodcr = await comboConcatenate(
          fformula: arg2, obj: columnsValueMap, ptbName: metaTableName);
      List<Map<String, dynamic>> paramsData = [];
      if (prodcr.contains("�")) {
        var strpar = prodcr.split("�");
        for (var m in strpar) {
          var strval = m.split("=");
          for (var n in strval) {
            if (n.startsWith(":")) {
              tmp = n;
            } else {
              tmp2 = n;
            }
          }
          dynamic prms = {Strings.kName: tmp, Strings.kValue: tmp2};
          paramsData.add(prms);
        }
      } else {
        var strval = prodcr.split("=");
        for (var n in strval) {
          if (n.startsWith(":")) {
            tmp = n;
          } else {
            tmp2 = n;
          }
        }
        dynamic prms = {Strings.kName: tmp, Strings.kValue: tmp2};
        paramsData.add(prms);
      }

      /// encode key-value param list
      dynamic param = json.encode(paramsData);
      addDbProcedure(query: arg1, param: param, serverMsg: message);
    }
  }

  void addEditData(String serverMsg) async {
    debugPrint("..................server-debugPrint");
    Map<String, String> saveDataMap = {};
    saveDataMap = await fetchAllColumnsData();
    if (saveDataMap.isNotEmpty) {
      List<MetadataColumnsResponse> defaultValueColms = allColumnsList
          .where((element) =>
              element.mdcVisible != 'Y' &&
              element.mdcDatatype != 'TAGBOX' &&
              element.mdcDatatype != 'SFTAGBOX' &&
              element.mdcDatatype != 'LOOKUP')
          .toList();
      for (int i = 0; i < defaultValueColms.length; ++i) {
        String colName = defaultValueColms[i].mdcColName;
        if (columnsValueMap[colName] != '') {
          saveDataMap[colName] = columnsValueMap[colName].toString();
        }
      }
      List<MetadataColumnsResponse> defaultValueColmsTemp = allColumnsList
          .where((element) =>
              element.mdcPrwTempVisble != 'Y' &&
              element.mdcDatatype != 'TAGBOX' &&
              element.mdcDatatype != 'SFTAGBOX' &&
              element.mdcDatatype != 'LOOKUP')
          .toList();
      for (int i = 0; i < defaultValueColmsTemp.length; ++i) {
        String colName = defaultValueColmsTemp[i].mdcColName;
        if (columnsValueMap[colName] != '') {
          saveDataMap[colName] = columnsValueMap[colName].toString();
        }
      }

      /// password encryption
      List<MetadataColumnsResponse> passwordColm =
          allColumnsList.where((element) => element.mdcEncrypt == 'Y').toList();
      for (int i = 0; i < passwordColm.length; ++i) {
        if (saveDataMap.keys.contains(passwordColm[i].mdcColName)) {
          String value = saveDataMap[passwordColm[i].mdcColName].toString();
          if (value.isNotEmpty) {
            /// fetch default value
            dynamic defaultVal = await getDefaultValues(
              passwordColm[i].mdcDefaultvalue!,
              columnsValueMap,
              parentTable,
              parentRowData,
              passwordColm[i].mdcDatatype!,
            );
            Logs.logData("password:", defaultVal);

            if (defaultVal != 'null' ||
                defaultVal != '' ||
                defaultVal != null) {
              defaultVal = defaultVal['val'];
              debugPrint("...............passwordencryption");

              /// decrypt value
              dynamic responseData =
                  await AesEncryption().encrypt(value, defaultVal);
              if (responseData !=
                      'javax.crypto.BadPaddingException: error:1e000065:Cipher functions:OPENSSL_internal:BAD_DECRYPT' ||
                  responseData !=
                      'java.security.spec.InvalidKeySpecException: Could not generate secret key') {
                saveDataMap[passwordColm[i].mdcColName] = responseData;
              }
            }
          }
        }
      }

      if (newEditMode == Strings.kParamEdit) {
        for (int i = 0; i < allColumnsList.length; ++i) {
          if (allColumnsList[i].mdcKeyinfo == 'UPDDT') {
            /// get current date
            var now = DateTime.now();
            var formatter = DateFormat("dd/MMM/yy");
            String currentDate = formatter.format(now);
            debugPrint("................currentdate:$currentDate");

            saveDataMap[allColumnsList[i].mdcColName] = currentDate;
          }
        }

        List<MetadataColumnsResponse> dateList =
            allColumnsList.where((p0) => p0.mdcDatatype == 'DATE').toList();
        for (int i = 0; i < dateList.length; ++i) {
          String? val = saveDataMap[dateList[i].mdcColName];
          if (saveDataMap[dateList[i].mdcDefaultvalue.toString()] != 'Null') {
            if (val != null || val != '') {
              try {
                DateTime date = DateTime.parse(val!);
                dynamic value = DateFormat('dd/MMM/yy').format(date).toString();
                saveDataMap[dateList[i].mdcColName] = value.toString();
                debugPrint(
                    "................date:${saveDataMap[dateList[i].mdcColName]}");
              } catch (error) {
                Logs.logData("date:", val.toString());
              }
            }
          }
        }
        saveDataMap
            .removeWhere((key, value) => value == 'null' || value.isEmpty);

        for (var key in saveDataMap.keys) {
          String kVal = saveDataMap[key].toString();
          if (kVal.contains('.0')) {
            kVal = kVal.substring(0, kVal.length - 2);
            saveDataMap[key] = kVal;
          }
        }

        List<String> unBoundColumns = allColumnsList
            .where((element) => element.mdcUnbound != 'Y')
            .map((e) => e.mdcColName)
            .toList();
        saveDataMap.removeWhere((key, value) => !unBoundColumns.contains(key));

        String updateData = '';
        for (var key in saveDataMap.keys) {
          updateData = updateData + ", $key = '${saveDataMap[key]}'";
        }

        /// remove first ','
        updateData = updateData.trim().replaceFirst(',', '').trim();

        /// query
        String queryData =
            "UPDATE $metaTableName SET $updateData WHERE $pkKeyName='$pkKeyValue'";

        /// body
        dynamic queryBody = {Strings.kQuery: queryData};
        dynamic body = json.encode(queryBody);

        Logs.logData("final body::", body.toString());
        addOrEditCall(
          tableName: 'UpdateData',
          body: body,
          serverMsg: serverMsg,
          passingValueMap: saveDataMap,
        );
      } else {
        for (int i = 0; i < allColumnsList.length; ++i) {
          if (allColumnsList[i].mdcKeyinfo == 'CRDT') {
            /// get current date
            var now = DateTime.now();
            var formatter = DateFormat("dd/MMM/yy");
            String currentDate = formatter.format(now);
            debugPrint("............currentdate$currentDate");
            saveDataMap[allColumnsList[i].mdcColName] = currentDate;
          }
        }

        for (var key in saveDataMap.keys) {
          String kVal = saveDataMap[key].toString();
          if (kVal.contains('.0')) {
            kVal = kVal.substring(0, kVal.length - 2);
            saveDataMap[key] = kVal;
          }
        }
        List<String> unBoundColumns = allColumnsList
            .where((element) => element.mdcUnbound != 'Y')
            .map((e) => e.mdcColName)
            .toList();
        saveDataMap.removeWhere((key, value) => !unBoundColumns.contains(key));

        dynamic body = json.encode(saveDataMap);

        Logs.logData("final body::", body.toString());
        addOrEditCall(
          tableName: metaTableId.toString(),
          body: body,
          serverMsg: serverMsg,
          passingValueMap: saveDataMap,
        );
      }
    }
  }

  Future<bool> columnValidations({
    required String valTye,
    required String colValue,
    int? colLength,
    String? valQry,
    String? condition,
    required String colName,
    required dynamic saveDataMap,
  }) async {
    switch (valTye) {
      case 'GREATERTHAN':
        return isGreaterThan(value: colValue, colLength: colLength);
      case 'GREATERTHANEQL':
        return isGreaterThanEqual(value: colValue, colLength: colLength);
      case 'LESSTHAN':
        return isLessThan(value: colValue, colLength: colLength);
      case 'LESSTHANEQL':
        return isLessThanEqual(value: colValue, colLength: colLength);
      case 'ISEMAIL':
        return isEmail(eMail: colValue);
      case 'MAXLENGTH':
        return isMaxLength(value: colValue, colLength: colLength);
      case 'MINLENGTH':
        return isMinLength(value: colValue, colLength: colLength);
      case 'ISMOBNO':
        return isMobileNumber(mobNumber: colValue);
      case 'ISPINCODE':
        return isPinCode(pinCode: colValue);
      case 'ISDATE':
        return isDate(value: colValue);
      case 'ISNUMBER':
        return isNumber(number: colValue);
      case 'QUERY_VAL':
        return await isQueryValue(value: colValue, valQuery: valQry);
      case 'QUERY_PARAM':
        return await isQueryParam(
            value: colValue, valQuery: valQry, saveDataMap: saveDataMap);
      case 'CONFIRM_PWD':
        return isConfirmPassword(value: colValue, condition: condition);
      case 'UNIQUE':
        return await isUnique(
            value: colValue, valQuery: valQry, columnName: colName);
      default:
        return false;
    }
  }

  void addDbProcedure({
    required String query,
    required dynamic param,
    required String serverMsg,
  }) async {
    debugPrint("...................testing");
    isButtonClickLoader.value = true;

    /// Getting meta data frm the API
    final menuDataResponse =
        await apiClient.rapidRepo.getDbProcedure(query: query, param: param);
    if (menuDataResponse.status) {
      isButtonClickLoader.value = false;
      Get.snackbar(
        Strings.kMessage,
        serverMsg,
      );
    } else {
      isButtonClickLoader.value = false;
      Logs.logData("dbProcedureMsg:", menuDataResponse.message.toString());
    }
  }

  /// add or edit
  Future<void> addOrEditCall({
    required String tableName,
    required dynamic body,
    required String serverMsg,
    required Map<String, dynamic> passingValueMap,
  }) async {
    debugPrint("................Add and edit");
    isButtonClickLoader.value = true;

    /// Getting meta data frm the API
    final menuDataResponse = await apiClient.rapidRepo
        .getInsertData(body: body, tableName: tableName);
    if (menuDataResponse.status) {
      isButtonClickLoader.value = false;
      dynamic insertData = menuDataResponse.data;
      passingValueMap[pkKeyName] = insertData.toString();
      columnsValueParentMap = passingValueMap;
      if (newEditMode == Strings.kParamNew) {
        mode = Strings.kParamNew;
      } else {
        mode = Strings.kParamEdit;
      }
      if (serverMsg == '') {
        Get.snackbar(
          Strings.kMessage,
          menuDataResponse.message,
          duration: const Duration(seconds: 10),
        );
      } else {
        Get.snackbar(
          Strings.kMessage,
          serverMsg,
          duration: const Duration(seconds: 10),
        );
      }
      if (newEditMode != Strings.kParamEdit) {
        if (insertData != null) {
          pkKeyValue = menuDataResponse.data;
          // check child table is available or not
          isChildTableAvailable();
        }
        // change buttons
        newEditMode = Strings.kParamEdit;
        if (parentButtonList.isEmpty) {
          getButtonsActions(newEditMode);
        }
      }
      // recall data
      reCallData();
    } else {
      isButtonClickLoader.value = false;
      Get.snackbar(
        Strings.kMessage,
        menuDataResponse.message.toString() +
            " " +
            menuDataResponse.data.toString(),
        // "servererror",
        duration: const Duration(seconds: 10),
      );
    }
  }

  // void getChildTable(int i, TextEditingController _textEditingController,
  //     columnName, valueField) async {
  //   if (selectedTabColumnsList[i].mdcDatatype == 'TAGBOX' ||
  //       selectedTabColumnsList[i].mdcDatatype == 'SFTAGBOX' ) {
  //     debugPrint("...............datapaees$columnName:::$valueField");
  //     debugPrint("**********SelectTabcol:${jsonEncode( selectedTabColumnsList[i])}");
  //     debugPrint("**********columap:${jsonEncode(columnsValueMap)}");
  //     debugPrint("**********metatable:${jsonEncode(metaTableName)}");
  //     debugPrint("**********text:${jsonEncode(_textEditingController.text)}");
  //     final result = await Get.to(() => const TagBoxTableGridPage(),
  //         binding: TagBoxTableGridBinding(),
  //         arguments: {
  //           'column': selectedTabColumnsList[i],
  //           'menuName': metaTableName,
  //           'rowData': columnsValueMap,
  //           'editValue': _textEditingController.text,
  //         });
  //
  //     Map<String, dynamic> tagBoxMap = {};
  //     tagBoxMap.addAll(result['tagBox']);
  //     columnsValueMap[columnName] = tagBoxMap[valueField];
  //
  //     /// store selected column text and value fields
  //     selectedTagbox[result['MDC_TEXTFIELDNAME']] =
  //         tagBoxMap[selectedTabColumnsList[i].mdcValuefieldname];
  //     tagboxValue[selectedTabColumnsList[i].mdcColName] =
  //         tagBoxMap[selectedTabColumnsList[i].mdcValuefieldname].toString();
  //
  //     /// set selected column textfield to controller
  //     _textEditingController.value = TextEditingValue(
  //       text: result['MDC_TEXTFIELDNAME'],
  //     );
  //
  //     /// tagbox value binding
  //     Map<String, dynamic> bindColVal = result['BIND_COL_VAL'];
  //
  //     if (bindColVal.isNotEmpty) {
  //       for (var key in bindColVal.keys) {
  //         // columnsValueMap[key] = bindColVal[key];
  //         columnsValueMap.update(key, (value) => bindColVal[key]);
  //         textEditingControllerMap[key]!.value =
  //             TextEditingValue(text: bindColVal[key]);
  //       }
  //     }
  //   } else {
  //     Logs.logData('TagBox', 'else Case');
  //   }
  // }

  void getChildTable(int i, TextEditingController _textEditingController,
      columnName, valueField) async {
    if (selectedTabColumnsList[i].mdcDatatype == 'TAGBOX' ||
        selectedTabColumnsList[i].mdcDatatype == 'LOOKUP' ||
        selectedTabColumnsList[i].mdcDatatype == 'SFTAGBOX') {
      debugPrint(
          "..............lookuplookupdatapaees$columnName:::${_textEditingController.text}");
      debugPrint(
          "**********lookupSelectTabcol:${jsonEncode(selectedTabColumnsList[i])}");
      debugPrint("**********lookupcolumap:${jsonEncode(columnsValueMap)}");
      debugPrint("**********lookupmetatable:${jsonEncode(metaTableName)}");
      debugPrint(
          "**********lookuptext:${jsonEncode(_textEditingController.text)}");
      final result = await Get.to(() => const TagBoxTableGridPage(),
          binding: TagBoxTableGridBinding(),
          arguments: {
            'column': selectedTabColumnsList[i],
            'menuName': metaTableName,
            'rowData': columnsValueMap,
            'editValue': _textEditingController.text,
          });
      // checkValidation(
      //   changedValue: result['MDC_TEXTFIELDNAME'].toString(),
      //   valueField: result['MDC_TEXTFIELDNAME'].toString(),
      //   colName: result['colName'].toString(),
      //   dataType: result['datatype'].toString(),
      // );
      Map<String, dynamic>? tagBoxMap = result['tagBox'];
      if (tagBoxMap != null) {
        columnsValueMap[columnName] = tagBoxMap[valueField];

        /// store selected column text and value fields
        selectedTagbox[result['MDC_TEXTFIELDNAME']] =
            tagBoxMap[selectedTabColumnsList[i].mdcValuefieldname];
        tagboxValue[selectedTabColumnsList[i].mdcColName] =
            tagBoxMap[selectedTabColumnsList[i].mdcValuefieldname].toString();

        /// set selected column textfield to controller
        _textEditingController.value = TextEditingValue(
          text: result['MDC_TEXTFIELDNAME'],
        );

        /// tagbox value binding
        Map<String, dynamic>? bindColVal =
            result['BIND_COL_VAL']; // Added nullability

        if (bindColVal != null && bindColVal.isNotEmpty) {
          // Added null check
          for (var key in bindColVal.keys) {
            // columnsValueMap[key] = bindColVal[key];
            columnsValueMap.update(key, (value) => bindColVal[key]);
            textEditingControllerMap[key]!.value =
                TextEditingValue(text: bindColVal[key]);
          }
        }
      } else {
        const Center(child: Text("No data to display"));
      }
    } else {
      Logs.logData('TagBox', 'else Case');
    }
  }

  // void getChildTables(int i, TextEditingController _textEditingController,
  //     columnName, valueField) async {
  //   if (selectedTabColumnsList[i].mdcDatatype == 'LOOKUP') {
  //     debugPrint("..............lookuplookupdatapaees$columnName:::$valueField");
  //     debugPrint("**********lookupSelectTabcol:${jsonEncode( selectedTabColumnsList[i])}");
  //     debugPrint("**********lookupcolumap:${jsonEncode(columnsValueMap)}");
  //     debugPrint("**********lookupmetatable:${jsonEncode(metaTableName)}");
  //     debugPrint("**********lookuptext:${jsonEncode(_textEditingController.text)}");
  //     final result = await Get.to(() => const TagBoxTableGridPage(),
  //         binding: TagBoxTableGridBinding(),
  //         arguments: {
  //           'column': selectedTabColumnsList[i],
  //           'menuName': metaTableName,
  //           'rowData': columnsValueMap,
  //           'editValue': _textEditingController.text,
  //         });
  //
  //     Map<String, dynamic> tagBoxMap = {};
  //     tagBoxMap.addAll(result['tagBox']);
  //     columnsValueMap[columnName] = tagBoxMap[valueField];
  //
  //     /// store selected column text and value fields
  //     selectedTagbox[result['MDC_TEXTFIELDNAME']] =
  //     tagBoxMap[selectedTabColumnsList[i].mdcValuefieldname];
  //     tagboxValue[selectedTabColumnsList[i].mdcColName] =
  //         tagBoxMap[selectedTabColumnsList[i].mdcValuefieldname].toString();
  //
  //     /// set selected column textfield to controller
  //     _textEditingController.value = TextEditingValue(
  //       text: result['MDC_TEXTFIELDNAME'],
  //     );
  //
  //     /// tagbox value binding
  //     Map<String, dynamic> bindColVal = result['BIND_COL_VAL'];
  //
  //     if (bindColVal.isNotEmpty) {
  //       for (var key in bindColVal.keys) {
  //         // columnsValueMap[key] = bindColVal[key];
  //         columnsValueMap.update(key, (value) => bindColVal[key]);
  //         textEditingControllerMap[key]!.value =
  //             TextEditingValue(text: bindColVal[key]);
  //       }
  //     }
  //   } else {
  //     Logs.logData('TagBox', 'else Case');
  //   }
  // }

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

    if (result != null) {
      pickedFileName.value = result.files.first.name.toString();
    } else {
      // User canceled the picker
    }
    return result;
  }

  void reportData(String arg3) {
    bool flagUpdate = true;
    Map<String, String> reportDataMap = {};
    for (var key in columnsValueMap.keys) {
      reportDataMap[key] = columnsValueMap[key].toString();
    }
    for (var key in textEditingControllerMap.keys) {
      dynamic value = textEditingControllerMap[key];
      if (value.text.isNotEmpty) {
        reportDataMap[key] = value.text;
      }
    }

    /// validation with message
    if (requiredDataList.isEmpty) {
      flagUpdate = true;
    } else {
      for (var item in requiredDataList) {
        if (reportDataMap.keys.contains(item)) {
          flagUpdate = true;
          continue;
        } else {
          flagUpdate = false;
          List<MetadataValidationResponse> validationMessage =
              validationDataList
                  .where((element) => element.mdvMdcColName == item)
                  .toList();

          List<MetadataColumnsResponse> colNames =
              allColumnsList.where((elmt) => elmt.mdcColName == item).toList();

          String message = '';
          for (int i = 0; i < validationMessage.length; ++i) {
            message =
                validationMessage[i].mdvValMessage.toString() + "\n" + message;
          }
          Get.snackbar(
            colNames[0].mdcMetatitle + " Field",
            message.trim(),
          );
          break;
        }
      }
    }

    if (flagUpdate == true) {
      /// generate body
      if (reportDataMap.isNotEmpty) {
        Map<String, dynamic> reportValueMap = {};

        for (var key in reportDataMap.keys) {
          List<MetadataColumnsResponse> colList = allColumnsList
              .where((element) => element.mdcColName == key)
              .toList();

          if (colList.isNotEmpty) {
            String? reportParam = colList[0].mdcReportparam;
            reportValueMap[reportParam!] = reportDataMap[key];
          }
        }

        String rName = '';
        if (arg3.isEmpty) {
          rName = metaTableName;
        } else {
          rName = arg3;
        }
        reportValueMap.removeWhere((key, value) => key.isEmpty);
        if (reportValueMap.isNotEmpty) {
          List<Map<String, dynamic>> paramsData = [];
          for (var key in reportValueMap.keys) {
            dynamic prms = {
              Strings.kName: key,
              Strings.kValue: reportValueMap[key]
            };
            paramsData.add(prms);
          }
          dynamic bodyParams = json.encode(paramsData);

          String body =
              '{"ReportName":"$rName","tableId":$metaTableId,"param":$bodyParams}';
          reportCall(reportBody: body);
        } else {
          String body =
              '{"ReportName":"$rName","tableId":$metaTableId,"param":[]}';
          reportCall(reportBody: body);
        }
      }
    }
  }

  Future<void> reportCall({required reportBody}) async {
    isButtonClickLoader.value = true;
    final response = await apiClient.rapidRepo.getReportData(body: reportBody);
    if (response.status) {
      isButtonClickLoader.value = false;
      String url = response.data['url'].toString();
      String baseUrl = RapidPref().getBaseUrl().toString();
      baseUrl = baseUrl.replaceAll('api/', '').trim();
      String urlReport = baseUrl + url;
      Logs.logData("urlReport::", urlReport);
      _launchURL(urlReport);
    } else {
      isButtonClickLoader.value = false;
    }
  }

  // _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> _launchURL(String url) async {
    try {
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url)) {
        throw 'Could not launch $_url';
      }
    } catch (e) {
      Get.snackbar(
        Strings.kMessage,
        'No URL is found',
      );
    }
  }

  TextEditingController getControllerValue(
    String columnName,
    int index,
    bool colValUpdateFlag,
  ) {
    /// Checking if the controller is already created
    if (!textEditingControllerMap.containsKey(columnName)) {
      // Taking the initial value from the response
      String initialValue = '';
      for (var key in columnsValueMap.keys) {
        if (key.trim() == columnName.trim()) {
          initialValue = columnsValueMap[key].toString() == "null"
              ? ''
              : columnsValueMap[key].toString();
        }
      }

      /// creating new [TextEditingController] with [initialValue]
      textEditingControllerMap[columnName] =
          TextEditingController(text: initialValue);
    } else if (colValUpdateFlag) {
      textEditingControllerMap[columnName]?.text =
          columnsValueMap[columnName].toString();
    }
    return textEditingControllerMap[columnName]!;
  }

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
      debugPrint('.......................ifcase:$query');
      query =
          "SELECT $valueField FROM ($comboQry) WHERE " "$textField = '$value'";
      debugPrint("....................TagTextfeild:$textField");
    } else {
      print('columnvaluemap$columnsValueMap');
      String convertedWhere = await comboConcatenate(
          fformula: comboWhere, obj: columnsValueMap, ptbName: metaTableName);
      query =
          "SELECT $valueField FROM ($comboQry WHERE $convertedWhere) WHERE $textField = '$value'";
      debugPrint('.......................TagCombowhere:$comboWhere');
      debugPrint('.......................Tagobj:$columnsValueMap');
      debugPrint('.......................TagVAlue:$value');
      debugPrint('.......................comboquery:$comboQry');
      debugPrint('.......................combowhere:$convertedWhere');
      debugPrint('.......................TagtbName:$metaTableName');
      debugPrint('.......................Tagelse case:$convertedWhere');
      debugPrint('.......................Tagelsecase:$query');
    }
    final response = await apiClient.rapidRepo.getBaseData(query);
    debugPrint('.......................Tag_else_case:${jsonEncode(response)}');
    debugPrint('.......................Tag_else_query:$query');
    if (response.status) {
      String textData = response.data[0][valueField].toString();
      selectedTagbox[value] = textData;
      tagboxValue[columnName] = textData;
      debugPrint(
          '......................Selectedtagbox:${selectedTagbox[value]}');
      debugPrint('......................Selectedtag:$textData');
      debugPrint(
          '.......................TagboxValue:${tagboxValue[columnName]}');
      debugPrint("...value$value");
      return value;
    } else {
      debugPrint("...value$value");
      return value;
    }
  }

  // Future<String> getlookupValue({
  //   required String value,
  //   required String comboWhere,
  //   required String textField,
  //   required String comboQry,
  //   required String valueField,
  //   required String columnName,
  // }) async {
  //   String query = '';
  //   if (comboWhere == '') {
  //     query = "SELECT  $valueField  FROM ($comboQry) WHERE $textFeild  = '$value'";
  //   } else {
  //     debugPrint("__________________________________");
  //     String convertedWhere = await comboConcatenate(fformula: comboWhere, obj: columnsValueMap, ptbName: metaTableName);
  //     query = "SELECT  $valueField  FROM ($comboQry WHERE $convertedWhere) WHERE $textFeild  = '$value'";
  //   }
  //   final response = await apiClient.rapidRepo.getBaseData(query);
  //   if (response.status) {
  //     String textData = response.data[0][valueField].toString();
  //     selectedTagbox[value] = textData;
  //     tagboxValue[columnName] = textData;
  //     return value;
  //   } else {
  //     return value;
  //   }
  // }

  Future<void> reCallData() async {
    final response = await apiClient.rapidRepo.getMenuSingleValues(
        sysId: pkKeyValue.toString(),
        keyInfo: pkKeyName,
        tableName: metaTableName);
    if (response.status) {
      recallResponse.clear();
      recallResponse = response.data;
      dynamic dataResp = response.data[0];
      columnsValueMap.addAll(dataResp);
      debugPrint("....colummap.$dataResp");
      Logs.logData("editData:::", columnsValueMap.toString());
    }
  }

  Future<void> fetchMetadataCommandsFromApi() async {
    final response = await apiClient.rapidRepo.getMetadataCommands();
    if (response.status) {
      _saveMetadataCommandsToLocalDb(response.data);
    }
  }

  Future<void> fetchMetadataActionsFromApi() async {
    final response = await apiClient.rapidRepo.getMetadataActions();
    if (response.status) {
      _saveMetadataActionToLocalDb(response.data);
    }
  }

  void _saveMetadataActionToLocalDb(dynamic actionData) async {
    List<MetadataActionResponse> actionTable = [];
    for (int i = 0; i < actionData.length; ++i) {
      String encodeData = json.encode(actionData[i]);
      final decodeData = json.decode(encodeData);
      MetadataActionResponse data = MetadataActionResponse.fromJson(decodeData);
      actionTable.add(data);
    }
    Box box = await dbAccess.openDatabase();
    box.put(Strings.kMetadataActions, actionTable);

    getButtonsActions(newEditMode);
  }

  void _saveMetadataCommandsToLocalDb(dynamic commandsData) async {
    List<MetadataCommandResponse> commandTable = [];
    for (int i = 0; i < commandsData.length; ++i) {
      String encodeData = json.encode(commandsData[i]);
      final val = json.decode(encodeData);
      MetadataCommandResponse data = MetadataCommandResponse.fromJson(val);
      commandTable.add(data);
    }
    Box box = await dbAccess.openDatabase();
    box.put(Strings.kMetadataCommands, commandTable);
    getButtonsActions(newEditMode);
  }

  childPageMove({required int index}) {
    Logs.logData("sysId::", childTables[index].mdtSysId.toString());
    Get.toNamed(
      Strings.kMenuDetailedPage,
      arguments: {
        "MDT_SYS_ID": childTables[index].mdtSysId,
        "MENU_NAME": childTables[index].mdtTblName,
        "MENU_TITLE": childTables[index].mdtTblTitle,
        "MDT_DEFAULT_WHERE": childTables[index].mdtChildwhere ?? '',
        "INSERT": childTables[index].mdtInsert ?? '',
        "UPDATE": childTables[index].mdtUpdate ?? '',
        "DELETE": childTables[index].mdtDelete ?? '',
        "EDIT_DATA": columnsValueMap,
        "BUTTON_LIST": buttonsList.value,
        // "PARENT_ROW": columnsValueParentMap,
        "PARENT_ROW": columnsValueMap,
        "PARENT_TABLE": metaTableName,
      },
    );
  }

  void checkEditDataButtonVisibility(Map<String, dynamic> editData) {
    for (var key in editData.keys) {
      /// button validation
      buttonValidation(key, editData[key].toString());
    }
  }

  void clearTypedData() {
    List<String> visibleColumns = allColumnsList
        .where((element) => element.mdcVisible != 'Y')
        .map((e) => e.mdcColName)
        .toList();
    for (int i = 0; i < visibleColumns.length; ++i) {
      if (textEditingControllerMap.keys.contains(visibleColumns[i])) {
        textEditingControllerMap[visibleColumns[i]]?.value =
            const TextEditingValue(text: '');
      }
      if (columnsValueMap.keys.contains(visibleColumns[i])) {
        columnsValueMap[visibleColumns[i]] = '';
      }
    }
  }
}
