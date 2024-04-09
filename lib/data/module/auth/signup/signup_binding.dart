import 'package:get/get.dart';
import 'package:rapid_app/data/module/auth/signup/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignupController());
  }

}