import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

part 'metadata_table_response.g.dart';

@HiveType(typeId: 0, adapterName: "MetadataTableResponseAdapter")
class MetadataTableResponse extends HiveObject {
  @HiveField(1)
  int mdtSysId;
  @HiveField(2)
  int? mdtMdpSysId;
  @HiveField(3)
  String? mdtTblName;
  @HiveField(4)
  String? mdtTblTitle;
  @HiveField(5)
  String? mdtTblIschild;
  @HiveField(6)
  String? mdtTblChild;
  @HiveField(7)
  String? mdtChildwhere;
  @HiveField(8)
  String? mdtDefaultwhere;
  @HiveField(9)
  DateTime? mdtCrtDate;
  @HiveField(10)
  String? mdtCrtUserid;
  @HiveField(11)
  DateTime? mdtUpdDate;
  @HiveField(12)
  String? mdtUpdUserid;
  @HiveField(13)
  int? mdtRowVersion;
  @HiveField(14)
  String? mdtCache;
  @HiveField(15)
  String? mdtChildviewtype;
  @HiveField(16, defaultValue: 0)
  int mdtSeqno;
  @HiveField(17)
  int? mdtTblChildid;
  @HiveField(18)
  String? mdtType;
  @HiveField(19)
  String? mdtIcon;
  @HiveField(20)
  int? mdtMenuPrntid;
  @HiveField(21)
  String? mdtChildIsbtn;
  @HiveField(22)
  String? mdtApprvlReqd;
  @HiveField(23)
  String? mdtIsmenuchld;
  @HiveField(24)
  String? mdtMenuTitle;
  @HiveField(25)
  int userId;
  @HiveField(26)
  String? mdtInsert;
  @HiveField(27)
  String? mdtUpdate;
  @HiveField(28)
  String? mdtDelete;

  MetadataTableResponse({
    required this.mdtSysId,
    this.mdtMdpSysId,
    this.mdtTblName,
    this.mdtTblTitle,
    this.mdtTblIschild,
    this.mdtTblChild,
    this.mdtChildwhere,
    this.mdtDefaultwhere,
    this.mdtCrtDate,
    this.mdtCrtUserid,
    this.mdtUpdDate,
    this.mdtUpdUserid,
    this.mdtRowVersion,
    this.mdtCache,
    this.mdtChildviewtype,
    required this.mdtSeqno,
    this.mdtTblChildid,
    this.mdtType,
    this.mdtIcon,
    this.mdtMenuPrntid,
    this.mdtChildIsbtn,
    this.mdtApprvlReqd,
    this.mdtIsmenuchld,
    this.mdtMenuTitle,
    required this.userId,
    this.mdtInsert,
    this.mdtUpdate,
    this.mdtDelete,
  });

  factory MetadataTableResponse.fromRawJson(String str) =>
      MetadataTableResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetadataTableResponse.fromJson(dynamic json) => MetadataTableResponse(
        mdtSysId: json["MDT_SYS_ID"].toInt(),
        mdtMdpSysId: json["MDT_MDP_SYS_ID"].toInt(),
        mdtTblName: json["MDT_TBL_NAME"] ?? '',
        mdtTblTitle: json["MDT_TBL_TITLE"] ?? '',
        mdtTblIschild: json["MDT_TBL_ISCHILD"] ?? '',
        mdtTblChild: json["MDT_TBL_CHILD"] ?? '',
        mdtChildwhere: json["MDT_CHILDWHERE"] ?? '',
        mdtDefaultwhere: json["MDT_DEFAULTWHERE"] ?? '',
        mdtCrtDate: json["MDT_CRT_DATE"] == null
            ? null
            : DateTime.parse(json["MDT_CRT_DATE"]),
        mdtCrtUserid: json["MDT_CRT_USERID"] ?? '',
        mdtUpdDate: json["MDT_UPD_DATE"] == null
            ? null
            : DateTime.parse(json["MDT_UPD_DATE"]),
        mdtUpdUserid: json["MDT_UPD_USERID"] ?? '',
        mdtRowVersion: json["MDT_ROW_VERSION"]?.toInt(),
        mdtCache: json["MDT_CACHE"] ?? '',
        mdtChildviewtype: json["MDT_CHILDVIEWTYPE"] ?? '',
        mdtSeqno: json["MDT_SEQNO"] == null ? 100 : json["MDT_SEQNO"].toInt(),
        mdtTblChildid: json["MDT_TBL_CHILDID"]?.toInt(),
        mdtType: json["MDT_TYPE"] ?? '',
        mdtIcon: json["MDT_ICON"] ?? '',
        mdtMenuPrntid: json["MDT_MENU_PRNTID"]?.toInt(),
        mdtChildIsbtn: json["MDT_CHILD_ISBTN"] ?? '',
        mdtApprvlReqd: json["MDT_APPRVL_REQD"] ?? '',
        mdtIsmenuchld: json["MDT_ISMENUCHLD"] ?? '',
        mdtMenuTitle: json["MDT_MENU_TITLE"] ?? '',
        userId: json["USERID"] == null ? 0 : json["USERID"].toInt(),
        mdtInsert: json["MDT_INSERT"] ?? 'N',
        mdtUpdate: json["MDT_UPDATE"] ?? 'N',
        mdtDelete: json["MDT_DELETE"] ?? 'N',
      );

  Map<String, dynamic> toJson() => {
        "MDT_SYS_ID": mdtSysId,
        "MDT_MDP_SYS_ID": mdtMdpSysId,
        "MDT_TBL_NAME": mdtTblName,
        "MDT_TBL_TITLE": mdtTblTitle,
        "MDT_TBL_ISCHILD": mdtTblIschild,
        "MDT_TBL_CHILD": mdtTblChild,
        "MDT_CHILDWHERE": mdtChildwhere,
        "MDT_DEFAULTWHERE": mdtDefaultwhere,
        "MDT_CRT_DATE": mdtCrtDate,
        "MDT_CRT_USERID": mdtCrtUserid,
        "MDT_UPD_DATE": mdtUpdDate,
        "MDT_UPD_USERID": mdtUpdUserid,
        "MDT_ROW_VERSION": mdtRowVersion,
        "MDT_CACHE": mdtCache,
        "MDT_CHILDVIEWTYPE": mdtChildviewtype,
        "MDT_SEQNO": mdtSeqno,
        "MDT_TBL_CHILDID": mdtTblChildid,
        "MDT_TYPE": mdtType,
        "MDT_ICON": mdtIcon,
        "MDT_MENU_PRNTID": mdtMenuPrntid,
        "MDT_CHILD_ISBTN": mdtChildIsbtn,
        "MDT_APPRVL_REQD": mdtApprvlReqd,
        "MDT_ISMENUCHLD": mdtIsmenuchld,
        "MDT_MENU_TITLE": mdtMenuTitle,
        "USERID": userId,
        "MDT_INSERT": mdtInsert,
        "MDT_UPDATE": mdtUpdate,
        "MDT_DELETE": mdtDelete,
      };
}
