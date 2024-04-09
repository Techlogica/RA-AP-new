import 'dart:convert';
import 'package:hive/hive.dart';
part 'metadata_columns_response.g.dart';

@HiveType(typeId: 1, adapterName: "MetadataColumnsResponseAdapter")
class MetadataColumnsResponse extends HiveObject {
  @HiveField(1)
  int? mdcSysId;
  @HiveField(2)
  int? mdcMdtSysId;
  @HiveField(3)
  String mdcColName;
  @HiveField(4)
  String? mdcDatatype;
  @HiveField(5)
  String? mdcKeyinfo;
  @HiveField(6)
  String mdcMetatitle;
  @HiveField(7, defaultValue: 0)
  int mdcSeqnum;
  @HiveField(8)
  String? mdcComboqry;
  @HiveField(9)
  String? mdcCombowhere;
  @HiveField(10)
  String? mdcValuefieldname;
  @HiveField(11)
  String? mdcTextfieldname;
  @HiveField(12)
  num? mdcColSpanmd;
  @HiveField(13)
  num? mdcColSpanlg;
  @HiveField(14)
  String? mdcDefaultvalue;
  @HiveField(15)
  int? mdcColLength;
  @HiveField(16)
  String mdcMtgGrpname;
  @HiveField(17)
  String? mdcUnbound;
  @HiveField(18)
  String? mdcVisible;
  @HiveField(19)
  DateTime? mdcCrtDate;
  @HiveField(20)
  String? mdcCrtUserid;
  @HiveField(21)
  DateTime? mdcUpdDate;
  @HiveField(22)
  String? mdcUpdUserid;
  @HiveField(23)
  int? mdcRowVersion;
  @HiveField(24)
  String? mdcReadonly;
  @HiveField(25)
  String? mdcGridVisible;
  @HiveField(26)
  String? mdcSort;
  @HiveField(27)
  String? mdcDispFormat;
  @HiveField(28)
  String? mdcShowincoloumn;
  @HiveField(29)
  int? mdcSummaryType;
  @HiveField(30)
  String? mdcSummaryFormat;
  @HiveField(31)
  String? mdcEncrypt;
  @HiveField(32)
  int? mdcGrpPosition;
  @HiveField(33)
  String? mdcHint;
  @HiveField(34)
  String? mdcReportparam;
  @HiveField(35)
  String? mdcHtml;
  @HiveField(36)
  String? mdcHtmlCond;
  @HiveField(37)
  String? mdcIssearchDeflt;
  @HiveField(38)
  String? mdcShwinColchosr;
  @HiveField(39)
  String? mdcPkAutoinc;
  @HiveField(40)
  String? mdcPlaceholdr;
  @HiveField(41)
  String? mdcPrwTempVisble;
  @HiveField(42)
  String? mdcEncbtnVisble;
  @HiveField(43)
  String? mdcReturn;

  MetadataColumnsResponse({
    this.mdcSysId,
    this.mdcMdtSysId,
    required this.mdcColName,
    this.mdcDatatype,
    this.mdcKeyinfo,
    required this.mdcMetatitle,
    required this.mdcSeqnum,
    this.mdcComboqry,
    this.mdcCombowhere,
    this.mdcValuefieldname,
    this.mdcTextfieldname,
    this.mdcColSpanmd,
    this.mdcColSpanlg,
    this.mdcDefaultvalue,
    this.mdcColLength,
    required this.mdcMtgGrpname,
    this.mdcUnbound,
    this.mdcVisible,
    this.mdcCrtDate,
    this.mdcCrtUserid,
    this.mdcUpdDate,
    this.mdcUpdUserid,
    this.mdcRowVersion,
    this.mdcReadonly,
    this.mdcGridVisible,
    this.mdcSort,
    this.mdcDispFormat,
    this.mdcShowincoloumn,
    this.mdcSummaryType,
    this.mdcSummaryFormat,
    this.mdcEncrypt,
    this.mdcGrpPosition,
    this.mdcHint,
    this.mdcReportparam,
    this.mdcHtml,
    this.mdcHtmlCond,
    this.mdcIssearchDeflt,
    this.mdcShwinColchosr,
    this.mdcPkAutoinc,
    this.mdcPlaceholdr,
    this.mdcPrwTempVisble,
    this.mdcEncbtnVisble,
    this.mdcReturn,
  });

