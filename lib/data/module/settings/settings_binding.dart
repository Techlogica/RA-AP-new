import 'package:get/get.dart';
import 'package:rapid_app/data/api/api_client.dart';
import 'package:rapid_app/data/database/database_operations.dart';
import 'package:rapid_app/data/module/settings/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController());
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => DatabaseOperations());
  }
}
