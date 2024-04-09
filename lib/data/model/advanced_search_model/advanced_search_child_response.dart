class AdvancedSearchChildModel {
  String? open;
  String fieldName;
  String operator;
  String modifier;
  String value1;
  String? value1ValueField;
  String? value2;
  String? value2ValueField;
  String? operation;
  String? close;
  String? dataType;
  String? columnName;

  AdvancedSearchChildModel({
    this.open,
    required this.fieldName,
    required this.operator,
    required this.modifier,
    required this.value1,
    this.value1ValueField,
    this.value2,
    this.value2ValueField,
    this.operation,
    this.close,
    this.dataType,
    this.columnName,
  });
}