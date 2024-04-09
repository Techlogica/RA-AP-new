class ChartGraphResponse {
  int id;
  String csFilter;
  DateTime? csDate;
  double csValue;
  String csKey;

  ChartGraphResponse(
      {required this.id,
      required this.csFilter,
      this.csDate,
      required this.csValue,
      required this.csKey});

  factory ChartGraphResponse.fromJson(dynamic json, int id) =>
      ChartGraphResponse(
        id: id,
        csFilter: json["CS_FILTER"].toString(),
        // csDate: json["CS_DATE"] ?? '',
        csDate: json["CS_DATE"] == null ? null : DateTime.parse(json["CS_DATE"]),
        csValue: json["CS_VALUE"].toDouble(),
        csKey: json["CS_KEY"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "CS_FILTER": csFilter,
        "CS_DATE": csDate,
        "CS_VALUE": csValue,
        "CS_KEY": csKey,
      };
}