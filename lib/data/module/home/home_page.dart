import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/calendar/calendar_page.dart';
import 'package:rapid_app/data/module/charts/chart_page.dart';
import 'package:rapid_app/data/module/chat/chat_screen.dart';
import 'package:rapid_app/data/module/dashboard/dashboard_page.dart';
import 'package:rapid_app/data/module/home/home_controller.dart';
import 'package:rapid_app/data/module/menu_search/menu_search_controller.dart';
import 'package:rapid_app/data/module/menu_search/menu_search_page.dart';
import 'package:rapid_app/data/widgets/app_bar/home_app_bar.dart';
import 'package:rapid_app/data/widgets/bottom_bar/home_bottom_bar_widget.dart';
import 'package:rapid_app/data/widgets/bottom_sheet/common_search_bottom_sheet_widget.dart';
import 'package:rapid_app/data/widgets/drawer/side_drawer.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/drawables.dart';
import 'package:rapid_app/res/values/logs/logs.dart';
import 'package:rapid_app/res/values/strings.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);

  final tabs = [
    const ChartPage(),
    const Dashboard(),
    CalenderPage(),
    const MenuSearchPage(),
    const ChatScreen()
  ];
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
        backdropColor: Theme.of(context).backgroundColor,
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        drawer: SafeArea(
          child: SideDrawer(controller: controller),
        ),
        child: WillPopScope(
          onWillPop: _onBackPress,
          child: Scaffold(
            extendBody: true,
            key: _drawerKey,
            appBar: HomeAppBarWidget(
              title: RapidPref().getProjectName().toString(),
              leadingIcon: Image.asset(
                Drawable.kFilePathIcons + Drawable.kMenuIcon,
                height: 25,
                width: 25,
                color: Theme.of(context).primaryColor,
              ),
              actionIcon: Icons.person,
              onTapActionIcon: onActionIconTap,
              onTapLeadingIcon: onLeadingIconTap,
            ),
            bottomNavigationBar: HomeBottomBarWidget(onItemTap: onItemTap),
            body: Obx(
              () => tabs[controller.tabIndex.value],
            ),
          ),
        ));
  }

  onLeadingIconTap() {
    _advancedDrawerController.showDrawer();
  }

  onActionIconTap() {
    // profile click action
    showMemberMenu();
  }

  void showMemberMenu() async {
    String companyVal =
        RapidPref().getGlobalSettingValue().toString().toUpperCase();
    companyVal = companyVal == 'NULL' ? '' : companyVal;
    await showMenu(
      context: Get.context!,
      color: Theme.of(Get.context!).bottomNavigationBarTheme.selectedItemColor,
      position: const RelativeRect.fromLTRB(0, 80, -1.0, 0),
      items: [
        PopupMenuItem(
          value: 0,
          child: Text(
            RapidPref().getUserName().toString().toUpperCase(),
            style: TextStyle(
              color: Theme.of(Get.context!).backgroundColor,
            ),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            'Company $companyVal',
            style: TextStyle(
              color: Theme.of(Get.context!).backgroundColor,
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            Strings.kLogout.tr.toUpperCase(),
            style: TextStyle(
              color: Theme.of(Get.context!).backgroundColor,
            ),
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        if (value == 1) {
          Get.toNamed(Strings.kGlobalSettingsPage);
        }
        if (value == 2) {
          onLogout(controller);
        }
      }
    });
  }

  // bottomNavigationBar click events
  void onItemTap(int index) {
    controller.tabIndex.value = index;
    if (controller.tabIndex.value == 3) {
      MenuSearchController menuSearchController =
          Get.find<MenuSearchController>();
      Get.bottomSheet(
        CommonSearchBottomSheetWidget(
          onTap: () => {
            menuSearchController
                .searchMenus(menuSearchController.controllerSearch.text.trim()),
            menuSearchController.controllerSearch.clear(),
            Get.back(),
          },
          controller: menuSearchController.controllerSearch,
          onTextChange: (String text) {
            Logs.logData("ontextchange::", text.toString());
            menuSearchController
                .searchMenus(menuSearchController.controllerSearch.text.trim());
            // Get.back();
          },
        ),
        enableDrag: true,
      );
    }
  }

  Future<bool> _onBackPress() async {
    if (controller.currentBackPressTime == null) {
      controller.currentBackPressTime = DateTime.now();
      Get.snackbar("Exit!", "Tap back again to leave");
      return false;
    }
    if (DateTime.now().difference(controller.currentBackPressTime!).inSeconds <
        3) {
      return true;
    } else {
      controller.currentBackPressTime = DateTime.now();
      Get.snackbar("Exit!", "Tap back again to leave");
      return false;
    }
  }
}

onChangeThemeTap() {
  Get.toNamed(Strings.kChangeThemePage);
}

// logout alert
onLogout(HomeController controller) {
  Get.defaultDialog(
    backgroundColor: Theme.of(Get.context!).primaryColor,
    title: Strings.kLogout,
    titleStyle: TextStyle(color: Theme.of(Get.context!).backgroundColor),
    middleText: Strings.kLogoutMessage,
    middleTextStyle:
        TextStyle(color: Theme.of(Get.context!).textTheme.headline1!.color!),
    textCancel: Strings.kCancel,
    textConfirm: Strings.kLogout,
    contentPadding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
    titlePadding: const EdgeInsets.only(top: 25, bottom: 20),
    buttonColor: Theme.of(Get.context!).backgroundColor,
    cancelTextColor: Theme.of(Get.context!).backgroundColor,
    confirmTextColor: Theme.of(Get.context!).primaryColor,
    onCancel: () => Get.back(),
    onConfirm: () {
      /// clear shared preference///
      RapidPref().eraseContainer();

      /// clear local db tables///
      controller.dbAccess.clearTables();

      /// move to project list page///
      Get.offAllNamed(
        Strings.kUrlConnectionPage,
      );
    },
    radius: 10.0,
    barrierDismissible: true,
  );
}
