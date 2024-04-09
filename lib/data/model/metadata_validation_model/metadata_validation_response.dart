class MetadataValidationResponse {
  int mdvSysId;
  int mdvMdcSysId;
  String mdvMdcColName;
  String mdvValType;
  String? mdvValMessage;
  int? mdvColLength;
  String? mdvValFlag;
  String? mdvCondition;
  String? mdvValQuery;
  DateTime? mdvCrtDate;
  String? mdvCrtUserid;
  DateTime? mdvUpdDate;
  String? mdvUpdUserid;
  int? mdvRowVersion;

  MetadataValidationResponse(
      {required this.mdvSysId,
      required this.mdvMdcSysId,
      required this.mdvMdcColName,
      required this.mdvValType,
      this.mdvValMessage,
      this.mdvColLength,
      this.mdvValFlag,
      this.mdvCondition,
      this.mdvValQuery,
      this.mdvCrtDate,
      this.mdvCrtUserid,
      this.mdvUpdDate,
      this.mdvUpdUserid,
      this.mdvRowVersion});

  factory MetadataValidationResponse.fromJson(dynamic json) =>
      MetadataValidationResponse(
        mdvSysId: json["MDV_SYS_ID"].toInt(),
        mdvMdcSysId: json["MDV_MDC_SYS_ID"].toInt(),
        mdvMdcColName: json["MDV_MDC_COL_NAME"] ?? '',
        mdvValType: json["MDV_VAL_TYPE"] ?? '',
        mdvValMessage: json["MDV_VAL_MESSAGE"] ?? '',
        mdvColLength: json["MDV_COL_LENGTH"]?.toInt(),
        mdvValFlag: json["MDV_VAL_FLAG"] ?? '',
        mdvCondition: json["MDV_CONDITION"] ?? '',
        mdvValQuery: json["MDV_VAL_QUERY"] ?? '',
        mdvCrtDate: json["MDV_CRT_DATE"] == null
            ? null
            : DateTime.parse(json["MDV_CRT_DATE"]),
        mdvCrtUserid: json["MDV_CRT_USERID"] ?? '',
        mdvUpdDate: json["MDV_UPD_DATE"] == null
            ? null
            : DateTime.parse(json["MDV_UPD_DATE"]),
        mdvUpdUserid: json["MDV_UPD_USERID"] ?? '',
        mdvRowVersion: json["MDV_ROW_VERSION"]?.toInt(),
      );

  Map<String, dynamic> toJson() => {
        "MDV_SYS_ID": mdvSysId,
        "MDV_MDC_SYS_ID": mdvMdcSysId,
        "MDV_MDC_COL_NAME": mdvMdcColName,
        "MDV_VAL_TYPE": mdvValType,
        "MDV_VAL_MESSAGE": mdvValMessage,
        "MDV_COL_LENGTH": mdvColLength,
        "MDV_VAL_FLAG": mdvValFlag,
        "MDV_CONDITION": mdvCondition,
        "MDV_VAL_QUERY": mdvValQuery,
        "MDV_CRT_DATE": mdvCrtDate,
        "MDV_CRT_USERID": mdvCrtUserid,
        "MDV_UPD_DATE": mdvUpdDate,
        "MDV_UPD_USERID": mdvUpdUserid,
        "MDV_ROW_VERSION": mdvRowVersion,
      };
}
