import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_new_edit/menu_details_new_edit_controller.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/check_box_widget.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/edit_text_field_widget.dart';
import 'package:rapid_app/data/widgets/image/image_picker_widget.dart';
import 'package:rapid_app/res/values/logs/logs.dart';
import '../../../../../res/utils/dynamic_default_value_generation/combo_concatenate.dart';
import '../../../../widgets/loading_indicator/loading_indicator_widget.dart';
import '../../menu_detailed_page_search/search_widgets/drop_down_widget.dart';
import '../../menu_detailed_page_search/search_widgets/invoide_add_search_item_page/invoice_add_search_item_page.dart';

class NewEditWidget extends GetView<MenuDetailsNewEditController> {
  const NewEditWidget({
    Key? key,
    required this.width,
    required TextEditingController textEditingController,
    required this.indexList,
  })  : _textEditingController = textEditingController,
        super(key: key);
  final int indexList;
  final TextEditingController _textEditingController;

  final double width;

  @override
  // TODO: implement tag
  String? get tag => '${Get.arguments["MDT_SYS_ID"]}';

  @override
  Widget build(BuildContext context) {
    MenuDetailsNewEditController controller =
        Get.put(MenuDetailsNewEditController());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: _showWidget(),
      ),
    );
  }

  _showWidget() {
    String title = controller.selectedTabColumnsList[indexList].mdcMetatitle;
    String colName = controller.selectedTabColumnsList[indexList].mdcColName;
    String dataType = controller.selectedTabColumnsList[indexList].mdcDatatype!;
    controller.colName.value = colName;

    /// check required fields and add *
    if (controller.requiredDataList
        .any((element) => element.contains(colName))) {
      title = title + '*';
    }

    /// decrypt value
    // fetchEncryptValue();
    switch (dataType) {
      case 'CHECKBOXSTR':
        String fieldName =
            controller.selectedTabColumnsList[indexList].mdcColName.toString();
        if (_textEditingController.text == null ||
            _textEditingController.text.isEmpty) {
          _textEditingController.text = 'N';
        }
        return Obx(
          () => CheckBoxWidget(
            hint: title,
            isChecked: controller.checkBoxList[fieldName] == null
                ? false
                : _textEditingController.text == 'Y',
            onChanged: (newValue) {
              debugPrint("..................$newValue");
              controller.checkBoxList[fieldName] = newValue ?? false;
              if (controller.checkBoxList[fieldName]!) {
                _textEditingController.text = 'Y';
              } else {
                _textEditingController.text = 'N';
              }
              controller.checkValidation(
                changedValue: _textEditingController.text,
                valueField: _textEditingController.text,
                colName: colName,
                dataType:
                    controller.selectedTabColumnsList[indexList].mdcDatatype!,
              );
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
                : _textEditingController.text == '1',
            onChanged: (newValue) {
              controller.checkBoxList[fieldName] = newValue ?? false;
              if (controller.checkBoxList[fieldName]!) {
                _textEditingController.text = '1';
              } else {
                _textEditingController.text = '0';
              }
              controller.checkValidation(
                changedValue: _textEditingController.text,
                valueField: _textEditingController.text,
                colName: colName,
                dataType:
                    controller.selectedTabColumnsList[indexList].mdcDatatype!,
              );
            },
          ),
        );

      case 'LOOKUP':
        // return Obx(() => showLookup(colName, title));
        debugPrint(
            "....................Sftaboxcolname${controller.selectedTabColumnsList[indexList].mdcColName}");
        debugPrint(
            "....................Sftabox${controller.selectedTabColumnsList[indexList].mdcTextfieldname}");
        tagboxValue(
          controller.selectedTabColumnsList[indexList],
          _textEditingController,
        );
        return Obx(() => Padding(
              padding: const EdgeInsets.only(top: 17.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        EditTextFieldWidget(
                          controller: _textEditingController,
                          dataType: controller
                              .selectedTabColumnsList[indexList].mdcDatatype!,
                          readOnly: controller
                              .selectedTabColumnsList[indexList].mdcReadonly,
                          encryptType: controller
                              .selectedTabColumnsList[indexList].mdcEncrypt,
                          hint: title,
                          editMode: controller.newEditMode,
                          keyInfo: '',
                          obscureText: false,
                          dateClick: () {},
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            // onPressed: () => controller.getChildTable(
                            //     indexList,
                            //     _textEditingController,
                            //     controller.selectedTabColumnsList[indexList].mdcColName,
                            //     controller.selectedTabColumnsList[indexList].mdcValuefieldname),
                            icon: Icon(
                              Icons.add,
                              size: 25,
                              color: Theme.of(Get.context!).backgroundColor,
                            ),
                            onPressed: () {
                              controller.getChildTable(
                                  indexList,
                                  _textEditingController,
                                  controller.selectedTabColumnsList[indexList]
                                      .mdcColName,
                                  'MTV_VALUEFLD'
                                  // controller.selectedTabColumnsList[indexList].mdcValuefieldname,
                                  );

                              print(
                                  "///////////////////${controller.selectedTabColumnsList[indexList].mdcValuefieldname}");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      case 'IMAGE':
        if (_textEditingController.text == 'null') {
          _textEditingController.value = const TextEditingValue(text: '');
        }
        controller.imageValue[colName] = _textEditingController.text;
        return ImagePickerWidget(
            isEnable: controller.isLocation.value,
            image: controller.imageValue[colName] ?? '',
            onTap: () async {
              FilePickerResult? pickedImage =
                  await controller.filePicker(FileType.custom);
              if (pickedImage != null) {
                _textEditingController.text = pickedImage.files.single.path!;
                controller.imageValue[colName] = _textEditingController.text;
              }
            },
            title: title);

      case 'DOC':
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: EditTextFieldWidget(
                enabled: controller.isLocation.value,
                controller: _textEditingController,
                dataType:
                    controller.selectedTabColumnsList[indexList].mdcDatatype!,
                readOnly:
                    controller.selectedTabColumnsList[indexList].mdcReadonly,
                encryptType:
                    controller.selectedTabColumnsList[indexList].mdcEncrypt,
                hint: title,
                editMode: controller.newEditMode,
                keyInfo:
                    controller.selectedTabColumnsList[indexList].mdcKeyinfo,
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
                    _textEditingController.text = pickedFile.files.single.path!;
                    controller.fileValue[title] = pickedFile.files.single.path!;
                  }
                },
                icon: Icon(
                  Icons.file_copy_outlined,
                  size: 25,
                  color: Theme.of(Get.context!).backgroundColor,
                ),
              ),
            ),
          ],
        );

      case 'LOCATION':
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: EditTextFieldWidget(
                enabled: controller.isLocation.value,
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
                onPressed: () =>
                    controller.getLocation(indexList, _textEditingController),
                icon: Icon(
                  Icons.location_on_outlined,
                  size: 30,
                  color: Theme.of(Get.context!).backgroundColor,
                ),
              ),
            ),
          ],
        );

      case 'TAGBOX':
        tagboxValue(
          controller.selectedTabColumnsList[indexList],
          _textEditingController,
        );
        return Padding(
          padding: const EdgeInsets.only(top: 17.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    EditTextFieldWidget(
                      controller: _textEditingController,
                      dataType: controller
                          .selectedTabColumnsList[indexList].mdcDatatype!,
                      readOnly: controller
                          .selectedTabColumnsList[indexList].mdcReadonly,
                      encryptType: controller
                          .selectedTabColumnsList[indexList].mdcEncrypt,
                      hint: title,
                      editMode: controller.newEditMode,
                      keyInfo: '',
                      obscureText: false,
                      dateClick: () {},
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          controller.getChildTable(
                              indexList,
                              _textEditingController,
                              controller
                                  .selectedTabColumnsList[indexList].mdcColName,
                              controller.selectedTabColumnsList[indexList]
                                  .mdcValuefieldname);
                          print(
                              "...........selecttab${controller.selectedTabColumnsList[indexList]}");
                        },
                        icon: Icon(
                          Icons.search,
                          size: 25,
                          color: Theme.of(Get.context!).backgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 'SFTAGBOX':
        tagboxValue(
          controller.selectedTabColumnsList[indexList],
          _textEditingController,
        );
        return Padding(
          padding: const EdgeInsets.only(top: 17.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    EditTextFieldWidget(
                      controller: _textEditingController,
                      dataType: controller
                          .selectedTabColumnsList[indexList].mdcDatatype!,
                      readOnly: controller
                          .selectedTabColumnsList[indexList].mdcReadonly,
                      encryptType: controller
                          .selectedTabColumnsList[indexList].mdcEncrypt,
                      hint: title,
                      editMode: controller.newEditMode,
                      keyInfo: '',
                      obscureText: false,
                      dateClick: () {},
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () => controller.getChildTable(
                          indexList,
                          _textEditingController,
                          controller
                              .selectedTabColumnsList[indexList].mdcColName,
                          controller.selectedTabColumnsList[indexList]
                              .mdcValuefieldname,
                        ),
                        icon: Icon(
                          Icons.search,
                          size: 25,

                          ///original size 25
                          color: Theme.of(Get.context!).backgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      ///title of the add vab sales order textfeild
      default:
        return Obx(
          () => Padding(
            padding: const EdgeInsets.only(top: 17.0),
            child: EditTextFieldWidget(
              hint: title,
              controller: _textEditingController,
              dataType:
                  controller.selectedTabColumnsList[indexList].mdcDatatype!,
              readOnly:
                  controller.selectedTabColumnsList[indexList].mdcReadonly,
              displayFormat:
                  controller.selectedTabColumnsList[indexList].mdcDispFormat,
              encryptType:
                  controller.selectedTabColumnsList[indexList].mdcEncrypt,
              iconVisible:
                  controller.selectedTabColumnsList[indexList].mdcEncbtnVisble,
              editMode: controller.newEditMode,
              keyInfo: controller.selectedTabColumnsList[indexList].mdcKeyinfo,
              obscureText: controller.isObscureMap[colName] ?? true,
              obscureClick: () {
                bool isObscure = controller.isObscureMap[colName] ?? true;
                isObscure = !isObscure;
                controller.isObscureMap[colName] = isObscure;
                if (controller.selectedTabColumnsList[indexList].mdcEncrypt ==
                    'Y') {
                  controller.selectedTabColumnsList[indexList].mdcEncrypt = 'N';
                } else {
                  controller.selectedTabColumnsList[indexList].mdcEncrypt = 'Y';
                }
              },
              dateClick: () {
                String value = _textEditingController.text;
                debugPrint('............value$value');
                controller.checkValidation(
                  changedValue: _textEditingController.text,
                  colName: colName,
                  dataType:
                      controller.selectedTabColumnsList[indexList].mdcDatatype!,
                  valueField: value,
                );
              },
              onValueChanged: (value) {
                controller.checkValidation(
                  changedValue: value,
                  colName: colName,
                  dataType:
                      controller.selectedTabColumnsList[indexList].mdcDatatype!,
                  valueField: value,
                );
              },
            ),
          ),
        );
    }
  }

  ///****************************************************************************///
  Future<void> fetchEncryptValue() async {
    if (controller.selectedTabColumnsList[indexList].mdcEncrypt == 'Y') {
      dynamic value =
          await controller.encryptValue(indexList, _textEditingController.text);
      Logs.logData("value::::", value.toString());
      _textEditingController.text = value.toString();
    }
  }

  void tagboxValue(
    dynamic columnList,
    TextEditingController _controller,
  ) async {
    debugPrint("tagboxcolname:${columnList.mdcColName}");
    debugPrint("tagboxcomboqry:${columnList.mdcComboqry}");
    debugPrint("tagboxTextfeild:${columnList.mdcTextfieldname}");
    debugPrint("tagboxvaluefeild:${columnList.mdcValuefieldname}");
    debugPrint("tagboxcomboqrywhere:${columnList.mdcCombowhere}");
    String tagboxValue = await controller.getTagboxValue(
      comboQry: columnList.mdcComboqry,
      comboWhere: columnList.mdcCombowhere,
      value: _controller.text,
      textField: columnList.mdcTextfieldname,
      valueField: columnList.mdcValuefieldname,
      columnName: columnList.mdcColName,
    );
    String convertedWhere = await comboConcatenate(
      fformula: columnList.mdcCombowhere,
      obj: controller.columnsValueMap,
      ptbName: controller.metaTableName,
    );
    _controller.value = TextEditingValue(text: tagboxValue);
    print("////////////////////controllerValue::${_controller.text}");
  }

  // void lookUpValue(
  //     dynamic columnList,
  //     TextEditingController _controller,
  //     ) async {
  //   debugPrint("lookupboxcolname:${columnList.mdcColName}");
  //   debugPrint("lookupboxcomboqry:${columnList.mdcComboqry}");
  //   debugPrint("lookupboxTextfeild:${columnList.mdcTextfieldname}");
  //   debugPrint("lookupboxvaluefeild:${columnList.mdcValuefieldname}");
  //   debugPrint("lookupboxcomboqrywhere:${columnList.mdcCombowhere}");
  //   String tagboxValue = await controller.getlookupValue(
  //     comboQry: columnList.mdcComboqry,
  //     comboWhere: columnList.mdcCombowhere,
  //     value: _controller.text,
  //     textField: columnList.mdcTextfieldname,
  //     valueField: columnList.mdcValuefieldname,
  //     columnName: columnList.mdcColName,
  //   );
  //   String convertedWhere = await comboConcatenate(
  //       fformula: columnList.mdcCombowhere,
  //       obj: controller.columnsValueMap,
  //       ptbName: controller.metaTableName,
  //       tagTextValue: tagboxValue
  //   );
  //   _controller.value = TextEditingValue(text: tagboxValue);
  //   debugPrint("////////////////////controllerValue::${_controller.text}");
  // }

  ///*************************************************///

  /// lookup case
  Widget showLookup(String colName, String title) {
    if (controller.lookupList.isEmpty) {
      return const RapidLoadingIndicator();
    } else if (controller.lookupList[colName] == null) {
      return const SizedBox();
    } else {
      return InkWell(
        onTap: () async {
          print(
              "....................lookuplist:${jsonEncode(controller.lookupList)}");
          var value =
              await Get.to(() => const InvoiceAddSearchItemPage(), arguments: {
            "lookupList": controller.lookupList,
            'colName': colName,
            'title': title,
          });
          if (value != null &&
              value is Map &&
              value.containsKey('selectedItem')) {
            _textEditingController.text =
                "${value['selectedItem'].valueField} : ${value['selectedItem'].textField}";
            controller.selectedItemsList[colName] = _textEditingController.text;
            debugPrint("testing:${controller.selectedItemsList[colName]}");
            controller.checkValidation(
              changedValue: value['selectedItem'].textField.toString(),
              valueField: value['selectedItem'].valueField.toString(),
              colName: colName,
              dataType:
                  controller.selectedTabColumnsList[indexList].mdcDatatype!,
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
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
                    child: TextField(
                      controller: _textEditingController,
                      readOnly: true,
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                      decoration: InputDecoration(
                        // hintText: controller.selectedItemsList[colName] ?? '',
                        //   hintText: _textEditingController.text,
                        hintStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Roboto',
                        ),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.selectedItemsList[colName] = '';
                            _textEditingController.text = '';
                          },
                          icon: Icon(
                            Icons.clear,
                            size: 15,
                            color: Theme.of(Get.context!).disabledColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  ///drop down
  //   showLookup(String colName, String title) {
  //     if (controller.lookupList.isEmpty) {
  //       return const RapidLoadingIndicator();
  //     } else if (controller.lookupList[colName] == null) {
  //       return const SizedBox();
  //     } else {
  //       return DropDownWidget(
  //         title: title,
  //         list: controller.lookupList[colName]!,
  //         hint: _textEditingController.text,
  //         onChanged: (selectedValue) {
  //           if (selectedValue == null) {
  //             controller.lookupValue[colName] = '';
  //           } else {
  //             controller.lookupValue[colName] = selectedValue.valueField;
  //             controller.checkValidation(
  //               changedValue: selectedValue.textField.toString(),
  //               valueField: selectedValue.valueField.toString(),
  //               colName: colName,
  //               dataType:
  //               controller.selectedTabColumnsList[indexList].mdcDatatype!,
  //             );
  //           }
  //         },
  //         controller: _textEditingController,
  //         editMode: controller.newEditMode,
  //         readOnly: controller.selectedTabColumnsList[indexList].mdcReadonly!,
  //       );
  //     }
  //   }
}

// void getImageValue(
//   TextEditingController _controller,
// ) async {
//   String encryptedImage = _controller.text.toString();
//   String fileName =
//       encryptedImage.substring(encryptedImage.lastIndexOf('/') + 1);
//   var fName = fileName.split('.');
//   fileName = fName[0];
//   Logs.logData("fileName:::::::::::::::", fileName);
//
//   Uint8List bytes = (await NetworkAssetBundle(Uri.parse(encryptedImage))
//       .load(encryptedImage))
//       .buffer
//       .asUint8List();
//
//   // io.File file = io.File(encryptedImage);
//   // List<int> bytes = utf8.encode(encryptedImage);
//   String base64image = base64Encode(bytes);
//   Logs.logData("base64image!!:::::::::::::::::::::::::::::::", base64image);
//   String decryptValue = await AesEncryption().decrypt(base64image, fileName);
//   Logs.logData("decryptValue!!:::::::::::::::::::::::::::::::", '----'+fileName+'----'+decryptValue);
//   _controller.value = TextEditingValue(text: decryptValue);
// }
// }
