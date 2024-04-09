import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/menu_details_search_controller.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/check_box_widget.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/drop_down_widget.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/edit_text_field_widget.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/invoide_add_search_item_page/invoice_add_search_item_page.dart';
import '../../../../widgets/image/image_picker_widget.dart';
import '../../../../widgets/loading_indicator/loading_indicator_widget.dart';

class SearchTextFieldWidget extends GetView<MenuDetailsSearchController> {
  const SearchTextFieldWidget({
    required this.width,
    Key? key,
    required TextEditingController textEditingController,
    required this.indexList,
  })  : _textEditingController = textEditingController,
        super(key: key);
  final int indexList;
  final TextEditingController _textEditingController;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,),
      child: Align(
        alignment: Alignment.centerLeft,
        child: _showWidget(),
      ),
    );
  }

  _showWidget() {
    String title = controller.selectedTabColumnsList[indexList].mdcMetatitle;
    String dataType = controller.selectedTabColumnsList[indexList].mdcDatatype!;
    String colName = controller.selectedTabColumnsList[indexList].mdcColName;
    if (controller.requiredDataList.any((element) => element.contains(colName))) {
      title = title + '*';
    }
    switch (dataType) {
      case 'CHECKBOXSTR':
        String fieldName =
            controller.selectedTabColumnsList[indexList].mdcColName.toString();
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
            controller.selectedTabColumnsList[indexList].mdcColName.toString();
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
        return Obx(() => showLookup(colName, title));
        // String colNme = controller.selectedTabColumnsList[indexList].mdcColName.toString();
        // print(",,,,,,,,,,,,,,,,,,,,,,$colNme");
        // return Obx(() {
        //   if (controller.lookupList.isEmpty) {
        //     return const RapidLoadingIndicator();
        //   } else if (controller.lookupList[colNme] == null) {
        //     return  Container(
        //       height: 30,
        //       width: 100,
        //       color: Colors.yellow,
        //     );
        //   } else {
        //     return Container(
        //       color: Colors.red,
        //       child: DropDownWidget(
        //         title: title,
        //         list: controller.lookupList[colNme]!,
        //         hint: _textEditingController.text,
        //         onChanged: (selectedValue) {
        //           if (selectedValue == null) {
        //             controller.lookupValue[colNme] = '';
        //           } else {
        //             controller.lookupValue[colNme] = selectedValue!.valueField;
        //           }
        //         },
        //         controller: _textEditingController,
        //         editMode: "controller.newEditMode",
        //         readOnly: controller.selectedTabColumnsList[indexList].mdcReadonly!,
        //       ),
        //     );
        //   }
        // }
        // );
      case 'IMAGE':

        if (_textEditingController.text.toString() == 'null') {
          _textEditingController.value = const TextEditingValue(text: '');
        }
        controller.imageValue[colName] =
            _textEditingController.text.toString().trim();
        return Obx(() => ImagePickerWidget(
            image: controller.imageValue[colName]!,
            onTap: () async {
              FilePickerResult? pickedImage =
                  await controller.filePicker(FileType.custom);
              if (pickedImage != null) {
                _textEditingController.text = pickedImage.files.single.path!;
                controller.imageValue[colName] =
                    _textEditingController.text.toString();
              }
            },
            title: title));
      case 'DOC':
        String colName =
            controller.selectedTabColumnsList[indexList].mdcColName.toString();
        return Obx(
          () => Row(
            children: [
              Expanded(
                flex: 1,
                child: EditTextFieldWidget(
                  enabled: false,
                  controller: _textEditingController,
                  dataType:
                      controller.selectedTabColumnsList[indexList].mdcDatatype!,
                  readOnly:
                      controller.selectedTabColumnsList[indexList].mdcReadonly,
                  encryptType:
                      controller.selectedTabColumnsList[indexList].mdcEncrypt,
                  hint: title,
                  editMode: controller.newEditMode,
                  keyInfo: '',
                  obscureText: false,
                  dateClick: () {},
                ),
              ),
              Expanded(
                  flex: 0,
                  child: IconButton(
                      onPressed: () async {
                        FilePickerResult? pickedFile =
                            await controller.filePicker(FileType.any);
                        if (pickedFile != null) {
                          _textEditingController.text =
                              pickedFile.files.single.path!;
                          controller.fileValue[colName] =
                              pickedFile.files.single.path!;
                        }
                      },
                      icon: const Icon(
                        Icons.file_copy_outlined,
                        size: 25,
                      )))
            ],
          ),
        );
      case 'LOCATION':
        return Obx(() {
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: EditTextFieldWidget(
                  enabled: false,
                  controller: _textEditingController,
                  dataType: dataType,
                  hint: title,
                  editMode: controller.newEditMode,
                  keyInfo: '',
                  obscureText: false,
                  dateClick: () {},
                ),
              ),
              Expanded(
                  flex: 0,
                  child: IconButton(
                    onPressed: () => controller.getLocation(
                        indexList, _textEditingController),
                    icon: const Icon(
                      Icons.location_on_outlined,
                      size: 30,
                    ),
                  ))
            ],
          );
        });
      case 'TAGBOX':
        tagboxValue(
          controller.selectedTabColumnsList[indexList],
          _textEditingController,
        );
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: EditTextFieldWidget(
                controller: _textEditingController,
                dataType:
                    controller.selectedTabColumnsList[indexList].mdcDatatype!,
                readOnly:
                    controller.selectedTabColumnsList[indexList].mdcReadonly,
                encryptType:
                    controller.selectedTabColumnsList[indexList].mdcEncrypt,
                hint: title,
                editMode: controller.newEditMode,
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
                    icon: const Icon(
                      Icons.search,
                      size: 25,
                    )))
          ],
        );
      default:
        String colName=controller.selectedTabColumnsList[indexList].mdcColName.toString();
        return Obx(() => Padding(
          padding: const EdgeInsets.only(top:17.0),
          child: EditTextFieldWidget(
            hint: title,
            controller: _textEditingController,
            dataType: controller.selectedTabColumnsList[indexList].mdcDatatype!,
            readOnly: controller.selectedTabColumnsList[indexList].mdcReadonly,
            displayFormat:
            controller.selectedTabColumnsList[indexList].mdcDispFormat,
            encryptType: controller.selectedTabColumnsList[indexList].mdcEncrypt,
            iconVisible:
            controller.selectedTabColumnsList[indexList].mdcEncbtnVisble,
            editMode: controller.newEditMode,
            keyInfo: controller.selectedTabColumnsList[indexList].mdcKeyinfo,
            obscureText: controller.isObscureMap[colName] ?? true,
            obscureClick: () {
              bool isObscure = controller.isObscureMap[colName] ?? true;
              isObscure = !isObscure;
              controller.isObscureMap[colName] = isObscure;
            },
            dateClick: () {},
          ),
        ));
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


  showLookup(String colName, String title) {
    String colNme = controller.selectedTabColumnsList[indexList].mdcColName.toString();
    if (controller.lookupList.isEmpty) {
      return const RapidLoadingIndicator();
    }
    else {
      return InkWell(
        onTap: () {
          Get.to(() => const InvoiceAddSearchItemPage(), arguments: {
            "lookupList": controller.lookupList,
            'colName': colName,
            'title':title
          })?.then((value) {
            controller.selectedItemsList[colName] = "${value['selectedItem'].valueField} : ${value['selectedItem'].textField}";
            controller.checkValidation(
              changedValue: value['selectedItem'].textField.toString(),
              valueField: value['selectedItem'].valueField.toString(),
              colName: colName,
              dataType: controller.selectedTabColumnsList[indexList].mdcDatatype!,
            );
          });
          // Get.to(() => const InvoiceAddSearchItemPage(), arguments: {
          //   "lookupList": controller.lookupList,
          //   'colName': colName,
          // })?.then((value) {
          //
          //   controller.fetchedItemsList.value = value['itemList'];
          //   controller.fetchedColName.value = value['colName'];
          //   controller.fetchedIndex.value = value['index'];
          //   controller.valueFeild.value = controller.fetchedItemsList[colName]![controller.fetchedIndex.value].valueField;
          //   controller.textFeild.value = controller.fetchedItemsList[colName]![controller.fetchedIndex.value].textField;
          //   controller.valPlusText.value = "${controller.valueFeild.value} : ${controller.textFeild.value}";
          //   controller.selectedItemsList[colName]=controller.valPlusText.value;
          //   // print("##########################################Textfeild:${controller.valPlusText.value}");
          //   // print("##########################################valuefeild:${controller.fetchedColName.value}::${controller.fetchedIndex.value}:::${controller.valueFeild.value}");
          // });
        },
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.red,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(Get.context!).backgroundColor,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.selectedItemsList[colName] ?? '', // Display the value here
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      maxLines: 3,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.selectedItemsList[colName] = '';
                    },
                    icon: Icon(
                      Icons.clear,
                      size: 15,
                      color: Theme.of(Get.context!).disabledColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
  }


  ///dropdown
  // showLookup(String colName, String title) {
  //   if (controller.lookupList.isEmpty) {
  //     return const RapidLoadingIndicator();
  //   } else if (controller.lookupList[colName] == null) {
  //     return const SizedBox();
  //   } else {
  //     return DropDownWidget(
  //       title: title,
  //       list: controller.lookupList[colName]!,
  //       hint: _textEditingController.text,
  //       onChanged: (selectedValue) {
  //         if (selectedValue == null) {
  //           controller.lookupValue[colName] = '';
  //         } else {
  //           controller.lookupValue[colName] = selectedValue.valueField;
  //           controller.checkValidation(
  //             changedValue: selectedValue.textField.toString(),
  //             valueField: selectedValue.valueField.toString(),
  //             colName: colName,
  //             dataType:
  //             controller.selectedTabColumnsList[indexList].mdcDatatype!,
  //           );
  //         }
  //       },
  //       controller: _textEditingController,
  //       editMode: controller.newEditMode,
  //       readOnly: controller.selectedTabColumnsList[indexList].mdcReadonly!,
  //     );
  //   }
  // }








}
