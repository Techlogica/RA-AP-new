import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/advanced_search_widgets/advanced_search_edit_text_widget.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/menu_detailed_advanced_search_controller.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/drop_down_widget.dart';
import '../../../../widgets/loading_indicator/loading_indicator_widget.dart';

class AdvancedSearchNewWidget
    extends GetView<MenuDetailedAdvancedSearchController> {
  const AdvancedSearchNewWidget({
    Key? key,
    required TextEditingController textEditingController,
    this.hint,
    this.indexList,
    this.enabled,
  })  : _textEditingController = textEditingController,
        super(key: key);

  final int? indexList;
  final TextEditingController _textEditingController;
  final String? hint;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _showWidget(),
            ),
          ),
        ],
      ),
    );
  }

  _showWidget() {
    String dataType = controller.selectedField.mdcDatatype!;
    switch (dataType) {
      case 'LOOKUP':
        String colNme = controller.selectedField.mdcColName.toString();
        return Obx(() {
          if (controller.lookupList.isEmpty) {
            return const RapidLoadingIndicator();
          } else if (controller.lookupList[colNme] == null) {
            return const SizedBox();
          } else {
            return DropDownWidget(
              title: hint!,
              list: controller.lookupList[colNme]!,
              hint: _textEditingController.text,
              onChanged: (selectedValue) {
                if (selectedValue == null) {
                  controller.lookupValue[colNme] = '';
                } else {
                  controller.lookupValue[colNme] = selectedValue!.textField;
                  _textEditingController.text = selectedValue.valueField;
                  if (hint == 'Value 2') {
                    controller.value2ValueField =
                        selectedValue.valueField.toString();
                  } else {
                    controller.value1ValueField =
                        selectedValue.valueField.toString();
                  }
                }
              },
              controller: _textEditingController,
              editMode: '',
              enabled: enabled,
              readOnly: controller.selectedField.mdcReadonly!,
            );
          }
        });
      case 'TAGBOX':
        tagboxValue(
          controller.selectedField,
          _textEditingController,
        );
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: AdvancedSearchEditTextWidget(
                controller: _textEditingController,
                dataType: controller.selectedField.mdcDatatype!,
                readOnly: controller.selectedField.mdcReadonly,
                encryptType: controller.selectedField.mdcEncrypt,
                hint: hint!,
                enabled: enabled,
                // editMode: controller.editMode,
              ),
            ),
            Expanded(
                flex: 0,
                child: IconButton(
                    onPressed: () => controller.getChildTable(
                          hint!,
                          _textEditingController,
                          controller.selectedField.mdcValuefieldname!,
                        ),
                    icon: Icon(
                      Icons.search,
                      size: 25,
                      color: Theme.of(Get.context!).backgroundColor,
                    )))
          ],
        );
      case 'SFTAGBOX':
        tagboxValue(
          controller.selectedField,
          _textEditingController,
        );
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: AdvancedSearchEditTextWidget(
                controller: _textEditingController,
                dataType: controller.selectedField.mdcDatatype!,
                readOnly: controller.selectedField.mdcReadonly,
                encryptType: controller.selectedField.mdcEncrypt,
                hint: hint!,
                enabled: enabled,
                // editMode: controller.editMode,
              ),
            ),
            Expanded(
                flex: 0,
                child: IconButton(
                    onPressed: () => controller.getChildTable(
                          hint!,
                          _textEditingController,
                          controller.selectedField.mdcValuefieldname!,
                        ),
                    icon: Icon(
                      Icons.search,
                      size: 25,
                      color: Theme.of(Get.context!).backgroundColor,
                    )))
          ],
        );
      default:
        return AdvancedSearchEditTextWidget(
          hint: hint!,
          controller: _textEditingController,
          dataType: controller.selectedField.mdcDatatype!,
          readOnly: controller.selectedField.mdcReadonly,
          displayFormat: controller.selectedField.mdcDispFormat,
          encryptType: controller.selectedField.mdcEncrypt,
          iconVisible: controller.selectedField.mdcEncbtnVisble,
          enabled: enabled,
          // editMode: controller.editMode,
        );
    }
  }

  void tagboxValue(
      dynamic columnList, TextEditingController _controller) async {
    String tagboxValue = await controller.getTagboxValue(
      comboQry: columnList.mdcComboqry,
      comboWhere: columnList.mdcCombowhere,
      value: _controller.text,
      textField: columnList.mdcTextfieldname,
      valueField: columnList.mdcValuefieldname,
    );
    _controller.value = TextEditingValue(text: tagboxValue);
  }
}
