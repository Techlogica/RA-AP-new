class TagBoxColumnResponse {
  String valueField;
  int seqNo;
  String dataType;
  String columnName;
  String bindFields;
  String bindValues;

  TagBoxColumnResponse({
    required this.valueField,
    required this.seqNo,
    required this.dataType,
    required this.columnName,
    required this.bindFields,
    required this.bindValues,
  });

  factory TagBoxColumnResponse.fromJson(dynamic json) => TagBoxColumnResponse(
        valueField: json['MC_DISPLAY_COLUMNS'] ?? '',
        seqNo: json["MC_SEQ_NO"] == null ? 100 : json["MC_SEQ_NO"].toInt(),
        dataType: json['MC_DATATYPE'] ?? '',
        columnName: json['MC_VALUES'] ?? '',
        bindFields: json['MC_BINDFIELDS'] ?? '',
        bindValues: json['MC_BINDVALUES'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'MC_DISPLAY_COLUMNS': valueField,
        'MC_SEQ_NO': seqNo,
        'MC_DATATYPE': dataType,
        'MC_VALUES': columnName,
        'MC_BINDFIELDS': bindFields,
        'MC_BINDVALUES': bindFields,
      };
}
