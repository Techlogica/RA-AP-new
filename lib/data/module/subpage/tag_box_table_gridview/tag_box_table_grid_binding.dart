import 'package:get/get.dart';
import 'package:rapid_app/data/api/api_client.dart';
import 'package:rapid_app/data/database/database_operations.dart';
import 'package:rapid_app/data/module/subpage/tag_box_table_gridview/tag_box_table_grid_controller.dart';

class TagBoxTableGridBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => DatabaseOperations());
    Get.lazyPut(() => TagBoxTableGridController());
  }
}
