import 'dart:convert';
import 'package:hive/hive.dart';

part 'chart_response.g.dart';

@HiveType(typeId: 5, adapterName: 'CharResponseAdapter')
class ChartResponse extends HiveObject {
  @HiveField(1)
  int cSysId;
  @HiveField(2)
  String? cChartName;
  @HiveField(3)
  int? cCgGroupId;
  @HiveField(4)
  int? cColspanmd;
  @HiveField(5)
  String? cLegendPosition;
  @HiveField(6)
  String cQueryString;
  @HiveField(7)
  String? cShowDetails;
  @HiveField(8)
  String? cGridString;
  @HiveField(9)
  String? cHtml;
  @HiveField(10)
  int? cSeqNo;
  @HiveField(11)
  int? cuSysId;
  @HiveField(12)
  int? cuMtlUsrid;
  @HiveField(13)
  int? cuCChartId;
  @HiveField(14)
  int? caSysId;
  @HiveField(15)
  String? caTitleText;
  @HiveField(16)
  String? caChartType;
  @HiveField(17)
  int? caCChartId;
  @HiveField(18)
  String? caName;
  @HiveField(19)
  String? caArgumentField;
  @HiveField(20)
  String? caValueField;
  @HiveField(21)
  String? caAgrtnMthd;
  @HiveField(22)
  String? caDynamicKey;
  @HiveField(23)
  String? caMAxes;
  @HiveField(24)
  int? caLabelFormat;
  @HiveField(25)
  String? caIsArgument;

  ChartResponse(
      {required this.cSysId,
      this.cChartName,
      this.cCgGroupId,
      this.cColspanmd,
      this.cLegendPosition,
      required this.cQueryString,
      this.cShowDetails,
      this.cGridString,
      this.cHtml,
      this.cSeqNo,
      this.cuSysId,
      this.cuMtlUsrid,
      this.cuCChartId,
      this.caSysId,
      this.caTitleText,
      this.caChartType,
      this.caCChartId,
       this.caName,
      this.caArgumentField,
      this.caValueField,
      this.caAgrtnMthd,
      this.caDynamicKey,
      this.caMAxes,
      this.caLabelFormat,
      this.caIsArgument});

  factory ChartResponse.fromRawJson(String str) =>
      ChartResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChartResponse.fromJson(Map<String, dynamic> json) => ChartResponse(
        cSysId: json["C_SYS_ID"].toInt(),
        cChartName: json["C_CHART_NAME"],
        cCgGroupId: json["C_CG_GROUP_ID"]?.toInt(),
        cColspanmd: json["C_COLSPANMD"]?.toInt(),
        cLegendPosition: json["C_LEGEND_POSITION"],
        cQueryString: json["C_QUERY_STRING"],
        cShowDetails: json["C_SHOW_DETAILS"],
        cGridString: json["C_GRID_STRING"],
        cHtml: json["C_HTML"],
        cSeqNo: json["C_SEQ_NO"]?.toInt(),
        cuSysId: json["CU_SYS_ID"]?.toInt(),
        cuMtlUsrid: json["CU_MTL_USRID"]?.toInt(),
        cuCChartId: json["CU_C_CHART_ID"]?.toInt(),
        caSysId: json["CA_SYS_ID"]?.toInt(),
        caTitleText: json["CA_TITLE_TEXT"],
        caChartType: json["CA_CHART_TYPE"],
        caCChartId: json["CA_C_CHART_ID"]?.toInt(),
        caName: json["CA_NAME"],
        caArgumentField: json["CA_ARGUMENT_FIELD"],
        caValueField: json["CA_VALUE_FIELD"],
        caAgrtnMthd: json["CA_AGRTN_MTHD"],
        caDynamicKey: json["CA_DYNAMIC_KEY"],
        caMAxes: json["CA_M_AXES"],
        caLabelFormat: json["CA_LABEL_FORMAT"]?.toInt(),
        caIsArgument: json["CA_IS_ARGUMENT"],
      );

  Map<String, dynamic> toJson() => {
        "C_SYS_ID": cSysId,
        "C_CHART_NAME": cChartName,
        "C_CG_GROUP_ID": cCgGroupId,
        "C_COLSPANMD": cColspanmd,
        "C_LEGEND_POSITION": cLegendPosition,
        "C_QUERY_STRING": cQueryString,
        "C_SHOW_DETAILS": cShowDetails,
        "C_GRID_STRING": cGridString,
        "C_HTML": cHtml,
        "C_SEQ_NO": cSeqNo,
        "CU_SYS_ID": cuSysId,
        "CU_MTL_USRID": cuMtlUsrid,
        "CU_C_CHART_ID": cuCChartId,
        "CA_SYS_ID": caSysId,
        "CA_TITLE_TEXT": caTitleText,
        "CA_CHART_TYPE": caChartType,
        "CA_C_CHART_ID": caCChartId,
        "CA_NAME": caName,
        "CA_ARGUMENT_FIELD": caArgumentField,
        "CA_VALUE_FIELD": caValueField,
        "CA_AGRTN_MTHD": caAgrtnMthd,
        "CA_DYNAMIC_KEY": caDynamicKey,
        "CA_M_AXES": caMAxes,
        "CA_LABEL_FORMAT": caLabelFormat,
        "CA_IS_ARGUMENT": caIsArgument,
      };
}
