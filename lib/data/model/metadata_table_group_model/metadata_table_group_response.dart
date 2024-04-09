import 'dart:convert';

class MetadataTableGroupResponse {
  int mtgSysId;
  int mtgMdtSysId;
  String mtgGrpname;
  String? mtgCrtDate;
  String? mtgCrtUserid;
  String? mtgUpdDate;
  String? mtgUpdUserid;
  int? mtgRowVersion;

  MetadataTableGroupResponse({
    required this.mtgSysId,
    required this.mtgMdtSysId,
    required this.mtgGrpname,
    this.mtgCrtDate,
    this.mtgCrtUserid,
    this.mtgUpdDate,
    this.mtgUpdUserid,
    this.mtgRowVersion,
  });

  factory MetadataTableGroupResponse.fromRawJson(String str) =>
      MetadataTableGroupResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetadataTableGroupResponse.fromJson(dynamic json) =>
      MetadataTableGroupResponse(
        mtgSysId: json["MTG_SYS_ID"].toInt(),
        mtgMdtSysId: json["MTG_MDT_SYS_ID"].toInt(),
        mtgGrpname: json["MTG_GRPNAME"] ?? '',
        mtgCrtDate: json["MTG_CRT_DATE"] ?? '',
        mtgCrtUserid: json["MTG_CRT_USERID"] ?? '',
        mtgUpdDate: json["MTG_UPD_DATE"] ?? '',
        mtgUpdUserid: json["MTG_UPD_USERID"] ?? '',
        mtgRowVersion: json["MTG_ROW_VERSION"] == null
            ? 1
            : json["MTG_ROW_VERSION"].toInt(),
      );

  Map<String, dynamic> toJson() => {
        "MTG_SYS_ID": mtgSysId,
        "MTG_MDT_SYS_ID": mtgMdtSysId,
        "MTG_GRPNAME": mtgGrpname,
        "MTG_CRT_DATE": mtgCrtDate,
        "MTG_CRT_USERID": mtgCrtUserid,
        "MTG_UPD_DATE": mtgUpdDate,
        "MTG_UPD_USERID": mtgUpdUserid,
        "MTG_ROW_VERSION": mtgRowVersion,
      };
}
