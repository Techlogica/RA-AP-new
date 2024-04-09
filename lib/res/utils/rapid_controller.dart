import 'package:get/get.dart';
import 'package:rapid_app/data/api/api_client.dart';
import 'package:rapid_app/data/database/database_operations.dart';

abstract class RapidController extends GetxController {
  ApiClient get apiClient => Get.find<ApiClient>();
  DatabaseOperations get dbAccess => Get.find<DatabaseOperations>();
}
