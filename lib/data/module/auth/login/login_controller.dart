import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rapid_app/data/api/http_method.dart';
import 'package:rapid_app/data/model/base/base_response.dart';
import 'package:rapid_app/res/utils/generate_random_string.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/strings.dart';

class LoginController extends RapidController {
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  Rx<bool> isObscure = true.obs;
  Rx<bool> isLoginButtonVisibility = true.obs;
  Rxn<BaseResponse> data = Rxn();

  // navigation argument
  dynamic get argumentData => Get.arguments;

  void obscureToggle() {
    isObscure.value = !isObscure.value;
  }

  void loginButtonVisibility() {
    isLoginButtonVisibility.value = !isLoginButtonVisibility.value;
  }

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController(text: argumentData['userName']);
    passwordController = TextEditingController(text: argumentData['password']);
  }

  Future<BaseResponse> logIn() async {
    dynamic body = {
      'username': usernameController.text.trim(),
      'encryppassword': passwordController.text.trim(),
    };

    Map<String, String>? headers = {
      Strings.kHeaderKey: GetTraceId().generateRandomString(),
    };

    BaseResponse result = await apiClient.executeRequest(
        endpoint: '', method: HttpMethod.POST, body: body, headers: headers);
    data.value = result;
    return result;
  }

  Future<bool> getMtlSysId({required String projectId}) async {
    /// clear local db tables
    dbAccess.clearTables();
    // Getting meta data frm the API
    final metaDataResponse = await apiClient.rapidRepo.getMetaData(
      projectId: projectId,
    );
    // Checking if the status is success
    if (metaDataResponse.status) {
      // get userId
      final loginResponse = await getLoginTableData(metaDataResponse.data);
      if (loginResponse.status) {
        String permissionTableName =
            metaDataResponse.data[0]['MDP_TBL_PERMISSION'];
        RapidPref().setMdpTblPermission(permissionTableName);
        String permissionTableIdColumn =
            metaDataResponse.data[0]['MDP_PERMSNFIELD_USERID'];
        RapidPref().setMdpPermissionFldUsrid(permissionTableIdColumn);
        String metaDataTableIdColumn =
            metaDataResponse.data[0]['MDP_PERMSN_TBLID'];
        RapidPref().setMdpPermissionTblId(metaDataTableIdColumn);
        String loginTableIdColumn =
            metaDataResponse.data[0]['MDP_LGNFIELD_USERID'];
        RapidPref().setLoginUserId(loginResponse.data[0][loginTableIdColumn]);
        String globalSetShow =
            metaDataResponse.data[0]['MDP_GLOBALSETT_ALWAYSHOW'] ?? '';
        RapidPref().setGlobalSettingsShow(globalSetShow);
        double globalSetId = metaDataResponse.data[0]['MDP_GLOBAL_TBLID'] ?? 0;
        RapidPref().setGlobalSettingsTableId(globalSetId);
        String signupTableId =
            metaDataResponse.data[0]['MDP_SIGNUP_TBL'].toString() ?? '';
        RapidPref().setSignupTableId(signupTableId);
        String permissionId =
            metaDataResponse.data[0]['MDP_PERMISSIONID'] ?? '';
        RapidPref().setPermissionId(permissionId);
        String menuCondition = metaDataResponse.data[0]['MDP_MENU_COND'] ?? '';
        RapidPref().setMenuCondition(menuCondition);
        String appTitle = metaDataResponse.data[0]['MDP_PROJ_NAME'] ?? '';
        RapidPref().setAppTitle(appTitle);
        String appLogo = metaDataResponse.data[0]['MDP_LOGO'] ?? '';
        RapidPref().setAppLogo(appLogo);

        //open database
        Box box = await dbAccess.openDatabase();
        // read metadata table values
        var metadataTableData = box.get(Strings.kMetadataTable);
        num? userId = RapidPref().getLoginUserId();
        if (metadataTableData == null) {
          dbAccess.clearTables();
        } else {
          if (metadataTableData.isNotEmpty) {
            var metadataTableDataFilter =
                metadataTableData.where((element) => element.userId == userId);
            if (metadataTableDataFilter.isEmpty) {
              dbAccess.clearTables();
            }
          }
        }
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  ///Returns true: if the username and password matches the validation criteria
  bool isLoginCredentialsValid() {
    return usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  /// Fetching the Login table data
  Future<BaseResponse> getLoginTableData(dynamic metaData) async {
    String loginTableName = metaData[0]['MDP_TBL_LOGIN'];
    String userNameColumn = metaData[0]['MDP_LGNFIELD_USERNAME'];
    String userPasswordColumn = metaData[0]['MDP_LGNFIELD_PASSWORD'];
    String loginTableIdColumn = metaData[0]['MDP_LGNFIELD_USERID'];
    String permissionTableName = metaData[0]['MDP_TBL_PERMISSION'];
    String permissionTableIdColumn = metaData[0]['MDP_PERMSNFIELD_USERID'];
    String metaDataTableIdColumn = metaData[0]['MDP_PERMSN_TBLID'];
    int metaDataTableVersion = metaData[0]['MDP_VERSION'].toInt();
    String metaDataTablePrefix = metaData[0]['MDP_PREFIX'];

    RapidPref().setProjectVersion(metaDataTableVersion);
    RapidPref().setMdpPermissionPrefix(metaDataTablePrefix);

    final result = apiClient.rapidRepo.getLoginTable(
        loginTableName: loginTableName,
        userNameColumn: userNameColumn,
        userPasswordColumn: userPasswordColumn,
        loginTableIdColumn: loginTableIdColumn,
        permissionTableName: permissionTableName,
        permissionTableIdColumn: permissionTableIdColumn,
        metaDataTableIdColumn: metaDataTableIdColumn);
    return result;
  }
}
