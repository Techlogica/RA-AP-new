import 'package:get/get.dart';
import 'package:rapid_app/data/api/api_client.dart';
import 'package:rapid_app/data/database/database_operations.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/menu_advanced_search_grid/menu_detailed_advanced_search_grid_controller.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/menu_detailed_advanced_search_controller.dart';

class MenuDetailedAdvancedSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => MenuDetailedAdvancedSearchController());
    Get.lazyPut(() => DatabaseOperations());
    Get.lazyPut(() => MenuDetailedAdvancedSearchGridController());
  }
}

