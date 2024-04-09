import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/global_settings/global_settings_edit_widget.dart';
import 'package:rapid_app/res/values/strings.dart';
import '../../widgets/app_bar/home_app_bar.dart';
import '../../widgets/button/login_button_widget.dart';
import 'global_settings_controller.dart';

class GlobalSettingsPage extends GetView<GlobalSettingsController> {
  const GlobalSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBarWidget(
        title: Strings.kGlobalSettings,
        leadingIcon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 25,
        ),
        actionIcon: Icons.close,
        onTapActionIcon: _backPress,
        onTapLeadingIcon: _backPress,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Obx(
              () => controller.isValueCheck.value
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: controller.visibleColumnList.length,
                      itemBuilder: (context, index) {
                        return GlobalSettingsEditWidget(
                          indexList: index,
                          textEditingController: controller.getControllerValue(
                              controller.visibleColumnList[index].mdcColName,
                              index),
                        );
                      })
                  : const SizedBox(),
            ),
          ),
          Expanded(
            flex: 0,
            child: Obx(
              () => Padding(
                  padding: const EdgeInsets.all(20),
                  child: controller.isSaveBtnVisible.value
                      ? LoginButtonWidget(
                          label: Strings.kSave,
                          onTap: controller.saveGlobalSettingValue,
                        )
                      : const SizedBox()),
            ),
          ),
        ],
      ),
    );
  }

  void _backPress() {
    Get.offAllNamed(Strings.kHomePage);
  }
}
