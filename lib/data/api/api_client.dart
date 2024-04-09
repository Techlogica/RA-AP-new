import 'dart:convert';

import 'package:get/get.dart';
import 'package:rapid_app/data/model/base/base_response.dart';
import 'package:rapid_app/data/repository/online/rapid/rapid_repository.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/logs/logs.dart';

class ApiClient extends GetConnect {
  ApiClient() {
    httpClient.baseUrl = RapidPref().getBaseUrl();
    httpClient.timeout = const Duration(seconds: 180);
  }

  late RapidRepository rapidRepo = RapidRepository(this);

  void updateBaseUrl(String newBaseUrl) {
    httpClient.baseUrl = newBaseUrl;
  }

  Future<BaseResponse> executeRequest({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    var response = await request<dynamic>(
      endpoint,
      method,
      body: json.encode(body),
      headers: headers,
    );

    logResponse(response, body);

    try {
      final result = BaseResponse.fromJson(response.body, response.statusCode);
      print('try is wokring');
      return result;
    } catch (error) {
      error.printError();
      final result = BaseResponse(
        status: false,
        message: error.toString(),
        data: response.body,
        statusCode: response.statusCode,
      );
      print('catch is wokring');
      return result;
    }
  }

  Future<BaseResponse> executeRequestWithParam({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    required dynamic param,
    Map<String, String>? headers,
  }) async {
    final enBody = json.encode(body);
    final fnlBody = enBody.substring(0, enBody.length - 1);
    dynamic bodyWithParam = '$fnlBody,"param": $param}';

    Logs.logData("bodywithparam", bodyWithParam.toString());

    var response = await request<dynamic>(
      endpoint,
      method,
      body: bodyWithParam,
      headers: headers,
    );

    logResponse(response, body);

    try {
      final result = BaseResponse.fromJson(response.body, response.statusCode);
      return result;
    } catch (error) {
      error.printError();
      final result = BaseResponse(
        status: false,
        message: error.toString(),
        data: null,
        statusCode: response.statusCode,
      );
      return result;
    }
  }

  Future<BaseResponse> executeInsertDeleteRequest({
    required String endpoint,
    required String method,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    var response = await request<dynamic>(
      endpoint,
      method,
      body: body,
      headers: headers,
    );

    logResponse(response, body);

    try {
      final result = BaseResponse.fromJson(response.body, response.statusCode);
      return result;
    } catch (error) {
      error.printError();
      final result = BaseResponse(
        status: false,
        message: error.toString(),
        data: null,
        statusCode: response.statusCode,
      );
      return result;
    }
  }

  logResponse(Response response, dynamic body) {
    Logs.logData("url:", response.request?.url.toString());
    Logs.logData("statusCode:", response.statusCode.toString());
    Logs.logData("method:", response.request?.method.toString());
    Logs.logData("header:", response.request?.headers.toString());
    Logs.logData("body:", json.encode(body).toString());
    Logs.logData("response:", response.bodyString.toString());
  }
}
