import 'package:get/get.dart';
import 'package:rapid_app/data/module/menu_search/menu_search_controller.dart';

class MenuSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MenuSearchController());
  }
}
