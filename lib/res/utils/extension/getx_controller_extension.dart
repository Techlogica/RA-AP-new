import 'package:get/get.dart';
import 'package:rapid_app/data/api/api_client.dart';

extension GetxControllerExtension on GetxController{
  ApiClient get apiClient => Get.find<ApiClient>();

  void updateBaseUrl(String newBaseUrl){
    apiClient.updateBaseUrl(newBaseUrl);
  }
}