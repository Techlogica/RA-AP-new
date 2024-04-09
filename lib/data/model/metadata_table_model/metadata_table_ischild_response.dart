class MetadataTableIsChild {
  int mdtSysId;
  String mdtTblTitle;
  String mdtTblName;
  String? mdtChildwhere;
  String mdtChildIsbtn;
  String? mdtInsert;
  String? mdtUpdate;
  String? mdtDelete;
  String? mdtChildRowCond;

  MetadataTableIsChild({
    required this.mdtSysId,
    required this.mdtTblTitle,
    required this.mdtTblName,
    this.mdtChildwhere,
    required this.mdtChildIsbtn,
    this.mdtInsert,
    this.mdtUpdate,
    this.mdtDelete,
    this.mdtChildRowCond,
  });

  factory MetadataTableIsChild.fromJson(dynamic json) => MetadataTableIsChild(
        mdtSysId: json['MDT_SYS_ID'].toInt(),
        mdtTblName: json['MDT_TBL_NAME'],
        mdtTblTitle: json['MDT_TBL_TITLE'],
        mdtChildwhere: json['MDT_CHILDWHERE'] ?? '',
        mdtChildIsbtn: json['MDT_CHILD_ISBTN'] ?? '',
        mdtInsert: json["MDT_INSERT"],
        mdtUpdate: json["MDT_UPDATE"],
        mdtDelete: json["MDT_DELETE"],
        mdtChildRowCond: json["MDT_CHILDROW_COND"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'MDT_SYS_ID': mdtSysId,
        'MDT_TBL_NAME': mdtTblName,
        'MDT_TBL_TITLE': mdtTblTitle,
        'MDT_CHILDWHERE': mdtChildwhere,
        'MDT_CHILD_ISBTN': mdtChildIsbtn,
        "MDT_INSERT": mdtInsert,
        "MDT_UPDATE": mdtUpdate,
        "MDT_DELETE": mdtDelete,
        "MDT_CHILDROW_COND": mdtChildRowCond,
      };
}
