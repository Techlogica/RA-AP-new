import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rapid_app/data/model/base/base_response.dart';
import 'package:rapid_app/data/model/metadata_table_model/metadata_table_response.dart';
import 'package:rapid_app/data/service/auth_service/local_auth_service.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/strings.dart';

class HomeController extends RapidController {
  DateTime? currentBackPressTime;
  RxInt tabIndex = RxInt(0);
  RxList<MetadataTableResponse> metadataTable =
      RxList<MetadataTableResponse>([]);

  @override
  void onInit() {
    super.onInit();

    /// fetch metadata tables
    fetchMetaData();
  }

  void fetchMetaData() async {
    final isMetadataEmpty = await dbAccess.isTableEmpty(Strings.kMetadataTable);
    if (isMetadataEmpty) {
      await fetchMetadataFromApi();
    }
  }

  Future<void> fetchMetadataFromApi() async {
    final permissionMenuResponse = await getPermissionMenuData();
    if (permissionMenuResponse.status) {
      _savePermissionMenuResponseToDb(permissionMenuResponse.data);
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
