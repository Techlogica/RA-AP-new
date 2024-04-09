import 'package:get/get.dart';
import 'package:rapid_app/data/api/api_client.dart';
import 'package:rapid_app/data/database/database_operations.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/menu_details_search_controller.dart';

class MenuDetailsSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => DatabaseOperations());
    Get.lazyPut(() => MenuDetailsSearchController());
  }
}
