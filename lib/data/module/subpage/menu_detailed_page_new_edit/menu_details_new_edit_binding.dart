import 'package:get/get.dart';
import 'package:rapid_app/data/api/api_client.dart';
import 'package:rapid_app/data/database/database_operations.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_new_edit/menu_details_new_edit_controller.dart';


class MenuDetailsNewEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MenuDetailsNewEditController(),tag: '${Get.arguments[ "MDT_SYS_ID"]}');
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => DatabaseOperations());
  }
}