  factory MetadataColumnsResponse.fromRawJson(String str) =>
      MetadataColumnsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetadataColumnsResponse.fromJson(dynamic json) =>
      MetadataColumnsResponse(
        mdcSysId: json["MDC_SYS_ID"].toInt(),
        mdcMdtSysId: json["MDC_MDT_SYS_ID"].toInt(),
        mdcColName: json["MDC_COL_NAME"] ?? '',
        mdcDatatype: json["MDC_DATATYPE"] ?? '',
        mdcKeyinfo: json["MDC_KEYINFO"] ?? '',
        mdcMetatitle: json["MDC_METATITLE"] ?? '',
        mdcSeqnum: json["MDC_SEQNUM"] == null ? 100 : json["MDC_SEQNUM"].toInt(),
        mdcComboqry: json["MDC_COMBOQRY"] ?? '',
        mdcCombowhere: json["MDC_COMBOWHERE"] ?? '',
        mdcValuefieldname: json["MDC_VALUEFIELDNAME"] ?? '',
        mdcTextfieldname: json["MDC_TEXTFIELDNAME"] ?? '',
        mdcColSpanmd: json["MDC_COL_SPANMD"],
        mdcColSpanlg: json["MDC_COL_SPANLG"],
        mdcDefaultvalue: json["MDC_DEFAULTVALUE"] ?? '',
        mdcColLength: json["MDC_COL_LENGTH"]?.toInt(),
        mdcMtgGrpname: json["MDC_MTG_GRPNAME"] ?? '',
        mdcUnbound: json["MDC_UNBOUND"] ?? '',
        mdcVisible: json["MDC_VISIBLE"] ?? '',
        mdcCrtDate: json["MDC_CRT_DATE"] == null ? null : DateTime.parse(json["MDC_CRT_DATE"]),
        mdcCrtUserid: json["MDC_CRT_USERID"] ?? '',
        mdcUpdDate: json["MDC_UPD_DATE"] == null ? null : DateTime.parse(json["MDC_UPD_DATE"]),
        mdcUpdUserid: json["MDC_UPD_USERID"] ?? '',
        mdcRowVersion: json["MDC_ROW_VERSION"]?.toInt(),
        mdcReadonly: json["MDC_READONLY"] ?? '',
        mdcGridVisible: json["MDC_GRID_VISIBLE"] ?? '',
        mdcSort: json["MDC_SORT"] ?? '',
        mdcDispFormat: json["MDC_DISP_FORMAT"] ?? '',
        mdcShowincoloumn: json["MDC_SHOWINCOLOUMN"] ?? '',
        mdcSummaryType: json["MDC_SUMMARY_TYPE"]?.toInt(),
        mdcSummaryFormat: json["MDC_SUMMARY_FORMAT"] ?? '',
        mdcEncrypt: json["MDC_ENCRYPT"] ?? '',
        mdcGrpPosition: json["MDC_GRP_POSITION"]?.toInt(),
        mdcHint: json["MDC_HINT"] ?? '',
        mdcReportparam: json["MDC_REPORTPARAM"] ?? '',
        mdcHtml: json["MDC_HTML"] ?? '',
        mdcHtmlCond: json["MDC_HTML_COND"] ?? '',
        mdcIssearchDeflt: json["MDC_ISSEARCH_DEFLT"] ?? '',
        mdcShwinColchosr: json["MDC_SHWIN_COLCHOSR"] ?? '',
        mdcPkAutoinc: json["MDC_PK_AUTOINC"] ?? '',
        mdcPlaceholdr: json["MDC_PLACEHOLDR"] ?? '',
        mdcPrwTempVisble: json["MDC_PRW_TEMP_VISBLE"] ?? '',
        mdcEncbtnVisble: json["MDC_ENCBTN_VISBLE"] ?? '',
        mdcReturn: json["MDC_RETURN"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "MDC_SYS_ID": mdcSysId,
        "MDC_MDT_SYS_ID": mdcMdtSysId,
        "MDC_COL_NAME": mdcColName,
        "MDC_DATATYPE": mdcDatatype,
        "MDC_KEYINFO": mdcKeyinfo,
        "MDC_METATITLE": mdcMetatitle,
        "MDC_SEQNUM": mdcSeqnum,
        "MDC_COMBOQRY": mdcComboqry,
        "MDC_COMBOWHERE": mdcCombowhere,
        "MDC_VALUEFIELDNAME": mdcValuefieldname,
        "MDC_TEXTFIELDNAME": mdcTextfieldname,
        "MDC_COL_SPANMD": mdcColSpanmd,
        "MDC_COL_SPANLG": mdcColSpanlg,
        "MDC_DEFAULTVALUE": mdcDefaultvalue,
        "MDC_COL_LENGTH": mdcColLength,
        "MDC_MTG_GRPNAME": mdcMtgGrpname,
        "MDC_UNBOUND": mdcUnbound,
        "MDC_VISIBLE": mdcVisible,
        "MDC_CRT_DATE": mdcCrtDate,
        "MDC_CRT_USERID": mdcCrtUserid,
        "MDC_UPD_DATE": mdcUpdDate,
        "MDC_UPD_USERID": mdcUpdUserid,
        "MDC_ROW_VERSION": mdcRowVersion,
        "MDC_READONLY": mdcReadonly,
        "MDC_GRID_VISIBLE": mdcGridVisible,
        "MDC_SORT": mdcSort,
        "MDC_DISP_FORMAT": mdcDispFormat,
        "MDC_SHOWINCOLOUMN": mdcShowincoloumn,
        "MDC_SUMMARY_TYPE": mdcSummaryType,
        "MDC_SUMMARY_FORMAT": mdcSummaryFormat,
        "MDC_ENCRYPT": mdcEncrypt,
        "MDC_GRP_POSITION": mdcGrpPosition,
        "MDC_HINT": mdcHint,
        "MDC_REPORTPARAM": mdcReportparam,
        "MDC_HTML": mdcHtml,
        "MDC_HTML_COND": mdcHtmlCond,
        "MDC_ISSEARCH_DEFLT": mdcIssearchDeflt,
        "MDC_SHWIN_COLCHOSR": mdcShwinColchosr,
        "MDC_PK_AUTOINC": mdcPkAutoinc,
        "MDC_PLACEHOLDR": mdcPlaceholdr,
        "MDC_PRW_TEMP_VISBLE": mdcPrwTempVisble,
        "MDC_ENCBTN_VISBLE": mdcEncbtnVisble,
        "MDC_RETURN": mdcReturn,
      };
}
