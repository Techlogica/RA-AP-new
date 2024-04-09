import 'package:get/get.dart';
import 'package:rapid_app/data/module/change_theme/change_theme_controller.dart';

class ChangeThemeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangeThemeController());
  }
}
