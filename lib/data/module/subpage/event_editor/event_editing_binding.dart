import 'package:get/get.dart';

import 'event_editing_controller.dart';

class EventEditingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EventEditingController());
  }
}
