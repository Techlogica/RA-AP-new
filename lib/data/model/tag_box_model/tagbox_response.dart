class TagboxResponse {
  dynamic valueField;
  String textField;

  TagboxResponse({required this.valueField, required this.textField});

  factory TagboxResponse.fromJson(dynamic json) => TagboxResponse(
    valueField: json['MTV_VALUEFLD'] ?? '',
    textField: json['MTV_TEXTFLD'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'MTV_VALUEFLD': valueField,
    'MTV_TEXTFLD': textField,
  };
}
