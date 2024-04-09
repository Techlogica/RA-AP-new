import 'package:get/get.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/menu_advanced_search_grid/menu_detailed_advanced_search_grid_controller.dart';

class MenuDetailedAdvancedSearchGridBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MenuDetailedAdvancedSearchGridController());
  }
}
