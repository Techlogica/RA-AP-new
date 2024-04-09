import 'package:get/get.dart';
import 'package:rapid_app/data/module/chart_grid/chart_grid_controller.dart';

class ChartGridBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChartGridController());
  }

}