import 'dart:ui';
import 'package:get_storage/get_storage.dart';
import 'package:rapid_app/res/values/strings.dart';

class RapidPref {
  final storage = GetStorage();

  String? getToken() => storage.read(Strings.keyToken);

  void setToken(String token) => storage.write(Strings.keyToken, token);

  String? getProjectId() => storage.read(Strings.keyProjectId);

  void setProjectId(String projectId) =>
      storage.write(Strings.keyProjectId, projectId);

  String? getProjectDb() => storage.read(Strings.keyProjectDb);

  void setProjectDb(String keyProjectDb) =>
      storage.write(Strings.keyProjectDb, keyProjectDb);

  String? getLoggedInProjectName() =>
      storage.read(Strings.kLoggedInProjectName);

  void setLoggedInProjectName(String projectName) =>
      storage.write(Strings.kLoggedInProjectName, projectName);

  String? getProjectIcon() => storage.read(Strings.kProjectIcon);

  void setProjectIcon(String? projectIcon) =>
      storage.write(Strings.kProjectIcon, projectIcon);

  String? getUserName() => storage.read(Strings.keyUserName);

  void setUserName(String userName) =>
      storage.write(Strings.keyUserName, userName);

  String? getUserPassword() => storage.read(Strings.keyPassword);

  void setUserPassword(String password) =>
      storage.write(Strings.keyPassword, password);

  num? getLoginUserId() => storage.read(Strings.keyLoginUserId);

  void setLoginUserId(num loginUserId) =>
      storage.write(Strings.keyLoginUserId, loginUserId);

  int? getProjectVersion() => storage.read(Strings.keyProjectVersion);

  void setProjectVersion(int version) =>
      storage.write(Strings.keyProjectVersion, version);

  String? getBaseUrl() => storage.read(Strings.kGetBaseUrl);

  void setBaseUrl(String baseUrl) =>
      storage.write(Strings.kGetBaseUrl, baseUrl);

  String? getProjectKey() => storage.read(Strings.kDatabase);

  void setProjectKey(String baseUrl) =>
      storage.write(Strings.kDatabase, baseUrl);

  String? getProjectName() => storage.read(Strings.kDatabase);

  void setProjectName(String baseUrl) =>
      storage.write(Strings.kDatabase, baseUrl);

  Color? getAppTheme() => storage.read(Strings.kAppTheme);

  void setAppTheme(Color? color) {
    storage.write(Strings.kAppTheme, color);
  }

  bool? getIsLightTheme() => storage.read(Strings.kLightTheme);

  void setIsLightTheme(bool? enabled) {
    storage.write(Strings.kLightTheme, enabled);
  }

  String? getMdpTblPermission() => storage.read(Strings.keyTablePermission);

  void setMdpTblPermission(String mdpTblPermission) {
    storage.write(Strings.keyTablePermission, mdpTblPermission);
  }

  String? getMdpPermissionFldUsrid() =>
      storage.read(Strings.keyPermissionFieldUserId);

  void setMdpPermissionFldUsrid(String mdpPermissionFldUsrid) {
    storage.write(Strings.keyPermissionFieldUserId, mdpPermissionFldUsrid);
  }

  String? getMdpPermissionTblId() => storage.read(Strings.keyPermissionTableId);

  void setMdpPermissionTblId(String mdpPermissionTblId) {
    storage.write(Strings.keyPermissionTableId, mdpPermissionTblId);
  }

  String? getMdpPermissionPrefix() => storage.read(Strings.keyPermissionPrefix);

  void setMdpPermissionPrefix(String mdpPermissionPrefix) {
    storage.write(Strings.keyPermissionPrefix, mdpPermissionPrefix);
  }

  String? getGlobalSettingsShow() => storage.read(Strings.keyGlobalSettingShow);

  void setGlobalSettingsShow(String globalSettings) =>
      storage.write(Strings.keyGlobalSettingShow, globalSettings);

  double? getGlobalSettingsTableId() =>
      storage.read(Strings.keyGlobalSettingTableId);

  void setGlobalSettingsTableId(double globalSettingsId) =>
      storage.write(Strings.keyGlobalSettingTableId, globalSettingsId);

  String? getSignupTableId() => storage.read(Strings.keySignupTableId);

  void setSignupTableId(String signupTableId) =>
      storage.write(Strings.keySignupTableId, signupTableId);

  String? getPermissionId() => storage.read(Strings.keyPermissionId);

  void setPermissionId(String permissionId) =>
      storage.write(Strings.keyPermissionId, permissionId);

  String? getMenuCondition() => storage.read(Strings.keyMenuCondition);

  void setMenuCondition(String menuCondition) =>
      storage.write(Strings.keyMenuCondition, menuCondition);

  String? getGlobalSettingKey() => storage.read(Strings.keyGlobalSettingKey);

  void setGlobalSettingKey(String globalSettingKey) =>
      storage.write(Strings.keyGlobalSettingKey, globalSettingKey);

  String? getGlobalSettingValue() =>
      storage.read(Strings.keyGlobalSettingValue);

  void setGlobalSettingValue(String globalSettingValue) =>
      storage.write(Strings.keyGlobalSettingValue, globalSettingValue);

  String? getAppLogo() =>
      storage.read(Strings.keyAppLogo);

  void setAppLogo(String appLogo) =>
      storage.write(Strings.keyAppLogo, appLogo);

  String? getAppTitle() =>
      storage.read(Strings.keyAppTitle);

  void setAppTitle(String appTitle) =>
      storage.write(Strings.keyAppTitle, appTitle);

  void eraseContainer() {
    storage.erase();
  }
}
