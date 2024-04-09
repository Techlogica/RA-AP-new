import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rapid_app/data/api/api_client.dart';
import 'package:rapid_app/data/database/database_operations.dart';
import 'package:rapid_app/data/model/chart_dashboard_model/chart_dashboard_response.dart';
import 'package:rapid_app/data/model/metadata_actions_model/metadata_actions_response.dart';
import 'package:rapid_app/data/model/metadata_command_model/metadata_command_response.dart';
import 'package:rapid_app/data/module/Calendar/calendar_binding.dart';
import 'package:rapid_app/data/module/calendar/calendar_page.dart';
import 'package:rapid_app/data/module/change_theme/change_theme_controller.dart';
import 'package:rapid_app/data/module/change_theme/change_theme_page.dart';
import 'package:rapid_app/data/module/chart_screen_short/chart_screenshot_binding.dart';
import 'package:rapid_app/data/module/chart_screen_short/chart_screenshot_page.dart';
import 'package:rapid_app/data/module/charts/chart_binding.dart';
import 'package:rapid_app/data/module/charts/chart_page.dart';
import 'package:rapid_app/data/module/chat/chat_binding.dart';
import 'package:rapid_app/data/module/chat/chat_screen.dart';
import 'package:rapid_app/data/module/global_settings/global_settings_binding.dart';
import 'package:rapid_app/data/module/global_settings/global_settings_page.dart';
import 'package:rapid_app/data/module/home/home_binding.dart';
import 'package:rapid_app/data/module/home/home_page.dart';
import 'package:rapid_app/data/module/settings/settings_binding.dart';
import 'package:rapid_app/data/module/settings/settings_page.dart';
import 'package:rapid_app/data/module/subpage/event_editor/event_editing_binding.dart';
import 'package:rapid_app/data/module/subpage/event_editor/event_editing_page.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/menu_advanced_search_grid/menu_detailed_advanced_search_grid_page.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/menu_detailed_advanced_search_binding.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/menu_detailted_advanced_search_page.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page/menu_detailed_binding.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page/menu_detailed_page.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_new_edit/menu_details_new_edit_binding.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_new_edit/menu_details_new_edit_page.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/menu_detailes_search_page.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/menu_details_search_binding.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/invoide_add_search_item_page/invoice_add_search_item_binding.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/invoide_add_search_item_page/invoice_add_search_item_page.dart';
import 'package:rapid_app/data/service/location_service/location_service.dart';
import 'package:rapid_app/firebase_options.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/strings.dart';

import 'data/model/chart_model/chart_response.dart';
import 'data/model/chart_tab_model/chart_tab_response.dart';
import 'data/model/local_notification/local_notification.dart';
import 'data/model/metadata_columns_model/metadata_columns_response.dart';
import 'data/model/metadata_table_model/metadata_table_response.dart';
import 'data/model/projects_list_model/project_list_response.dart';
import 'data/module/auth/login/login_binding.dart';
import 'data/module/auth/login/login_page.dart';
import 'data/module/auth/project_connection/connection_binding.dart';
import 'data/module/auth/project_connection/url_connection_page.dart';
import 'data/module/change_theme/change_theme_binding.dart';
import 'data/module/dashboard/dashboard_binding.dart';
import 'data/module/dashboard/dashboard_page.dart';
import 'data/module/intro/intro_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
  await GetStorage.init();
  //_registerServices();
  //LocationService().getUserCurrentLocation();
  await checkPermissions();
  await Hive.initFlutter();
  _registerAdapter();
  runApp(MyApp());
}

Future<void> checkPermissions() async {
  PermissionStatus storagePermissionStatus = await Permission.storage.status;
  PermissionStatus locationPermissionStatus = await Permission.location.status;
  PermissionStatus photosPermissionStatus = await Permission.photos.status;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
  print('android version ::: ${androidInfo.version.release}');
  if (int.parse(androidInfo.version.release ?? '') >= 14) {
    if (photosPermissionStatus.isDenied) {
      await Permission.photos.request();
    }
    if (locationPermissionStatus.isDenied) {
      await Permission.location.request();
    }
  } else {
    if (storagePermissionStatus.isDenied) {
      await Permission.storage.request();
    }
    if (locationPermissionStatus.isDenied) {
      await Permission.location.request();
    }
  }
}

