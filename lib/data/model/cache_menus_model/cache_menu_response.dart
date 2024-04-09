import 'package:hive/hive.dart';

part 'cache_menu_response.g.dart';

@HiveType(typeId: 8, adapterName: 'CacheMenuResponseAdapter')
class CacheMenuResponse extends HiveObject {
  @HiveField(1)
  int sysId;
  @HiveField(2)
  String tableName;
  @HiveField(3)
  dynamic tableData;
  @HiveField(4)
  String cacheFlag;
  @HiveField(5)
  String offlineFlag;

  CacheMenuResponse({
    required this.sysId,
    required this.tableName,
    required this.tableData,
    required this.cacheFlag,
    required this.offlineFlag,
  });

  factory CacheMenuResponse.fromJson(
    int sysId,
    String tableName,
    dynamic tableData,
    String cacheFlag,
    String offlineFlag,
  ) =>
      CacheMenuResponse(
        sysId: sysId,
        tableName: tableName,
        tableData: tableData,
        cacheFlag: cacheFlag,
        offlineFlag: offlineFlag,
      );

  Map<String, dynamic> toJson() => {
        "sys_id": sysId,
        "table_name": tableName,
        "table_data": tableData,
        "cache_flag": cacheFlag,
        "offline_flag": offlineFlag,
      };
}
