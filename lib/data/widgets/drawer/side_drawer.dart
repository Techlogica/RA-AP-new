import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/home/home_controller.dart';
import 'package:rapid_app/data/module/home/home_page.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/strings.dart';

import '../button/drawer_elevated_button_widget.dart';
import '../text/text_widget.dart';

class SideDrawer extends GetView<HomeController> {
  const SideDrawer({
    Key? key,
    required HomeController controller,
  })  : _controller = controller,
        super(key: key);

  final HomeController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Container(
              alignment: Alignment.center,
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      NetworkImage(RapidPref().getAppLogo().toString().trim()),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextWidget(
              text: RapidPref().getAppTitle().toString(),
              textSize: 22,
              textColor: Colors.white,
            ),
          ),
          Container(
            height: 1,
            color: Colors.white,
            margin: const EdgeInsets.only(
              top: 30,
              bottom: 10,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: DrawerElevatedButtonWidget(
                      icon: Icons.dashboard_outlined,
                      title: Strings.kDashboard,
                      colorIconTitle: Colors.white,
                      colorBackground: Theme.of(context).cardColor,
                      onTap: () {
                        controller.tabIndex.value = 0;
                        Get.toNamed(Strings.kHomePage);
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DrawerElevatedButtonWidget(
                      icon: Icons.home_outlined,
                      title: Strings.kHome,
                      colorIconTitle: Colors.white,
                      colorBackground: Theme.of(context).cardColor,
                      onTap: () {
                        controller.tabIndex.value = 1;
                        Get.toNamed(Strings.kHomePage);
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DrawerElevatedButtonWidget(
                      icon: Icons.calendar_today_outlined,
                      title: Strings.kCalendar,
                      colorIconTitle: Colors.white,
                      colorBackground: Theme.of(context).cardColor,
                      onTap: () {
                        controller.tabIndex.value = 2;
                        Get.toNamed(Strings.kHomePage);
                      },
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.white,
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DrawerElevatedButtonWidget(
                      icon: Icons.settings_outlined,
                      title: Strings.kSettings,
                      colorIconTitle: Colors.white,
                      colorBackground: Theme.of(context).cardColor,
                      onTap: () {
                        Get.toNamed(Strings.kSettingsPage);
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DrawerElevatedButtonWidget(
                      icon: Icons.color_lens_outlined,
                      title: Strings.kChangeTheme,
                      colorIconTitle: Colors.white,
                      colorBackground: Theme.of(context).primaryColor,
                      onTap: onChangeThemeTap,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DrawerElevatedButtonWidget(
                      icon: Icons.settings_outlined,
                      title: Strings.kGlobalSettings,
                      colorIconTitle: Colors.white,
                      colorBackground: Theme.of(context).cardColor,
                      onTap: () {
                        Get.toNamed(Strings.kGlobalSettingsPage);
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DrawerElevatedButtonWidget(
                      icon: Icons.lock_outline,
                      title: Strings.kChangePassword,
                      colorIconTitle: Colors.white,
                      colorBackground: Theme.of(context).cardColor,
                      onTap: _onPress,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DrawerElevatedButtonWidget(
                      icon: Icons.logout_outlined,
                      title: Strings.kLogout,
                      colorIconTitle: Theme.of(context).primaryColor,
                      colorBackground: Theme.of(context).cardColor,
                      onTap: _onLogoutPress,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onLogoutPress() {
    Get.back();
    onLogout(_controller);
  }

  _onPress() {
    Get.back();
  }
}
