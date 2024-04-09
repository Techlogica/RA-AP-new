import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rapid_app/data/model/cache_menus_model/cache_menu_response.dart';
import 'package:rapid_app/data/model/metadata_table_model/metadata_table_response.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/default_concatenator.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:darq/darq.dart';
import 'package:rapid_app/res/values/logs/logs.dart';
import 'package:rapid_app/res/values/strings.dart';

class SettingsController extends RapidController {
  List<MetadataTableResponse> metadataTable = [];
  RxList<CacheMenuResponse> localMenuList = RxList<CacheMenuResponse>([]);

  @override
  void onInit() {
    super.onInit();
    fetchMetadataTable();
  }

  Future<void> fetchMetadataTable() async {
    List<MetadataTableResponse> tables = [];
    String query = "SELECT * FROM METADATA_TABLES WHERE "
        "MDT_TBL_ISCHILD != 'Y' AND MDT_TBL_NAME != ' '";
    final response = await apiClient.rapidRepo.getChartGraph(query: query);
    if (response.status) {
      dynamic responseData = response.data;
      for (int i = 0; i < responseData.length; ++i) {
        String res = json.encode(responseData[i]);
        final jsonDecode = json.decode(res);
        MetadataTableResponse data = MetadataTableResponse.fromJson(jsonDecode);
        tables.add(data);
      }
      metadataTable.addAll(tables);
    }
    if (tables.isNotEmpty) {
      int projectId = int.parse(RapidPref().getProjectId().toString());
      List<MetadataTableResponse> tableFilter = tables
          .where((element) => element.mdtMdpSysId == projectId)
          .distinct()
          .toSet()
          .toList();
      tables.clear();
      tables.addAll(tableFilter);
    }
    fetchLocalCacheMenu(tables);
  }

  void fetchLocalCacheMenu(List<MetadataTableResponse> metadataTable) async {
    final isCacheMenuEmpty =
        await dbAccess.isTableEmpty(Strings.kCacheMenuList);
    if (isCacheMenuEmpty) {
      /// table is empty
      List<CacheMenuResponse> list = [];
      for (int i = 0; i < metadataTable.length; ++i) {
        CacheMenuResponse data = CacheMenuResponse.fromJson(
            metadataTable[i].mdtSysId,
            metadataTable[i].mdtTblTitle!,
            '',
            'N',
            'N');
        list.add(data);
      }
      localMenuList.value = list;
    } else {
      /// else case
      /// fetch data from local
      List<CacheMenuResponse> localTables = [];
      Box box = await dbAccess.openDatabase();
      localTables =
          box.get(Strings.kCacheMenuList).toList().cast<CacheMenuResponse>();

      /// fetch sysId columns only
      List<int> localTableSysIds = localTables.map((e) => e.sysId).toList();

      List<CacheMenuResponse> list = [];
      for (int i = 0; i < metadataTable.length; ++i) {
        if (localTableSysIds.contains(metadataTable[i].mdtSysId)) {
          int index = localTables.indexWhere(
              (element) => element.sysId == metadataTable[i].mdtSysId);
          if (index != -1) {
            list.add(localTables[index]);
          }
        } else {
          CacheMenuResponse data = CacheMenuResponse.fromJson(
              metadataTable[i].mdtSysId,
              metadataTable[i].mdtTblTitle!,
              '',
              'N',
              'N');
          list.add(data);
        }
      }
      localMenuList.value = list;
    }
  }

  setCacheCheckboxValue(String cacheFlag) {
    bool value = cacheFlag == "Y" ? true : false;
    return value;
  }

  cacheCheckboxOnChange(int index, bool value) {
    Logs.logData("value::", value.toString());
    if (value) {
      localMenuList[index].cacheFlag = 'Y';
    } else {
      localMenuList[index].cacheFlag = 'N';
    }
    Logs.logData("change value::", localMenuList[index].cacheFlag);
  }

  setOfflineOnlineSwitchValue(String offlineFlag) {
    bool value = offlineFlag == "Y" ? false : true;
    return value;
  }

  offlineOnlineSwitchOnChange(int index, bool value) {
    Logs.logData("value::", value.toString());
    if (value) {
      localMenuList[index].offlineFlag = "Y";
    } else {
      localMenuList[index].offlineFlag = "N";
    }
    Logs.logData("change value::", localMenuList[index].offlineFlag.toString());
  }

  onTapSave() async {
    /**
     * local menu list - modified -
     * filter cache-Y data -
     * for loop - fetch each data -
     * run data query and fetch data -
     * update localMenuList  - update data
     * clear and replace hive table
     *
     **/
    List<CacheMenuResponse> isCacheMenus =
        localMenuList.where((p0) => p0.cacheFlag == 'Y').toList();
    for (int i = 0; i < isCacheMenus.length; ++i) {
      List<MetadataTableResponse> singleMenu = metadataTable
          .where((element) => element.mdtSysId == isCacheMenus[i].sysId)
          .toList();

      dynamic result = await fetchSelectedMenuColumnValues(
        tableName: singleMenu[0].mdtTblName!,
        defaultCondition: singleMenu[0].mdtDefaultwhere!,
      );


    }
  }

  /// fetch menu data
  Future<dynamic> fetchSelectedMenuColumnValues({
    required String tableName,
    required String defaultCondition,
  }) async {
    Map<String, dynamic> editData = {};
    String defaultValue = '';
    if (editData.isEmpty) {
      defaultValue = await defaultConcatenation(
          formula: defaultCondition, prtTbName: tableName);

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
          whereValue = "${splitVal[0]}' ${splitVal[1].toString()}";
        }
        defaultValue = "$condition '$whereValue'";
      }
    }

    /// Getting meta data from the API
    final menuDataResponse = await apiClient.rapidRepo.getMenuAllColumnValues(
      tableName: tableName,
      defaultCondition: defaultValue,
    );
    if (menuDataResponse.status) {
      return menuDataResponse.data;
    }
  }
}
