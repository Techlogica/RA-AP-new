import 'package:get/get.dart';
import 'package:rapid_app/data/api/api_client.dart';
import 'package:rapid_app/data/database/database_operations.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page/menu_detailed_controller.dart';

class MenuDetailedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MenuDetailedController(), tag: '${Get.arguments[ "MDT_SYS_ID"]}');
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => DatabaseOperations());
  }
}
