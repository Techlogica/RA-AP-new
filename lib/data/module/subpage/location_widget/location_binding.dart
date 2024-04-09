import 'package:get/get.dart';
import 'package:rapid_app/data/api/api_client.dart';
import 'package:rapid_app/data/database/database_operations.dart';
import 'package:rapid_app/data/module/subpage/location_widget/location_controller.dart';
import 'package:rapid_app/data/service/location_service/location_service.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => DatabaseOperations());
    Get.lazyPut(() => LocationController());
    Get.lazyPut(() => LocationService());
  }
}
