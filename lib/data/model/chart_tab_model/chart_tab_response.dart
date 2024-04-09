import 'dart:convert';

import 'package:hive/hive.dart';
part 'chart_tab_response.g.dart';

@HiveType(typeId: 3,adapterName: 'ChartTabResponseAdapter')
class ChartTabResponse extends HiveObject {
  @HiveField(1)
  int cgSysId;
  @HiveField(2)
  String cgGrpName;

  ChartTabResponse({required this.cgSysId, required this.cgGrpName});

  factory ChartTabResponse.fromRawJson(String str) =>
      ChartTabResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChartTabResponse.fromJson(dynamic json) => ChartTabResponse(
        cgSysId: json["CG_SYS_ID"].toInt(),
        cgGrpName: json["CG_GRP_NAME"],
      );

  Map<String, dynamic> toJson() => {
        "CG_SYS_ID": cgSysId,
        "CG_GRP_NAME": cgGrpName,
      };
}
