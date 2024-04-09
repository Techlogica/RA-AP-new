import 'dart:convert';

import 'package:hive/hive.dart';
part 'metadata_actions_response.g.dart';

@HiveType(typeId: 7, adapterName: "MetadataActionResponseAdapter")
class MetadataActionResponse extends HiveObject {
  @HiveField(1)
  int mdaSysId;
  @HiveField(2)
  int mdaMdcdSysId;
  @HiveField(3)
  String? mdaAction;
  @HiveField(4)
  String? mdaArg1;
  @HiveField(5)
  String? mdaArg2;
  @HiveField(6)
  String? mdaArg3;
  @HiveField(7)
  int mdaSeqnum;
  @HiveField(8)
  String? mdaReturn;
  @HiveField(9)
  DateTime? mdaCrtDate;
  @HiveField(10)
  String? mdaCrtUserid;
  @HiveField(11)
  DateTime? mdaUpdDate;
  @HiveField(12)
  String? mdaUpdUserid;
  @HiveField(13)
  int? mdaRowVersion;
  @HiveField(14)
  int? mdaTrue;
  @HiveField(15)
  int? mdaFalse;
  @HiveField(16)
  String? mdaArg4;
  @HiveField(17)
  String? mdaArg5;

  MetadataActionResponse(
      {required this.mdaSysId,
      required this.mdaMdcdSysId,
      this.mdaAction,
      this.mdaArg1,
      this.mdaArg2,
      this.mdaArg3,
      required this.mdaSeqnum,
      this.mdaReturn,
      this.mdaCrtDate,
      this.mdaCrtUserid,
      this.mdaUpdDate,
      this.mdaUpdUserid,
      this.mdaRowVersion,
      this.mdaTrue,
      this.mdaFalse,
      this.mdaArg4,
      this.mdaArg5});

  factory MetadataActionResponse.fromRawJson(String str) =>
      MetadataActionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetadataActionResponse.fromJson(Map<String, dynamic> json) =>
      MetadataActionResponse(
        mdaSysId: json["MDA_SYS_ID"].toInt(),
        mdaMdcdSysId: json["MDA_MDCD_SYS_ID"].toInt(),
        mdaAction: json["MDA_ACTION"] ?? '',
        mdaArg1: json["MDA_ARG1"] ?? '',
        mdaArg2: json["MDA_ARG2"] ?? '',
        mdaArg3: json["MDA_ARG3"] ?? '',
        mdaSeqnum:
            json["MDA_SEQNUM"] == null ? 100 : json["MDA_SEQNUM"].toInt(),
        mdaReturn: json["MDA_RETURN"] ?? '',
        mdaCrtDate: json["MDA_CRT_DATE"] == null
            ? null
            : DateTime.parse(json["MDA_CRT_DATE"]),
        mdaCrtUserid: json["MDA_CRT_USERID"] ?? '',
        mdaUpdDate: json["MDA_UPD_DATE"] == null
            ? null
            : DateTime.parse(json["MDA_UPD_DATE"]),
        mdaUpdUserid: json["MDA_UPD_USERID"],
        mdaRowVersion: json["MDA_ROW_VERSION"],
        mdaTrue: json["MDA_TRUE"]?.toInt(),
        mdaFalse: json["MDA_FALSE"]?.toInt(),
        mdaArg4: json["MDA_ARG4"] ?? '',
        mdaArg5: json["MDA_ARG5"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "MDA_SYS_ID": mdaSysId,
        "MDA_MDCD_SYS_ID": mdaMdcdSysId,
        "MDA_ACTION": mdaAction,
        "MDA_ARG1": mdaArg1,
        "MDA_ARG2": mdaArg2,
        "MDA_ARG3": mdaArg3,
        "MDA_SEQNUM": mdaSeqnum,
        "MDA_RETURN": mdaReturn,
        "MDA_CRT_DATE": mdaCrtDate,
        "MDA_CRT_USERID": mdaCrtUserid,
        "MDA_UPD_DATE": mdaUpdDate,
        "MDA_UPD_USERID": mdaUpdUserid,
        "MDA_ROW_VERSION": mdaRowVersion,
        "MDA_TRUE": mdaTrue,
        "MDA_FALSE": mdaFalse,
        "MDA_ARG4": mdaArg4,
        "MDA_ARG5": mdaArg5,
      };
}
