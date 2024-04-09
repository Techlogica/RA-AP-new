import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rapid_app/data/model/base/base_response.dart';
import 'package:rapid_app/data/model/metadata_command_model/metadata_command_response.dart';
import 'package:rapid_app/data/model/metadata_table_model/metadata_table_response.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/default_concatenator.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/strings.dart';
import 'package:darq/darq.dart';

class MenuBarModel {
  int? sysId;
  String? title;

  MenuBarModel({this.sysId, this.title});
}

class DashboardController extends RapidController {
  RxList<MetadataTableResponse> metadataTable =
      RxList<MetadataTableResponse>([]);
  RxList<MetadataTableResponse> firstPageData =
      RxList<MetadataTableResponse>([]);
  final TextEditingController controllerSearch = TextEditingController();
  RxList<MenuBarModel> menuTitleBarList = RxList<MenuBarModel>([]);
  Rx<bool> isIndicatorVisibility = true.obs;
  RxList<dynamic> menuData = RxList<dynamic>([]);

  Map<String, dynamic> editData = {}; // parent table data
  Map<String, dynamic> parentRowData = {}; // parent table data
  List<MetadataCommandResponse> parentButtonList = []; // parent table buttons

  @override
  void onInit() {
    super.onInit();
    MenuBarModel rep = MenuBarModel(sysId: -1, title: 'Home');
    menuTitleBarList.add(rep);
    fetchMetaData();
  }

  Future fetchMetaDataFromLocalDb() async {
    //open database
    Box box= await dbAccess.openDatabase();
    // read metadata table values

    List<MetadataTableResponse> metadataTableData =
        box.get(Strings.kMetadataTable).toList().cast<MetadataTableResponse>();
    if (metadataTableData.isNotEmpty) {
      num? userId = RapidPref().getLoginUserId();
      List<MetadataTableResponse> metadataTableDataFilter = metadataTableData
          .where((element) => element.userId == userId)
          .distinct()
          .toSet()
          .toList();
      if (metadataTableDataFilter.isEmpty) {
        dbAccess.clearTables();
        fetchMetadataFromApi();
      } else {
        metadataTable.clear();
        metadataTable.value = metadataTableDataFilter;
        fetchMenusFromLocalDb(sysId: 0);
      }
    } else {
      isIndicatorVisibility.value = false;
    }
  }

  Future fetchMenusFromLocalDb({
    int? sysId,
  }) async {
    int projectId = int.parse(RapidPref().getProjectId().toString());
    // check where condition
    List<MetadataTableResponse> firstPageResponse = metadataTable
        .where((element) =>
            element.mdtMenuPrntid == sysId &&
            element.mdtMdpSysId == projectId &&
            element.mdtTblIschild != 'Y')
        .distinct((d) => d.mdtSysId.toString())
        .toSet()
        .toList();

    firstPageData.clear();
    for (int i = 0; i < firstPageResponse.length; ++i) {
      firstPageResponse[i].mdtTblTitle = await defaultConcatenation(
          formula: firstPageResponse[i].mdtTblTitle.toString());
    }
    firstPageData.value = firstPageResponse;
    // sort list data
    firstPageData.sort((a, b) => a.mdtSeqno.compareTo(b.mdtSeqno));
  }

  void fetchMetaData() async {
    final isMetadataEmpty = await dbAccess.isTableEmpty(Strings.kMetadataTable);
    if (isMetadataEmpty) {
      await fetchMetadataFromApi();
    } else {
      fetchMetaDataFromLocalDb();
    }
  }

  Future<void> fetchMetadataFromApi() async {
    final permissionMenuResponse = await getPermissionMenuData();
    if (permissionMenuResponse.status) {
      _savePermissionMenuResponseToDb(permissionMenuResponse.data);
      fetchMetaDataFromLocalDb();
    } else {
      isIndicatorVisibility.value = false;
    }
  }

  Future<BaseResponse> getPermissionMenuData() async {
    String tableId = RapidPref().getMdpPermissionTblId().toString();
    String tablePermission = RapidPref().getMdpTblPermission().toString();
    String fieldUserId = RapidPref().getMdpPermissionFldUsrid().toString();
    String prefix = RapidPref().getMdpPermissionPrefix().toString();

    final result = await apiClient.rapidRepo.getPermissionMenuTable(
      metaDataTableIdColumn: tableId,
      permissionTableName: tablePermission,
      permissionTableIdColumn: fieldUserId,
      prefix: prefix,
    );
    return result;
  }

  void _savePermissionMenuResponseToDb(dynamic permissionData) {
    for (int i = 0; i < permissionData.length; ++i) {
      String res = json.encode(permissionData[i]);
      final jsonDecode = json.decode(res);
      MetadataTableResponse data = MetadataTableResponse.fromJson(jsonDecode);
      metadataTable.add(data);
    }
    addMetadataTable();
  }

  addMetadataTable() async {
    // open database
    Box box = await dbAccess.openDatabase();
    // add value to table
    box.put(Strings.kMetadataTable, metadataTable.toList());
  }
}
