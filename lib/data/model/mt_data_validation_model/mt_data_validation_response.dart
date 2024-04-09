class MtDataValidationResponse {
  int mtdvSysId;
  String mtdvFieldname;
  String? mtdvReadonly;
  String? mtdvDefaultValue;
  int? mtdvValColumnid;
  String? mtdvFieldData;
  String? mtdvEditType;
  int? mtdvValBtnid;
  int? mtdvCommandid;
  String? mtdvVisible;
  int? mdtvHtmlcolId;
  String? mdtvTextorcombo;
  String? mdtvTrueVal;
  String? mdtvFalseVal;
  String? mtdvCond;
  String? mtdvCondval;
  String? mtdvValDatatyp;
  String mtdvValcolName;
  String? mtdvChdBtntyp;
  int? mtdvChldtblId;

  MtDataValidationResponse({
    required this.mtdvSysId,
    required this.mtdvFieldname,
    this.mtdvReadonly,
    this.mtdvDefaultValue,
    this.mtdvValColumnid,
    this.mtdvFieldData,
    required this.mtdvEditType,
    this.mtdvValBtnid,
    this.mtdvCommandid,
    this.mtdvVisible,
    this.mdtvHtmlcolId,
    this.mdtvTextorcombo,
    this.mdtvTrueVal,
    this.mdtvFalseVal,
    this.mtdvCond,
    this.mtdvCondval,
    this.mtdvValDatatyp,
    required this.mtdvValcolName,
    this.mtdvChdBtntyp,
    this.mtdvChldtblId,
  });

  factory MtDataValidationResponse.fromJson(dynamic json) =>
      MtDataValidationResponse(
        mtdvSysId: json["MTDV_SYS_ID"].toInt(),
        mtdvFieldname: json["MTDV_FIELDNAME"] ?? '',
        mtdvReadonly: json["MTDV_READONLY"] ?? '',
        mtdvDefaultValue: json["MTDV_DEFAULT_VALUE"] ?? '',
        mtdvValColumnid: json["MTDV_VAL_COLUMNID"]?.toInt(),
        mtdvFieldData: json["MTDV_FIELD_DATA"] ?? '',
        mtdvEditType: json["MTDV_EDIT_TYPE"] ?? '',
        mtdvValBtnid: json["MTDV_VAL_BTNID"]?.toInt(),
        mtdvCommandid: json["MTDV_COMMANDID"]?.toInt(),
        mtdvVisible: json["MTDV_VISIBLE"] ?? '',
        mdtvHtmlcolId: json["MDTV_HTMLCOL_ID"]?.toInt(),
        mdtvTextorcombo: json["MDTV_TEXTORCOMBO"] ?? '',
        mdtvTrueVal: json["MDTV_TRUE_VAL"] ?? '',
        mdtvFalseVal: json["MDTV_FALSE_VAL"] ?? '',
        mtdvCond: json["MTDV_COND"] ?? '',
        mtdvCondval: json["MTDV_CONDVAL"] ?? '',
        mtdvValDatatyp: json["MTDV_VAL_DATATYP"] ?? '',
        mtdvValcolName: json["MTDV_VALCOL_NAME"] ?? '',
        mtdvChdBtntyp: json["MTDV_CHD_BTNTYP"] ?? '',
        mtdvChldtblId: json["MTDV_CHLDTBL_ID"]?.toInt(),
      );

  Map<String, dynamic> toJson() => {
        "MTDV_SYS_ID": mtdvSysId,
        "MTDV_FIELDNAME": mtdvFieldname,
        "MTDV_READONLY": mtdvReadonly,
        "MTDV_DEFAULT_VALUE": mtdvDefaultValue,
        "MTDV_VAL_COLUMNID": mtdvValColumnid,
        "MTDV_FIELD_DATA": mtdvFieldData,
        "MTDV_EDIT_TYPE": mtdvEditType,
        "MTDV_VAL_BTNID": mtdvValBtnid,
        "MTDV_COMMANDID": mtdvCommandid,
        "MTDV_VISIBLE": mtdvVisible,
        "MDTV_HTMLCOL_ID": mdtvHtmlcolId,
        "MDTV_TEXTORCOMBO": mdtvTextorcombo,
        "MDTV_TRUE_VAL": mdtvTrueVal,
        "MDTV_FALSE_VAL": mdtvFalseVal,
        "MTDV_COND": mtdvCond,
        "MTDV_CONDVAL": mtdvCondval,
        "MTDV_VAL_DATATYP": mtdvValDatatyp,
        "MTDV_VALCOL_NAME": mtdvValcolName,
        "MTDV_CHD_BTNTYP": mtdvChdBtntyp,
        "MTDV_CHLDTBL_ID": mtdvChldtblId,
      };
}
