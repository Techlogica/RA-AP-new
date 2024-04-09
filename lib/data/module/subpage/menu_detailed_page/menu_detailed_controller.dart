import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rapid_app/data/database/database_operations.dart';
import 'package:rapid_app/data/model/combo_box_model/lookup_response.dart';
import 'package:rapid_app/data/model/metadata_actions_model/metadata_actions_response.dart';
import 'package:rapid_app/data/model/metadata_columns_model/metadata_columns_response.dart';
import 'package:rapid_app/data/model/metadata_command_model/metadata_command_response.dart';
import 'package:rapid_app/data/model/tag_box_model/tagbox_response.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page/list_menu_detailed_data_grid_source.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/combo_concatenate.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/default_concatenator.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';
import 'package:rapid_app/res/values/logs/logs.dart';
import 'package:rapid_app/res/values/strings.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MenuDetailedController extends RapidController {
  /// search controller
  final TextEditingController controllerCommonSearch = TextEditingController();

  /// excel and pdf export convert key
  final GlobalKey<SfDataGridState> keyExport = GlobalKey<SfDataGridState>();

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late ListMenuDetailedDataGridSource menuDataGridSource;

  /// edit alert box data controller
  final RxList<TextEditingController> requiredFieldController = RxList();

  /// navigation argument
  dynamic get argumentData => Get.arguments;
  late String menuName,
      menuDefaultWhere,
      keyInfo = '',
      selectedSysId,
      mode,
      menuTitle,
      sortColumn = '';
  final RxString scannedResult = ''.obs;

  late int sysId;
  Map<String, dynamic> editData = {}; // parent table data
  Map<String, dynamic> parentRowData = {}; // parent table data
  List<MetadataCommandResponse> parentButtonList = []; // parent table data

  List<MetadataColumnsResponse> gridTableTitles = [];
  RxList<MetadataColumnsResponse> metadataColumnsTable =
      RxList<MetadataColumnsResponse>([]);
  RxList<MetadataColumnsResponse> selectedMenuColumns =
      RxList<MetadataColumnsResponse>([]);
  RxList<dynamic> menuData = RxList<dynamic>([]);

  int pageNumberMenuData = 10;
  int singleQueryDataLength = 0;

  bool isChildTable = false;
  RxBool gridDataLoader = true.obs;

  @override
  onInit() {
    super.onInit();
    menuTitle = argumentData['MENU_TITLE'];
    menuName = argumentData['MENU_NAME'];
    menuDefaultWhere = argumentData['MDT_DEFAULT_WHERE'];
    sysId = argumentData['MDT_SYS_ID'];
    if (argumentData['BUTTON_LIST'] != null) {
      parentButtonList = argumentData['BUTTON_LIST'];
    }
    if (argumentData['EDIT_DATA'] != null) {
      editData = argumentData['EDIT_DATA'];
    }
    if (argumentData['PARENT_ROW'] != null) {
      parentRowData = argumentData['PARENT_ROW'];
    }
    if (editData.isNotEmpty) {
      isChildTable = true;
    } else {
      gridDataLoader.value = false;
    }
    fetchSelectedMenuMetadataColumns(
      sysId,
    );
    getActionButtons();
  }

  void fetchSelectedMenuMetadataColumns(int sysId) async {
    final isMetadataColumnEmpty = await DatabaseOperations()
        .isTableEmpty(Strings.kMetadataColumns + sysId.toString());
    if (isMetadataColumnEmpty) {
      await fetchMetadataColumnsFromApi(sysId);
    } else {
      await fetchMetadataColumnsFromLocalDb(sysId);
    }
  }

  Future<void> fetchMetadataColumnsFromApi(int tableSysId) async {
    // Getting meta data frm the API
    final metadataColumnsTableResponse = await apiClient.rapidRepo
        .getMetadataColumns(sysId: tableSysId.toString());
    if (metadataColumnsTableResponse.status) {
      _saveMetadataColumnsTableToDb(
          metadataColumnsTableResponse.data, tableSysId);
      fetchMetadataColumnsFromLocalDb(tableSysId);
    }
  }

  void _saveMetadataColumnsTableToDb(dynamic columnsData, int tableSysId) {
    for (int i = 0; i < columnsData.length; ++i) {
      String res = json.encode(columnsData[i]);
      final jsonDecode = json.decode(res);
      MetadataColumnsResponse data =
          MetadataColumnsResponse.fromJson(jsonDecode);
      metadataColumnsTable.add(data);
    }
    addMetadataColumnsTable(tableSysId);
  }

  addMetadataColumnsTable(int tableSysId) async {
    //open database
    Box box = await dbAccess.openDatabase();
    // add value to table
    box.put(Strings.kMetadataColumns + tableSysId.toString(),
        metadataColumnsTable.toList());
  }

  Future<void> fetchMetadataColumnsFromLocalDb(int sysId) async {
    //open database
    Box box = await dbAccess.openDatabase();
    // read metadata columns table value
    gridTableTitles.clear();
    gridTableTitles = box
        .get(Strings.kMetadataColumns + sysId.toString())
        .toList()
        .cast<MetadataColumnsResponse>();

    gridTableTitles =
        gridTableTitles.where((element) => element.mdcUnbound != 'Y').toList();

    if (gridTableTitles.isNotEmpty) {
      /// fetch keyInfo value
      List<MetadataColumnsResponse> keyInfoList = gridTableTitles
          .where((element) => element.mdcKeyinfo == 'PK')
          .toList();
      keyInfo = keyInfoList[0].mdcColName;
      metadataColumnsTable.value = gridTableTitles;

      try {
        sortColumn = gridTableTitles
            .where((element) => element.mdcSort == 'Y')
            .map((e) => e.mdcColName)
            .first
            .toString();
      } catch (e) {
        sortColumn = keyInfo;
      }

      Logs.logData("sort.col::", sortColumn);

      /// sort columns
      fetchColumnsFromLocalDb(sysId: sysId);
    }
  }

  Future fetchColumnsFromLocalDb({
    int? sysId,
  }) async {
    /// sort data
    metadataColumnsTable.sort((a, b) => a.mdcSeqnum.compareTo(b.mdcSeqnum));

    /// check where condition
    List<MetadataColumnsResponse> menuColumns = metadataColumnsTable
        .where((element) =>
            element.mdcMdtSysId == sysId &&
            (element.mdcPrwTempVisble?.compareTo('Y') == 0 ||
                element.mdcGridVisible?.compareTo('Y') == 0))
        .toList();

    if (menuColumns.isEmpty) {
      menuColumns = metadataColumnsTable
          .where((element) =>
              element.mdcMdtSysId == sysId &&
              element.mdcGridVisible?.compareTo('Y') == 0)
          .toList();
    }
    selectedMenuColumns.value = menuColumns;

    /// sort list data
    selectedMenuColumns.sort((a, b) => a.mdcSeqnum.compareTo(b.mdcSeqnum));

    /// load data if the table is child
    if (isChildTable) {
      loadMenuData();
    }
  }

  Future<String> getLookup({
    required String fieldName,
    required String query,
    String? where,
    required String valueFieldValue,
    dynamic row,
  }) async {
    String convertedWhere = '';
    if (convertedWhere != '') {
      convertedWhere =
          await comboConcatenate(fformula: where!, obj: row, ptbName: menuName);
    }

    final response = await apiClient.rapidRepo
        .getLookupData(query: query, where: convertedWhere);

    String textFieldValue = '';
    if (response.status) {
      List<dynamic> dataResponse = response.data;
      List<LookupResponse> lookupData = [];
      for (int i = 0; i < dataResponse.length; ++i) {
        dynamic encodeData = json.encode(dataResponse[i]);
        final decode = json.decode(encodeData);
        LookupResponse response = LookupResponse.fromJson(decode);
        lookupData.add(response);
      }

      /// remove double .0
      String tempVal = valueFieldValue;
      if (valueFieldValue.contains('.0')) {
        tempVal = tempVal.substring(0, tempVal.length - 2);
      } else {
        tempVal = '$tempVal.0';
      }

      try {
        textFieldValue = lookupData
            .where((element) =>
                element.valueField == valueFieldValue ||
                element.valueField == tempVal)
            .first
            .textField;
      } catch (e) {
        textFieldValue = '';
      }
    } else {
      textFieldValue = valueFieldValue;
    }
    return textFieldValue;
  }

  Future<String> getTagbox({
    required String fieldName,
    required String query,
    String? where,
    String? textField,
    String? valueField,
    required String valueFieldValue,
    dynamic row,
  }) async {
    /// convert where condition
    String convertedWhere = '';
    if (convertedWhere != '') {
      convertedWhere =
          await comboConcatenate(fformula: where!, obj: row, ptbName: menuName);
    }

    /// conver query
    String replaceQueryData =
        ' SELECT $valueField MTV_VALUEFLD,$textField MTV_TEXTFLD FROM ';
    final result = query.split('FROM');
    String convertQuery = replaceQueryData + result[1];

    /// call API
    final response = await apiClient.rapidRepo
        .getLookupData(query: convertQuery, where: convertedWhere);
    String textFieldValue = '';
    if (response.status) {
      List<dynamic> dataResponse = response.data;
      List<TagboxResponse> tagboxData = [];
      for (int i = 0; i < dataResponse.length; ++i) {
        dynamic encodeData = json.encode(dataResponse[i]);
        final decode = json.decode(encodeData);
        TagboxResponse response = TagboxResponse.fromJson(decode);
        tagboxData.add(response);
      }

      /// remove double .0
      String tempVal = valueFieldValue;
      if (valueFieldValue.contains('.0')) {
        tempVal = tempVal.substring(0, tempVal.length - 2);
      } else {
        tempVal = '$tempVal.0';
      }

      try {
        textFieldValue = tagboxData
            .where((element) {
              String valueField = element.valueField.toString();
              return valueField == valueFieldValue || valueField == tempVal;
            })
            .first
            .textField;

        // textFieldValue = tagboxData
        //     .where((element) =>
        //         element.valueField.toString() == valueFieldValue ||
        //         element.valueField == tempVal)
        //     .first
        //     .textField;
      } catch (e) {
        textFieldValue = '';
      }
    } else {
      textFieldValue = valueFieldValue;
    }
    return textFieldValue;
  }

  /// fetch all data (common search with empty search word)
  Future<void> fetchSelectedMenuColumnValues(
      {required String tableName,
      required String defaultCondition,
      required int page,
      required String keyInfo}) async {
    String defaultValue = '';
    if (editData.isEmpty) {
      defaultValue = await defaultConcatenation(
          formula: defaultCondition, prtTbName: menuName);

      if (defaultValue.contains('.0')) {
        var splitVal = defaultValue.split(".0'");
        defaultValue = "${splitVal[0]}' ${splitVal[1].toString()}";
      }
    } else {
      //where condition
      var childWhereStr = defaultCondition;
      if (childWhereStr.contains(':[')) {
        for (var key in editData.keys) {
          String temp = ':[$key]';
          if (defaultCondition.contains(temp)) {
            defaultCondition =
                defaultCondition.replaceAll(temp, "'${editData[key]}'");
          }
        }
        if (defaultCondition.contains('#')) {
          defaultCondition = defaultCondition.split('#').last;
        }
        defaultValue = defaultCondition;
      } else {
        var childWhereSplit = childWhereStr.split(':');
        String condition = childWhereSplit[0].trim();
        String whereValue = editData[childWhereSplit[1]].toString();

        if (whereValue.contains('.0')) {
          var splitVal = whereValue.split(".0'");
          whereValue = "${splitVal[0]}' ${splitVal[0].toString()}";
        }
        defaultValue = "$condition '$whereValue'";
      }
    }

    /// Getting meta data frm the API
    final menuDataResponse = await apiClient.rapidRepo.getMenuColumnValues(
      tableName: tableName,
      defaultCondition: defaultValue,
      pageNo: page,
      keyInfo: keyInfo,
    );
    if (menuDataResponse.status) {
      gridDataLoader.value = true;
      List<dynamic> menuColumnData = menuDataResponse.data;
      singleQueryDataLength = menuColumnData.length;

      /// replace values
      menuData.addAll(menuColumnData);

      /// sort values
      menuData.sort((a, b) => a.sortColumn.compareTo(b.sortColumn));
      gridDataLoader.value = false;

      /// increment pagination number
      pageNumberMenuData += 50;
    } else {
      gridDataLoader.value = false;
    }
  }

  Future<void> selectedColumnPopup(
      String columnTitle, String columnValue) async {
    String colmName = selectedMenuColumns
        .firstWhere((p0) => p0.mdcMetatitle == columnTitle)
        .mdcColName
        .toString();

    List<MetadataColumnsResponse> selectedRow =
        selectedMenuColumns.where((p0) => p0.mdcColName == colmName).toList();

    String colmDataType = selectedMenuColumns
        .firstWhere((p0) => p0.mdcColName == colmName)
        .mdcDatatype
        .toString();

    String? colmComboQry = selectedMenuColumns
        .firstWhere((p0) => p0.mdcColName == colmName)
        .mdcComboqry
        .toString();

    String? colmComboWhere = selectedMenuColumns
        .firstWhere((p0) => p0.mdcColName == colmName)
        .mdcCombowhere
        .toString();

    if (colmDataType == 'LOOKUP' ||
        colmDataType == 'TAGBOX' ||
        colmDataType == 'SFTAGBOX') {
      if (columnValue.isNotEmpty || columnValue != 'null') {
        String columnValu = await lookupTagboxRowReplace(
          dataType: colmDataType,
          columnName: colmName,
          columnValue: columnValue,
          row: selectedRow,
          comboWhere: colmComboWhere,
          comboQry: colmComboQry,
        );
        bottomSnackBar(columnTitle: columnTitle, val: columnValu);
      } else {
        bottomSnackBar(columnTitle: columnTitle, val: columnValue);
      }
    } else {
      bottomSnackBar(columnTitle: columnTitle, val: columnValue);
    }
  }

  bottomSnackBar({required String columnTitle, String? val}) {
    Get.showSnackbar(
      GetSnackBar(
        title: '$columnTitle :',
        message: '$val \n',
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 8),
      ),
    );
  }

  Future<String> lookupTagboxRowReplace({
    required String columnName,
    required String dataType,
    required String columnValue,
    String? comboQry,
    String? comboWhere,
    required List<MetadataColumnsResponse> row,
  }) async {
    String textFieldValue = '';
    if (dataType == 'LOOKUP') {
      /// call lookup value replace query
      textFieldValue = await getLookup(
        fieldName: columnName,
        query: comboQry!,
        where: comboWhere,
        row: row,
        valueFieldValue: columnValue,
      );
    } else if (dataType == 'TAGBOX' || dataType == 'SFTAGBOX') {
      String? colmValueField = selectedMenuColumns
          .firstWhere((p0) => p0.mdcColName == columnName)
          .mdcValuefieldname
          .toString();

      String? colmTextField = selectedMenuColumns
          .firstWhere((p0) => p0.mdcColName == columnName)
          .mdcTextfieldname
          .toString();

      /// call tagbox value replace query
      textFieldValue = await getTagbox(
        fieldName: columnName,
        query: comboQry!,
        where: comboWhere,
        row: row,
        valueField: colmValueField,
        textField: colmTextField,
        valueFieldValue: columnValue,
      );
    }
    return textFieldValue;
  }

  // Future lookupTagboxReplace(List<dynamic> menuColumnData) async {
  //   // if (isChildTable) {
  //   for (int i = 0; i < menuColumnData.length; ++i) {
  //     List<dynamic> singleMenuColumnData = [];
  //     singleMenuColumnData.add(menuColumnData[i]);
  //
  //     for (int j = 0; j < metadataColumnsTable.length; ++j) {
  //       /// fetch column value
  //       String columnValue = singleMenuColumnData[0]
  //               [metadataColumnsTable[j].mdcColName]
  //           .toString()
  //           .trim();
  //
  //       /// check column value is not null
  //       if (columnValue.isNotEmpty || columnValue != 'null') {
  //         if (metadataColumnsTable[j].mdcDatatype == 'LOOKUP') {
  //           /// call lookup value replace query
  //           String textFieldValue = await getLookup(
  //             fieldName: metadataColumnsTable[j].mdcColName,
  //             query: metadataColumnsTable[j].mdcComboqry!,
  //             where: metadataColumnsTable[j].mdcCombowhere,
  //             row: metadataColumnsTable[j],
  //             valueFieldValue: columnValue,
  //           );
  //
  //           /// replace tagbox textfield value
  //           singleMenuColumnData[0][metadataColumnsTable[j].mdcColName] =
  //               textFieldValue;
  //         } else if (metadataColumnsTable[j].mdcDatatype == 'TAGBOX' ||
  //             metadataColumnsTable[j].mdcDatatype == 'SFTAGBOX') {
  //           /// call tagbox value replace query
  //           String textFieldValue = await getTagbox(
  //             fieldName: metadataColumnsTable[j].mdcColName,
  //             query: metadataColumnsTable[j].mdcComboqry!,
  //             where: metadataColumnsTable[j].mdcCombowhere,
  //             row: metadataColumnsTable[j],
  //             valueField: metadataColumnsTable[j].mdcValuefieldname!,
  //             textField: metadataColumnsTable[j].mdcTextfieldname!,
  //             valueFieldValue: columnValue,
  //           );
  //
  //           /// replace tagbox textfield value
  //           singleMenuColumnData[0][metadataColumnsTable[j].mdcColName] =
  //               textFieldValue;
  //         }
  //       }
  //     }
  //     menuData.addAll(singleMenuColumnData);
  //   }
  //   gridDataLoader.value = false;
  //   // }
  // }

  Future<List<dynamic>> lookupTagboxSingleRowReplace(
      List<dynamic> menuColumnData) async {
    for (int j = 0; j < metadataColumnsTable.length; ++j) {
      /// fetch column value
      String columnValue = menuColumnData[0][metadataColumnsTable[j].mdcColName]
          .toString()
          .trim();

      /// check column value is not null
      if (columnValue.isNotEmpty || columnValue != 'null') {
        if (metadataColumnsTable[j].mdcDatatype == 'LOOKUP') {
          /// call lookup value replace query
          String textFieldValue = await getLookup(
            fieldName: metadataColumnsTable[j].mdcColName,
            query: metadataColumnsTable[j].mdcComboqry!,
            where: metadataColumnsTable[j].mdcCombowhere,
            row: metadataColumnsTable[j],
            valueFieldValue: columnValue,
          );

          /// replace tagbox textfield value
          menuColumnData[0][metadataColumnsTable[j].mdcColName] =
              textFieldValue;
        } else if (metadataColumnsTable[j].mdcDatatype == 'TAGBOX' ||
            metadataColumnsTable[j].mdcDatatype == 'SFTAGBOX') {
          /// call tagbox value replace query
          String textFieldValue = await getTagbox(
            fieldName: metadataColumnsTable[j].mdcColName,
            query: metadataColumnsTable[j].mdcComboqry!,
            where: metadataColumnsTable[j].mdcCombowhere,
            row: metadataColumnsTable[j],
            valueField: metadataColumnsTable[j].mdcValuefieldname!,
            textField: metadataColumnsTable[j].mdcTextfieldname!,
            valueFieldValue: columnValue,
          );

          /// replace tagbox textfield value
          menuColumnData[0][metadataColumnsTable[j].mdcColName] =
              textFieldValue;
        }
      }
    }
    gridDataLoader.value = false;
    return menuColumnData;
  }

  bool isNumeric(String str) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
  }

  /// common search
  Future<void> commonSearch({
    required String query,
    required dynamic param,
  }) async {
    debugPrint('called commonSearch function');

    /// Getting meta data frm the API
    final menuDataResponse = await apiClient.rapidRepo.getCommonSearch(
      query: query,
      param: param,
    );
    if (menuDataResponse.status) {
      List<dynamic> menuColumnData = menuDataResponse.data;
      singleQueryDataLength = menuColumnData.length;

      /// replace values
      menuData.addAll(menuColumnData);
      debugPrint('Menu Data in common search : ${menuData}');

      /// sort values
      menuData.sort((a, b) => a.sortColumn.compareTo(b.sortColumn));
      gridDataLoader.value = false;

      /// increment pagination number
      pageNumberMenuData += 50;
    }
  }

  Future<void> loadMenuData() async {
    debugPrint('scanned data issss: ${controllerCommonSearch.text}');
    if (singleQueryDataLength.isEqual(0) || singleQueryDataLength.isEqual(50)) {
      if (controllerCommonSearch.text.trim().isEmpty) {
        debugPrint('if is workinggggg');
        await fetchSelectedMenuColumnValues(
          tableName: menuName,
          defaultCondition: menuDefaultWhere,
          page: pageNumberMenuData,
          keyInfo: keyInfo,
        );
        debugPrint('if is working in loadMenuData');
      } else {
        generateParamQuery();
      }
    }
  }

  void generateParamQuery() async {
    debugPrint('called generateParamQuery');
    List<Map<String, dynamic>> paramsData = [];
    String params = '';
    for (int i = 0; i < gridTableTitles.length; ++i) {
      dynamic prms = {
        Strings.kName: gridTableTitles[i].mdcColName,
        Strings.kValue: '%${controllerCommonSearch.text}%',
      };
      paramsData.add(prms);
      String colm = gridTableTitles[i].mdcColName;
      params = '${params}UPPER ($colm) LIKE UPPER (:$colm) OR ';
    }
    // remove last 'OR'
    params = params.trim().substring(0, params.length - 3);
    // encode key-value param list
    dynamic param = json.encode(paramsData);
    int page = pageNumberMenuData - 10;
    String pageNo = page.toString();
    String query = '';
    if (menuDefaultWhere.isEmpty) {
      query = 'WITH S AS (SELECT * FROM $menuName) '
          'SELECT * FROM S WHERE $params ORDER BY $keyInfo DESC '
          'OFFSET $pageNo ROWS FETCH NEXT 50 ROWS ONLY';
      commonSearch(
        query: query,
        param: param,
      );
    } else {
      String whereCondition =
          await defaultConcatenation(formula: menuDefaultWhere);

      if (whereCondition.contains('.0')) {
        var splitVal = whereCondition.split(".0'");
        whereCondition = "${splitVal[0]}' ${splitVal[1].toString()}";
      }
      query = 'WITH S AS (SELECT * FROM $menuName WHERE $whereCondition ) '
          'SELECT * FROM S WHERE $params ORDER BY $keyInfo DESC '
          'OFFSET $pageNo ROWS FETCH NEXT 50 ROWS ONLY';
      commonSearch(
        query: query,
        param: param,
      );
    }
  }

  void removeGridRow({required int rowIndex, required String rowId}) {
    deleteDate(tableName: sysId.toString(), rowId: rowId, rowIndex: rowIndex);
  }

  Future<void> deleteDate(
      {required String rowId,
      required String tableName,
      required int rowIndex}) async {
    final response = await apiClient.rapidRepo.getDeleteData(
      tableName: tableName,
      sysId: rowId,
    );
    if (response.status) {
      menuData.removeAt(rowIndex);
      // refresh grid source
      menuDataGridSource.updateDataSource();
      menuData.refresh();
    }
  }

  addGridRow(DataGridRow dataGridRow, int i) {
    menuData.refresh();
  }

  void getActionButtons() async {
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
  }

  void fetchMetadataSingleData(
      dynamic sysId, String mode, List<dynamic> row) async {
    List<dynamic> listRes = row;
    if (mode == Strings.kParamNew) {
      // new
      if (menuData.isNotEmpty) {
        listRes.addAll(menuData);
        menuData.clear();
      }
      menuData.addAll(listRes);
    } else {
      // edit
      /// update row values
      Map<String, dynamic> responseList = listRes[0];

      /// pick old data list  index
      int index = menuData.indexWhere((element) => element[keyInfo] == sysId);

      /// pick old row
      Map<String, dynamic> menuDataList = menuData[index];

      /// replace new data
      for (var key in menuDataList.keys) {
        menuData[index][key] = responseList[key];
      }
      menuData.refresh();
    }
  }

  Future<void> clearGridData() async {
    menuData.clear();
  }
}
