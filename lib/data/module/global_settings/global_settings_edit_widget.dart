import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/global_settings/global_settings_controller.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/check_box_widget.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/drop_down_widget.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/edit_text_field_widget.dart';
import 'package:rapid_app/data/widgets/loading_indicator/loading_indicator_widget.dart';

class GlobalSettingsEditWidget extends GetView<GlobalSettingsController> {
  const GlobalSettingsEditWidget({
    Key? key,
    required TextEditingController textEditingController,
    required this.indexList,
  })  : _textEditingController = textEditingController,
        super(key: key);

  final int indexList;
  final TextEditingController _textEditingController;

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
    String title = controller.visibleColumnList[indexList].mdcMetatitle;
    String dataType = controller.visibleColumnList[indexList].mdcDatatype!;
    switch (dataType) {
      case 'CHECKBOXSTR':
        String fieldName =
            controller.visibleColumnList[indexList].mdcColName.toString();
        return Obx(
          () => CheckBoxWidget(
            hint: title,
            isChecked: controller.checkBoxList[fieldName] == null
                ? false
                : _textEditingController.text == 'Y'
                    ? true
                    : false,
            onChanged: (newValue) {
              controller.checkBoxList[fieldName] = newValue ?? false;
              if (controller.checkBoxList[fieldName]!) {
                _textEditingController.text = 'Y';
              } else {
                _textEditingController.text = 'N';
              }
            },
          ),
        );
      case 'CHECKBOX':
        String fieldName =
            controller.visibleColumnList[indexList].mdcColName.toString();
        return Obx(
          () => CheckBoxWidget(
            hint: title,
            isChecked: controller.checkBoxList[fieldName] == null
                ? false
                : _textEditingController.text == '1'
                    ? true
                    : false,
            onChanged: (newValue) {
              controller.checkBoxList[fieldName] = newValue ?? false;
              if (controller.checkBoxList[fieldName]!) {
                _textEditingController.text = '1';
              } else {
                _textEditingController.text = '0';
              }
            },
          ),
        );
      case 'LOOKUP':
        String colNme =
            controller.visibleColumnList[indexList].mdcColName.toString();
        return Obx(() {
          if (controller.lookupList.isEmpty) {
            return const RapidLoadingIndicator();
          } else if (controller.lookupList[colNme] == null) {
            return const SizedBox();
          } else {
            return DropDownWidget(
              title: title,
              list: controller.lookupList[colNme]!,
              hint: _textEditingController.text,
              onChanged: (selectedValue) {
                if (selectedValue == null) {
                  controller.lookupValue[colNme] = '';
                } else {
                  controller.lookupValue[colNme] = selectedValue.valueField;
                }
              },
              controller: _textEditingController,
              editMode: '',
              readOnly: controller.visibleColumnList[indexList].mdcReadonly!,
            );
          }
        });
      case 'TAGBOX':
        tagboxValue(
          controller.visibleColumnList[indexList],
          _textEditingController,
        );
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: EditTextFieldWidget(
                controller: _textEditingController,
                dataType: controller.visibleColumnList[indexList].mdcDatatype!,
                readOnly: controller.visibleColumnList[indexList].mdcReadonly,
                encryptType: controller.visibleColumnList[indexList].mdcEncrypt,
                hint: title,
                editMode: '',
                keyInfo: '',
                obscureText: false,
                dateClick: () {},
              ),
            ),
            Expanded(
                flex: 0,
                child: IconButton(
                    onPressed: () => controller.getChildTable(
                        indexList, _textEditingController),
                    icon: Icon(
                      Icons.search,
                      size: 25,
                      color: Theme.of(Get.context!).backgroundColor,
                    ))
            )
          ],
        );
      default:
        return EditTextFieldWidget(
          hint: title,
          controller: _textEditingController,
          dataType: controller.visibleColumnList[indexList].mdcDatatype!,
          readOnly: controller.visibleColumnList[indexList].mdcReadonly,
          displayFormat: controller.visibleColumnList[indexList].mdcDispFormat,
          encryptType: controller.visibleColumnList[indexList].mdcEncrypt,
          iconVisible: controller.visibleColumnList[indexList].mdcEncbtnVisble,
          editMode: '',
          keyInfo: controller.visibleColumnList[indexList].mdcKeyinfo,
          obscureText: false,
          obscureClick: () {},
          dateClick: () {},
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
      columnName: columnList.mdcColName,
    );
    _controller.value = TextEditingValue(text: tagboxValue);
  }
}
