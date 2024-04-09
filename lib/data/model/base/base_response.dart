import 'dart:convert';

class BaseResponse {
  BaseResponse({
    required this.status,
    required this.message,
    required this.data,
    this.statusCode,
  });

  bool status;
  String message;
  dynamic data;
  int? statusCode;

  factory BaseResponse.fromRawJson(String str, int? statusCode) =>
      BaseResponse.fromJson(json.decode(str), statusCode);

  String toRawJson() => json.encode(toJson());

  factory BaseResponse.fromJson(dynamic json, int? statusCode) => BaseResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"],
        statusCode: statusCode,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
        'statusCode': statusCode,
      };
}
