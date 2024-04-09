import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/advanced_search_widgets/advanced_dropdown_widget.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/advanced_search_widgets/advanced_search_drop_down.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/advanced_search_widgets/advanced_search_edit_text_widget.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/advanced_search_widgets/advanced_search_new_widget.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/menu_detailed_advanced_search_controller.dart';
import 'package:rapid_app/data/widgets/app_bar/app_bar_widget.dart';
import 'package:rapid_app/res/values/strings.dart';

class MenuDetailedAdvancedSearchPage
    extends GetView<MenuDetailedAdvancedSearchController> {
  const MenuDetailedAdvancedSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: const Text(Strings.kAdvancedSearchDetails),
        leadingIcon: Icons.arrow_back,
        onTapLeadingIcon: _backPress,
        actionIcon: Icons.add,
        onTapActionIcon: controller.addRow,
      ),
      body: _BodyWidget(),
    );
  }

  void _backPress() {
    Get.back();
  }
}

class _BodyWidget extends GetView<MenuDetailedAdvancedSearchController> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      child: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
            child: SizedBox(
              width: 100,
              child: AdvancedSearchEditTextWidget(
                  controller: controller.openBracesController,
                  dataType: 'STRING',
                  textAlign: TextAlign.left,
                  hint: 'Open ('),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Obx(
              () => controller.fieldList.isEmpty
                  ? const SizedBox()
                  : AdvancedSearchDropDown(
                      title: 'Field Name',
                      list: controller.fieldList,
                      onChanged: (selectedValue) =>
                          controller.onFieldChange(selectedValue),
                      controller: controller.fieldNameController,
                    ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: AdvancedDropDownWidget(
              onChanged: controller.onOperatorChange,
              list: controller.operatorList,
              controller: controller.operatorController,
              title: 'Operator',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Obx(
              () => AdvancedDropDownWidget(
                title: 'Modifier',
                list: controller.modifierList,
                controller: controller.modifierController,
                onChanged: controller.onModifierChange,
                enabled: controller.modifierEnabled.value
                    ? true
                    : false,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: Obx(() => controller.fieldList.isNotEmpty
                ? controller.typeUpdated.value
                    ? AdvancedSearchNewWidget(
                        textEditingController: controller.value1Controller,
                        hint: 'Value 1',
                        enabled: true,
                      )
                    : AdvancedSearchNewWidget(
                        textEditingController: controller.value1Controller,
                        hint: 'Value 1',
                        enabled: true,
                      )
                : const SizedBox()),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: Obx(() => controller.fieldList.isNotEmpty
                ? controller.typeUpdated.value || controller.value2Enabled.value
                    ? AdvancedSearchNewWidget(
                        textEditingController: controller.value2Controller,
                        hint: 'Value 2',
                        enabled: controller.value2Enabled.value,
                      )
                    : AdvancedSearchNewWidget(
                        textEditingController: controller.value2Controller,
                        hint: 'Value 2',
                        enabled: controller.value2Enabled.value,
                      )
                : const SizedBox()),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: AdvancedDropDownWidget(
                controller: controller.operationController,
                title: 'And/Or',
                onChanged: controller.onFilterChange,
                list: controller.filterOperator),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: SizedBox(
              width: 100,
              child: AdvancedSearchEditTextWidget(
                  controller: controller.closeBracesController,
                  dataType: 'STRING',
                  textAlign: TextAlign.center,
                  hint: 'Close )'),
            ),
          ),
        ],
      ),
    );
  }
}
