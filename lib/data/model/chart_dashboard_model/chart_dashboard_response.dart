import 'package:hive/hive.dart';

part 'chart_dashboard_response.g.dart';

@HiveType(typeId: 4, adapterName: 'ChartDashboardResponseAdapter')
class ChartDashboardResponse extends HiveObject {
  @HiveField(1)
  int mtdSysId;
  @HiveField(2)
  String? mtdText;
  @HiveField(3)
  String? mtdImage;
  @HiveField(4)
  String? mtdQuery;
  @HiveField(5)
  String? mtdBgColor;
  @HiveField(6)
  String? mtdDisplayFormat;
  @HiveField(7)
  int mtdSeqNo;
  @HiveField(8)
  String? mtdSubtext;
  @HiveField(9)
  String? mtdType;
  @HiveField(10)
  String? mtdFreeze;
  @HiveField(11)
  String? mtdWidth;
  @HiveField(12)
  String? mtdHeight;
  @HiveField(13)
  String? mtdColspammd;
  @HiveField(14)
  int? mtdMdpSysId;
  @HiveField(15)
  int? mtduSysId;
  @HiveField(16)
  int? mtduMtdDashId;
  @HiveField(17)
  int? mtduMtlUserId;
  @HiveField(18)
  int? mtduCgSysId;
  @HiveField(19)
  String? mtdLink;
  @HiveField(20)
  String? mtdQueryValue;
  @HiveField(21)
  int? mtdMdtSysId;

  ChartDashboardResponse({
    required this.mtdSysId,
    this.mtdText,
    this.mtdImage,
    this.mtdQuery,
    this.mtdBgColor,
    this.mtdDisplayFormat,
    required this.mtdSeqNo,
    this.mtdSubtext,
    this.mtdType,
    this.mtdFreeze,
    this.mtdWidth,
    this.mtdHeight,
    this.mtdColspammd,
    this.mtdMdpSysId,
    this.mtduSysId,
    this.mtduMtdDashId,
    this.mtduMtlUserId,
    this.mtduCgSysId,
    this.mtdLink,
    this.mtdQueryValue,
    this.mtdMdtSysId,
  });

  factory ChartDashboardResponse.fromJson(dynamic json,String queryValue) =>
      ChartDashboardResponse(
        mtdSysId: json["MTD_SYS_ID"].toInt(),
        mtdText: json["MTD_TEXT"] ?? '',
        mtdImage: json["MTD_IMAGE"],
        mtdQuery: json["MTD_QUERY"] ?? '',
        mtdBgColor: json["MTD_BG_COLOR"],
        mtdDisplayFormat: json["MTD_DISPLAY_FORMAT"],
        mtdSeqNo: json["MTD_SEQ_NO"]?.toInt(),
        mtdSubtext: json["MTD_SUBTEXT"] ?? '',
        mtduSysId: json["MTDU_SYS_ID"]?.toInt(),
        mtduMtdDashId: json["MTDU_MTD_DASH_ID"]?.toInt(),
        mtduMtlUserId: json["MTDU_MTL_USER_ID"]?.toInt(),
        mtduCgSysId: json["MTDU_CG_SYS_ID"]?.toInt(),
        mtdType: json["MTD_TYPE"] ?? '',
        mtdFreeze: json["MTD_FREEZE"] ?? '',
        mtdWidth: json["MTD_WIDTH"],
        mtdHeight: json["MTD_HEIGHT"],
        mtdColspammd: json["MTD_COLSPAMMD"] ?? '',
        mtdMdpSysId: json["MTD_MDP_SYS_ID"]?.toInt(),
        mtdMdtSysId: json["MTD_MDT_SYS_ID"]?.toInt(),
        mtdLink: json["MTD_LINK"] ?? '',
        mtdQueryValue: queryValue,
      );

  Map<String, dynamic> toJson() => {
        "MTD_SYS_ID": mtdSysId,
        "MTD_TEXT": mtdText,
        "MTD_IMAGE": mtdImage,
        "MTD_QUERY": mtdQuery,
        "MTD_BG_COLOR": mtdBgColor,
        "MTD_DISPLAY_FORMAT": mtdDisplayFormat,
        "MTD_SEQ_NO": mtdSeqNo,
        "MTD_SUBTEXT": mtdSubtext,
        "MTDU_SYS_ID": mtduSysId,
        "MTDU_MTD_DASH_ID": mtduMtdDashId,
        "MTDU_MTL_USER_ID": mtduMtlUserId,
        "MTDU_CG_SYS_ID": mtduCgSysId,
        "MTD_TYPE": mtdType,
        "MTD_FREEZE": mtdFreeze,
        "MTD_WIDTH": mtdWidth,
        "MTD_HEIGHT": mtdHeight,
        "MTD_COLSPAMMD": mtdColspammd,
        "MTD_MDP_SYS_ID": mtdMdpSysId,
        "MTD_MDT_SYS_ID": mtdMdtSysId,
        "MTD_LINK": mtdLink,
        "MTD_QUERY_VALUE": mtdQueryValue,
      };
}
