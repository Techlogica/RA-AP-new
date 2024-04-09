import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/model/metadata_columns_model/metadata_columns_response.dart';
import 'package:rapid_app/data/model/tag_box_model/tag_box_column_response.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/combo_concatenate.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/default_concatenator.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';
import 'package:rapid_app/res/values/logs/logs.dart';
import 'package:rapid_app/res/values/strings.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TagBoxTableGridController extends RapidController {
  dynamic arguments = Get.arguments;
  RxList<TagBoxColumnResponse> childRowData = RxList([]);
  RxList<dynamic> childColumnData = RxList([]);
  TextEditingController searchController = TextEditingController();
  String dataType = '';
  String title = '';
  final DataGridController dataGridController = DataGridController();
  int pageNumberMenuData = 10;
  int singleQueryDataLength = 0;
  late MetadataColumnsResponse metadataColumnsResponse;
  RxString valueField = ''.obs;
  RxString textField = ''.obs;
  RxMap<String, dynamic> tapBoxMap = RxMap({});
  Map<String, dynamic> editData = {};
  Map<String, dynamic> lookUpRowDataName = {};
  // RxMap<String, List<LookupResponse>> itemsList = RxMap({});
  late String menuName;

  @override
  void onInit() {
    super.onInit();
    metadataColumnsResponse = arguments['column'];
    debugPrint("***********metadata${jsonEncode(metadataColumnsResponse)}");
    // lookUpRowDataName=arguments['colName'];
    editData = arguments['rowData'];
    menuName = arguments['menuName'];
    textField.value = arguments['editValue'] ?? '';
    // itemsList = arguments['lookupList']??'';
    getTagBoxFieldName(
        mdcSysId: metadataColumnsResponse.mdcSysId!,
        mdcDatatype: metadataColumnsResponse.mdcDatatype);
    getTagBox(
        mdcSysId: metadataColumnsResponse.mdcSysId!,
        fieldName: metadataColumnsResponse.mdcColName,
        query: metadataColumnsResponse.mdcComboqry!,
        pageNo: pageNumberMenuData,
        where: metadataColumnsResponse.mdcCombowhere);
  }

  Future<void> getTagBox({
    required int mdcSysId,
    required String fieldName,
    required String query,
    required int pageNo,
    String? where,
  }) async {
    String convertedWhere = await comboConcatenate(
        fformula: where!, obj: editData, ptbName: menuName);
    final response = await apiClient.rapidRepo
        .getTagBoxData(query: query, where: convertedWhere, pageNo: pageNo);
    debugPrint("........calling$convertedWhere");
    debugPrint("........editdata$editData");
    debugPrint("........fieldName$fieldName");
    debugPrint("........query$query........where$where");
    debugPrint("........menu$menuName");
    debugPrint(".................response:${jsonEncode(response)}");
    if (response.status) {
      List<dynamic> dataResponse = response.data;
      if (dataResponse.isNotEmpty) {
        singleQueryDataLength = dataResponse.length;
        if (searchController.text.isNotEmpty) {
          filterTagBoxList(searchText: searchController.text);
        } else {
          childColumnData.addAll(dataResponse);
          debugPrint(
              "..........childcolumndata:${jsonEncode(childColumnData)}");
          debugPrint("..........dataresponse:${jsonEncode(dataResponse)}");
        }
        pageNumberMenuData += 50;
        Logs.logData('length---', childColumnData.length.toString());
      }
    }
  }

  Future<void> getTagBoxFieldName({required int mdcSysId, String? mdcDatatype}) async {
    List<TagBoxColumnResponse> tagBoxColumnValueList = [];
    print('...............datatype$mdcDatatype');
    debugPrint(".....................gettagboxfield $tagBoxColumnValueList");
    if (mdcDatatype == 'TAGBOX'||mdcDatatype == 'SFTAGBOX') {
      final response = await apiClient.rapidRepo.getTagBoxColumn(where: mdcSysId);
      debugPrint(".....................response${jsonEncode(response)}");
      if (response.status) {
        List<dynamic> dataResponse = response.data;
        debugPrint(".....................ifloop $dataResponse");
        for (int i = 0; i < dataResponse.length; i++) {
          final encode = jsonEncode(dataResponse[i]);
          final decode = jsonDecode(encode);
          TagBoxColumnResponse columnResponse =
          TagBoxColumnResponse.fromJson(decode);
          tagBoxColumnValueList.add(columnResponse);
        }
        tagBoxColumnValueList.sort((a, b) => a.seqNo.compareTo(b.seqNo));
        childRowData.addAll(tagBoxColumnValueList);
        debugPrint(".....................childrowdata:${jsonEncode(childRowData)}");
      }
    } else if (mdcDatatype == 'LOOKUP') {
      print("....................mdcDatatype$mdcDatatype");
      tagBoxColumnValueList.add(TagBoxColumnResponse(
        valueField: 'code',
        seqNo: 1,
        dataType: 'STRING',
        columnName: 'MTV_VALUEFLD',
        bindFields: '',
        bindValues: '',
      ));
      tagBoxColumnValueList.add(TagBoxColumnResponse(
        valueField: 'Name',
        seqNo: 1,
        dataType: 'STRING',
        columnName: 'MTV_TEXTFLD',
        bindFields: '',
        bindValues: '',
      ));
      childRowData.addAll(tagBoxColumnValueList);
      debugPrint(".....................childrowdataelse:${jsonEncode(childRowData)}");
    }
  }

  // Future<void> getTagBoxFieldName({required int mdcSysId}) async {
  //   List<TagBoxColumnResponse> tagBoxColumnValueList = [];
  //   debugPrint(".....................gettagboxfield");
  //   final response = await apiClient.rapidRepo.getTagBoxColumn(where: mdcSysId);
  //   debugPrint(".....................response${jsonEncode(response)}");
  //   if (response.status) {
  //     debugPrint(".....................ifloop");
  //     List<dynamic> dataResponse = response.data;
  //     for (int i = 0; i < dataResponse.length; i++) {
  //       final encode = jsonEncode(dataResponse[i]);
  //       final decode = jsonDecode(encode);
  //       TagBoxColumnResponse columnResponse = TagBoxColumnResponse.fromJson(decode);
  //       tagBoxColumnValueList.add(columnResponse);
  //       debugPrint("......................tagboxcolumnlist${jsonEncode(tagBoxColumnValueList)}");
  //     }
  //     tagBoxColumnValueList.sort((a, b) => a.seqNo.compareTo(b.seqNo));
  //     childRowData.addAll(tagBoxColumnValueList);
  //     debugPrint(".....................childrowdata:${jsonEncode(childRowData)}");
  //   }
  // }

  Future<void> filterTagBoxList({required String searchText}) async {
    List<Map<String, dynamic>> paramsData = [];
    String params = '';
    for (int i = 0; i < childRowData.length; i++) {
      dynamic prms = {
        Strings.kName: childRowData[i].columnName,
        Strings.kValue: '%$searchText%'
      };
      paramsData.add(prms);
      String colm = childRowData[i].columnName;
      params = params + 'UPPER ($colm) LIKE UPPER (:$colm) OR ';
    }

    params = params.trim().substring(0, params.length - 3);
    dynamic param = json.encode(paramsData);
    int page = pageNumberMenuData - 10;
    String pageNo = page.toString();
    String query = '';
    if (metadataColumnsResponse.mdcCombowhere!.isEmpty) {
      query = 'WITH S AS (${metadataColumnsResponse.mdcComboqry}) '
          'SELECT * FROM S WHERE $params'
          'OFFSET $pageNo ROWS FETCH NEXT 50 ROWS ONLY';
      commonSearch(query: query, param: param);
    } else {
      String whereCondition = await defaultConcatenation(
          formula: metadataColumnsResponse.mdcCombowhere!);
      query =
          'WITH S AS (${metadataColumnsResponse.mdcComboqry} WHERE $whereCondition ) '
          'SELECT * FROM S WHERE $params'
          'OFFSET $pageNo ROWS FETCH NEXT 50 ROWS ONLY';
      commonSearch(query: query, param: param);
    }
  }

  Future<void> commonSearch({
    required String query,
    required dynamic param,
  }) async {
    final tagBoxDataResponse =
        await apiClient.rapidRepo.getCommonSearch(query: query, param: param);
    if (tagBoxDataResponse.status) {
      List<dynamic> dataResponse = tagBoxDataResponse.data;
      singleQueryDataLength = dataResponse.length;
      childColumnData.clear();
      childColumnData.addAll(dataResponse);
      Logs.logData('length---', childColumnData.length.toString());
      pageNumberMenuData += 50;
    }
  }

  Future<void> loadChildData() async {
    if (singleQueryDataLength.isEqual(0) || singleQueryDataLength.isEqual(50)) {
      if (searchController.text.trim().isEmpty) {
        getTagBox(
            pageNo: pageNumberMenuData,
            mdcSysId: metadataColumnsResponse.mdcSysId!,
            fieldName: metadataColumnsResponse.mdcColName,
            query: metadataColumnsResponse.mdcComboqry!,
            where: metadataColumnsResponse.mdcCombowhere);
      } else {
        filterTagBoxList(searchText: searchController.text);
      }
    }
  }
}
