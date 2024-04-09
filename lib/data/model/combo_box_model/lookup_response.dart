class LookupResponse {
  String valueField;
  String textField;

  LookupResponse({required this.valueField, required this.textField});

  factory LookupResponse.fromJson(dynamic json) => LookupResponse(
        // valueField:  '${json['MTV_VALUEFLD']}',
        // textField: '${json['MTV_TEXTFLD']}',
    valueField: json['MTV_VALUEFLD'],
    textField: json['MTV_TEXTFLD'],
      );
  Map<String, dynamic> toJson() => {
        'MTV_VALUEFLD': valueField,
        'MTV_TEXTFLD': textField,
  };

}
