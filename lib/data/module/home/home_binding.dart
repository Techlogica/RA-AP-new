import 'package:get/get.dart';
import 'package:rapid_app/data/api/api_client.dart';
import 'package:rapid_app/data/database/database_operations.dart';
import 'package:rapid_app/data/module/charts/chart_controller.dart';
import 'package:rapid_app/data/module/chat/chat_controller.dart';
import 'package:rapid_app/data/module/dashboard/dashboard_controller.dart';
import 'package:rapid_app/data/module/menu_search/menu_search_controller.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => DatabaseOperations());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => ChartController());
    Get.lazyPut(() => CalendarController());
    Get.lazyPut(() => MenuSearchController());
    Get.lazyPut(() => ChatController());
  }
}
