import 'package:get/get.dart';
import 'package:rapid_app/data/api/api_client.dart';
import 'package:rapid_app/data/database/database_operations.dart';
import 'package:rapid_app/data/module/charts/chart_controller.dart';

class ChartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>ApiClient());
    Get.lazyPut(()=>DatabaseOperations());
    Get.lazyPut(() => ChartController());
  }
}
