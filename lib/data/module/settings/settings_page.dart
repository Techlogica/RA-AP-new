import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:rapid_app/data/module/settings/settings_controller.dart';
import 'package:rapid_app/data/widgets/app_bar/home_app_bar.dart';
import 'package:rapid_app/data/widgets/button/login_button_widget.dart';
import 'package:rapid_app/data/widgets/text/text_widget.dart';
import 'package:rapid_app/res/values/strings.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBarWidget(
        title: Strings.kSettings,
        leadingIcon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 25,
        ),
        onTapLeadingIcon: _backPress,
      ),
      body: _SettingsBody(),
    );
  }

  void _backPress() {
    Get.back();
  }
}

class _SettingsBody extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 20,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              flex: 0,
              child: TextWidget(
                  text: Strings.kCacheMenus,
                  textSize: 20.0,
                  textColor: Colors.black),
            ),
            Expanded(
              flex: 1,
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.localMenuList.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Checkbox(
                          value: controller.setCacheCheckboxValue(
                              controller.localMenuList[index].cacheFlag),
                          onChanged: (value) =>
                              controller.cacheCheckboxOnChange(index, value!),
                          activeColor: Theme.of(context).backgroundColor,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: Text(
                            controller.localMenuList[index].tableName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: LiteRollingSwitch(
                            value: controller.setOfflineOnlineSwitchValue(
                                controller.localMenuList[index].offlineFlag),
                            textOn: Strings.kOnlineSave,
                            textOff: Strings.kOfflineSave,
                            colorOn: Colors.green,
                            colorOff: Colors.red,
                            iconOn: Icons.done,
                            iconOff: Icons.done,
                            textSize: 12.0,
                            onDoubleTap: () {},
                            onSwipe: () {},
                            onTap: () {},
                            onChanged: (bool value) => controller
                                .offlineOnlineSwitchOnChange(index, value),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: LoginButtonWidget(
                label: Strings.kSave.toUpperCase(),
                onTap: controller.onTapSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
