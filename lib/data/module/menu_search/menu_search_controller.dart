import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rapid_app/data/model/base/base_response.dart';
import 'package:rapid_app/data/model/metadata_table_model/metadata_table_response.dart';
import 'package:rapid_app/data/module/dashboard/dashboard_controller.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/default_concatenator.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/logs/logs.dart';
import 'package:rapid_app/res/values/strings.dart';
import 'package:darq/darq.dart';

class MenuSearchController extends RapidController {
  RxList<MetadataTableResponse> metadataTable =
      RxList<MetadataTableResponse>([]);
  RxList<MetadataTableResponse> firstPageData =
      RxList<MetadataTableResponse>([]);
  final TextEditingController controllerSearch = TextEditingController();
  RxList<MenuBarModel> menuTitleBarList = RxList<MenuBarModel>([]);
  Rx<bool> isIndicatorVisibility = true.obs;
  Rx<int> crossAxisCount = 2.obs;
  num? userId;

  @override
  void onInit() {
    super.onInit();
    userId = RapidPref().getLoginUserId();
    MenuBarModel rep = MenuBarModel(sysId: -1, title: 'Home');
    menuTitleBarList.add(rep);
    fetchMetaData();
  }

  searchMenus(String searchWord) async {
    // if (userId.toString().contains('.0')) {
    //   String value = userId.toString().split('.').first;
    //   userId = num.parse(value);
    // }
    int projectId = int.parse(RapidPref().getProjectId().toString());
    Logs.logData("userid::", userId.toString());
    List<MetadataTableResponse> searchResponse = metadataTable
        .where((element) =>
            element.userId == userId &&
            element.mdtMdpSysId == projectId &&
            element.mdtTblTitle
                .toString()
                .toUpperCase()
                .contains(searchWord.toUpperCase()))
        .toList();
    firstPageData.clear();
    for (int i = 0; i < searchResponse.length; ++i) {
      searchResponse[i].mdtTblTitle = await defaultConcatenation(
          formula: searchResponse[i].mdtTblTitle.toString());
    }
    firstPageData.value = searchResponse;
  }

  Future fetchMetaDataFromLocalDb() async {
    //open database
    Box box = await dbAccess.openDatabase();
    // read metadata table values
    List<MetadataTableResponse> metadataTableData =
        box.get(Strings.kMetadataTable).toList().cast<MetadataTableResponse>();
    if (metadataTableData.isNotEmpty) {
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
            element.mdtMenuPrntid == sysId && element.mdtMdpSysId == projectId)
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
    double width = MediaQuery.of(Get.context!).size.width;
    if (width <= 400) {
      crossAxisCount.value = 2;
    } else {
      crossAxisCount.value = 4;
    }
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
    String tablePermission = RapidPref().getMdpTblPermission().toString();
    String fieldUserId = RapidPref().getMdpPermissionFldUsrid().toString();
    String tableId = RapidPref().getMdpPermissionTblId().toString();
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
    //open database
    Box box = await dbAccess.openDatabase();
    // add value to table
    box.put(Strings.kMetadataTable, metadataTable.toList());
  }
}
