import 'package:get/get.dart';
import 'package:rapid_app/data/database/database_operations.dart';
import 'package:rapid_app/data/module/auth/login/login_controller.dart';

class LoginBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => DatabaseOperations());
  }

}