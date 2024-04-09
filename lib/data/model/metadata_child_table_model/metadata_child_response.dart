class MetadataChildResponse {
  int childTableId;
  String childTableName;

  MetadataChildResponse({
    required this.childTableId,
    required this.childTableName,
  });

  factory MetadataChildResponse.fromJson(dynamic json) => MetadataChildResponse(
    childTableId: json['MDCT_CHLD_TBLID'].toInt(),
    childTableName: json['MDCT_CHLD_TBLNAME'],
  );

  Map<String, dynamic> toJson() => {
    'MDCT_CHLD_TBLID': childTableId,
    'MDCT_CHLD_TBLNAME': childTableName,
  };
}
