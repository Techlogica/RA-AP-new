import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rapid_app/data/model/projects_list_model/project_list_response.dart';
import 'package:rapid_app/res/values/strings.dart';
import 'package:validators/validators.dart';
import '../../../../res/utils/rapid_pref.dart';

class ConnectionController extends GetxController {
  RxList<ProjectListResponse> savedProjects = RxList<ProjectListResponse>([]);

  Box<ProjectListResponse> getUsers() =>
      Hive.box<ProjectListResponse>(Strings.kRapidMainDatabase);

  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController baseUrlController = TextEditingController();
  RxBool validationProjectName = false.obs;
  RxBool validationUrl = false.obs;
  String errorMsgProjectName = '', errorMsgUrl = '';
  bool isLightMode = RapidPref().getIsLightTheme() ?? true;

  @override
  void onInit() {
    super.onInit();
    fetchProjectsFromDb();
  }

  /// Returns true: if the baseurl matches the validation criteria
  bool isBaseUrlCredentialValid() {
    // url validation
    String getUrl = baseUrlController.text.toString().trim();
    // print('isUrl: $getUrl - ${isURL(getUrl, requireTld: true)}');

    String url = baseUrlController.text.toString().trim();
    if (isURL(getUrl, requireTld: true)) {
      if (url.isEmpty ||
          url.substring(0, 4) != 'http' ||
          !url.endsWith('/api/')) {
        validationUrl.value = true;
        errorMsgUrl = Strings.kInvalidUrl.tr;
        return false;
      } else {
        validationUrl.value = false;
        return true;
      }
    } else {
      validationUrl.value = true;
      errorMsgUrl = Strings.kInvalidUrl.tr;
      return false;
    }
  }

  /// Returns true: if the project_name matches the validation criteria
  bool isProjectNameCredentialValid() {
    if (projectNameController.text.toString().trim().isEmpty) {
      validationProjectName.value = true;
      errorMsgProjectName = Strings.kInvalidProjectName.tr;
      return false;
    } else {
      validationProjectName.value = false;
      return true;
    }
  }

  Future fetchProjectsFromDb() async {
    final userBox =
        await Hive.openBox<ProjectListResponse>(Strings.kRapidMainDatabase);
    // read metadata table values
    List<ProjectListResponse> dbSavedProjects =
        userBox.values.toList().cast<ProjectListResponse>();
    savedProjects.value = dbSavedProjects;
  }
}
