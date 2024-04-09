import 'package:get/get.dart';
import 'package:rapid_app/data/module/chart_screen_short/chart_screenshot_controller.dart';

class ChartScreenshotBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ChartScreenshotController());
  }

}