/// Initiating ApiClient and Repo
void _registerServices() {
  Get.lazyPut(() => ApiClient());
  Get.lazyPut(() => DatabaseOperations());
}

///register hive adapter
void _registerAdapter() {
  Hive.registerAdapter(
    MetadataTableResponseAdapter(),
  );
  Hive.registerAdapter(
    MetadataColumnsResponseAdapter(),
  );
  Hive.registerAdapter(
    ProjectListResponseAdapter(),
  );
  Hive.registerAdapter(
    ChartTabResponseAdapter(),
  );
  Hive.registerAdapter(
    ChartDashboardResponseAdapter(),
  );
  Hive.registerAdapter(
    CharResponseAdapter(),
  );
  Hive.registerAdapter(
    MetadataActionResponseAdapter(),
  );
  Hive.registerAdapter(
    MetadataCommandResponseAdapter(),
  );
  Hive.registerAdapter(LocalNotificationTableAdapter());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ChangeThemeController _changeThemeController =
      Get.put(ChangeThemeController());

  final pages = [
    GetPage(
      name: Strings.kUrlConnectionPage,
      page: () => const UrlConnectionPage(),
      binding: ConnectionBinding(),
    ),
    GetPage(
      name: Strings.kLoginPage,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Strings.kDashboardPage,
      page: () => const Dashboard(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Strings.kMenuDetailedPage,
      binding: MenuDetailedBinding(),
      page: () => MenuDetailedPage(),
    ),
    GetPage(
      name: Strings.kChartPage,
      page: () => const ChartPage(),
      binding: ChartBinding(),
    ),
    GetPage(
      name: Strings.kHomePage,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Strings.kCalendarPage,
      page: () => CalenderPage(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: Strings.kChangeThemePage,
      page: () => const ChangeThemePage(),
      binding: ChangeThemeBinding(),
    ),
    GetPage(
      name: Strings.kEventEditorPage,
      page: () => const EventEditingPage(),
      binding: EventEditingBinding(),
    ),
    GetPage(
      name: Strings.kChartScreenShortPage,
      page: () => const ChartScreenshotPage(),
      binding: ChartScreenshotBinding(),
    ),
    GetPage(
      name: Strings.kMenuDetailsSearchPage,
      page: () => const MenuDetailsSearchPage(),
      binding: MenuDetailsSearchBinding(),
    ),
    GetPage(
      name: Strings.kMenuDetailsNewEditPage,
      page: () => const MenuDetailsNewEditPage(),
      binding: MenuDetailsNewEditBinding(),
    ),
    GetPage(
      name: Strings.kMenuAdvancedSearchPage,
      page: () => const MenuDetailedAdvancedSearchPage(),
      binding: MenuDetailedAdvancedSearchBinding(),
    ),
    GetPage(
      name: Strings.kMenuAdvancedSearchDrop,
      page: () => const InvoiceAddSearchItemPage(),
      binding: InvoiceAddSearchItemBinding(),
    ),
    GetPage(
      name: Strings.kIntroPage,
      page: () => const IntroPage(),
    ),
    GetPage(
      name: Strings.kGlobalSettingsPage,
      page: () => const GlobalSettingsPage(),
      binding: GlobalSettingsBinding(),
    ),
    GetPage(
      name: Strings.kMenuDetailedAdvancedSearchGridPage,
      page: () => const MenuDetailedAdvancedSearchGridPage(),
      binding: MenuDetailedAdvancedSearchBinding(),
    ),
    GetPage(
      name: Strings.kSettingsPage,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Strings.kChatPage,
      page: () => const ChatScreen(),
      binding: ChatBinding(),
    )
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool? isLightTheme = RapidPref().getIsLightTheme();
    /*Color? theme = RapidPref().getAppTheme() ?? Colors.amber;
    _changeThemeController.changeColor(theme);*/
    if (isLightTheme == null) {
      isLightTheme = true;
      RapidPref().setIsLightTheme(isLightTheme);
    }
    return Obx(
      () => GetMaterialApp(
        title: Strings.kAppName,
        debugShowCheckedModeBanner: false,
        darkTheme: _changeThemeController.darkTheme(),
        themeMode: _changeThemeController.theme,
        theme: _changeThemeController.lightTheme(),
        getPages: pages,
        initialRoute: Strings.kIntroPage,
      ),
    );
  }
}
