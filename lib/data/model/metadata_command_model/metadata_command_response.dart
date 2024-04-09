import 'dart:convert';

import 'package:hive/hive.dart';
part 'metadata_command_response.g.dart';

@HiveType(typeId: 6,adapterName: "MetadataCommandResponseAdapter")
class MetadataCommandResponse extends HiveObject {
  @HiveField(1)
  int mdcdSysId;
  @HiveField(2)
  int mdcdMdtSysId;
  @HiveField(3)
  String mdcdText;
  @HiveField(4)
  String? mdcdRenderstyle;
  @HiveField(5)
  int mdcdSeqnum;
  @HiveField(6)
  String? mdcdType;
  @HiveField(7)
  String? mdcdAlt;
  @HiveField(8)
  String? mdcdShift;
  @HiveField(9)
  String? mdcdCtrl;
  @HiveField(10)
  String? mdcdCode;
  @HiveField(11)
  DateTime? mdcdCrtDate;
  @HiveField(12)
  String? mdcdCrtUserid;
  @HiveField(13)
  DateTime? mdcdUpdDate;
  @HiveField(14)
  String? mdcdUpdUserid;
  @HiveField(15)
  int? mdcdRowVersion;
  @HiveField(16)
  String? mdcdTitle;

  MetadataCommandResponse(
      {required this.mdcdSysId,
      required this.mdcdMdtSysId,
      required this.mdcdText,
      this.mdcdRenderstyle,
      required this.mdcdSeqnum,
      this.mdcdType,
      this.mdcdAlt,
      this.mdcdShift,
      this.mdcdCtrl,
      this.mdcdCode,
      this.mdcdCrtDate,
      this.mdcdCrtUserid,
      this.mdcdUpdDate,
      this.mdcdUpdUserid,
      this.mdcdRowVersion,
      this.mdcdTitle});

  factory MetadataCommandResponse.fromRawJson(String str) =>
      MetadataCommandResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetadataCommandResponse.fromJson(dynamic json) =>
      MetadataCommandResponse(
        mdcdSysId: json["MDCD_SYS_ID"].toInt(),
        mdcdMdtSysId: json["MDCD_MDT_SYS_ID"].toInt(),
        mdcdText: json["MDCD_TEXT"] ?? '',
        mdcdRenderstyle: json["MDCD_RENDERSTYLE"] ?? '',
        mdcdSeqnum:
            json["MDCD_SEQNUM"] == null ? 100 : json["MDCD_SEQNUM"].toInt(),
        mdcdType: json["MDCD_TYPE"] ?? '',
        mdcdAlt: json["MDCD_ALT"] ?? '',
        mdcdShift: json["MDCD_SHIFT"] ?? '',
        mdcdCtrl: json["MDCD_CTRL"] ?? '',
        mdcdCode: json["MDCD_CODE"] ?? '',
        mdcdCrtDate: json["MDCD_CRT_DATE"] == null
            ? null
            : DateTime.parse(json["MDCD_CRT_DATE"]),
        mdcdCrtUserid: json["MDCD_CRT_USERID"] ?? '',
        mdcdUpdDate: json["MDCD_UPD_DATE"] == null
            ? null
            : DateTime.parse(json["MDCD_UPD_DATE"]),
        mdcdUpdUserid: json["MDCD_UPD_USERID"] ?? '',
        mdcdRowVersion: json["MDCD_ROW_VERSION"]?.toInt(),
        mdcdTitle: json["MDCD_TITLE"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "MDCD_SYS_ID": mdcdSysId,
        "MDCD_MDT_SYS_ID": mdcdMdtSysId,
        "MDCD_TEXT": mdcdText,
        "MDCD_RENDERSTYLE": mdcdRenderstyle,
        "MDCD_SEQNUM": mdcdSeqnum,
        "MDCD_TYPE": mdcdType,
        "MDCD_ALT": mdcdAlt,
        "MDCD_SHIFT": mdcdShift,
        "MDCD_CTRL": mdcdCtrl,
        "MDCD_CODE": mdcdCode,
        "MDCD_CRT_DATE": mdcdCrtDate,
        "MDCD_CRT_USERID": mdcdCrtUserid,
        "MDCD_UPD_DATE": mdcdUpdDate,
        "MDCD_UPD_USERID": mdcdUpdUserid,
        "MDCD_ROW_VERSION": mdcdRowVersion,
        "MDCD_TITLE": mdcdTitle,
      };
}
