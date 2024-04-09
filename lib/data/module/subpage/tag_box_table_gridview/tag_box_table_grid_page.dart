import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/edit_text_field_widget.dart';
import 'package:rapid_app/data/module/subpage/tag_box_table_gridview/tag_box_table_grid_controller.dart';
import 'package:rapid_app/data/widgets/app_bar/app_bar_widget.dart';
import 'package:rapid_app/data/widgets/loading_indicator/loading_indicator_widget.dart';
import 'package:rapid_app/res/values/logs/logs.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'list_child_detailed_data_grid_source.dart';

class TagBoxTableGridPage extends GetView<TagBoxTableGridController> {
  const TagBoxTableGridPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: Text(
          '',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leadingIcon: Icons.arrow_back,
        onTapLeadingIcon: _backPress,
      ),
      body: _BodyWidget(),
    );
  }

  void _backPress() {
    Map<String, dynamic> bindFieldColVal = {};
    Get.back(result: {
      'tagBox': controller.tapBoxMap,
      'MDC_TEXTFIELDNAME': controller.textField.value,
      'BIND_COL_VAL': bindFieldColVal,
    });
  }
}

class _BodyWidget extends GetView<TagBoxTableGridController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(Get.context!).backgroundColor,
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(top: 0),
      child: Container(
        color: Theme.of(Get.context!).primaryColor,
        padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: EditTextFieldWidget(
                          controller: controller.searchController,
                          dataType: controller.dataType,
                          hint: controller.title,
                          editMode: '',
                          obscureText: false,
                          dateClick: () {},
                        ),
                      ),
                      Expanded(
                          flex: 0,
                          child: IconButton(
                              onPressed: () async => {
                                    controller.pageNumberMenuData = 10,
                                    controller.singleQueryDataLength = 0,
                                    await controller.filterTagBoxList(
                                        searchText:
                                            controller.searchController.text),
                                  },
                              icon: const Icon(
                                Icons.search,
                                size: 30,
                              )))
                    ],
                  ),
                )),
            Expanded(
              flex: 1,
              child: Container(
                color: Theme.of(Get.context!).cardColor,
                child: Obx(
                  () => SfDataGridTheme(
                    data: SfDataGridThemeData(
                      headerColor: Theme.of(Get.context!)
                          .bottomNavigationBarTheme
                          .backgroundColor,
                    ),
                    child: SfDataGrid(
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        source: ListChildDetailedDataGridSource(
                          rowData: controller.childColumnData,
                          columnData: controller.childRowData,
                          loadMore: controller.loadChildData,
                        ),
                        loadMoreViewBuilder:
                            (BuildContext context, LoadMoreRows loadMoreRows) {
                          Future<String> loadRows() async {
                            await loadMoreRows();
                            return Future<String>.value('Completed');
                          }

                          return FutureBuilder<String>(
                            initialData: 'loading',
                            future: loadRows(),
                            builder: (context, snapShot) {
                              if (snapShot.data == 'loading') {
                                return const RapidLoadingIndicator();
                              } else {
                                return SizedBox.fromSize(
                                  size: Size.zero,
                                );
                              }
                            },
                          );
                        },
                        columns: _getColumns(),
                        allowSwiping: false,
                        allowMultiColumnSorting: true,
                        allowSorting: true,
                        showSortNumbers: true,
                        selectionMode: SelectionMode.single,
                        controller: controller.dataGridController,
                        onSelectionChanged: (List<DataGridRow> addedRow,
                            List<DataGridRow> removedRow) {
                          final index =
                              controller.dataGridController.selectedIndex;
                          print(".....................index$index");
                          Map<String, dynamic> selectedMap =
                              controller.childColumnData[index];
                          print('....................seletcteMap$selectedMap');
                          for (var key in selectedMap.keys) {
                            print('....................seletctekey$key');
                            print(
                                '....................seletedmap${selectedMap.keys}');
                            print(
                                '.......................inside${controller.metadataColumnsResponse.mdcTextfieldname}');
                            print(
                                '.......................inside${controller.metadataColumnsResponse.mdcValuefieldname}');
                            if (key ==
                                    controller.metadataColumnsResponse
                                        .mdcTextfieldname ||
                                key == 'MTV_VALUEFLD') {
                              print('.......................insidekey$key');
                              controller.textField.value =
                                  selectedMap[key].toString();
                              debugPrint(
                                  ">>>>>>>>>>>>${controller.textField.value}");
                            }
                          }
                          controller.tapBoxMap.addAll(selectedMap);
                          Map<String, dynamic> bindFieldColVal = {};
                          for (int i = 0;
                              i < controller.childRowData.length;
                              ++i) {
                            if (controller.childRowData[i].bindFields != '') {
                              bindFieldColVal[
                                      controller.childRowData[i].bindFields] =
                                  controller.tapBoxMap[
                                      controller.childRowData[i].bindValues];
                            }
                            Logs.logData("bindFieldColVal:::",
                                bindFieldColVal.toString());
                          }
                          Get.back(result: {
                            'colName':
                                controller.metadataColumnsResponse.mdcColName,
                            'datatype':
                                controller.metadataColumnsResponse.mdcDatatype,
                            'tagBox': controller.tapBoxMap,
                            'MDC_TEXTFIELDNAME': controller.textField.value,
                            'BIND_COL_VAL': bindFieldColVal,
                          });
                          print(
                              "..............resultback:${controller.tapBoxMap}");
                          print(
                              "..............textresultback:${controller.textField.value}");
                          print(
                              "..............bindcolvalresultback:${controller.tapBoxMap}");
                          print(
                              '................colname${controller.metadataColumnsResponse.mdcColName}');
                          print(
                              '................datatype${controller.metadataColumnsResponse.mdcDatatype}');
                        }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<GridColumn> _getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      for (var element in controller.childRowData)
        GridColumn(
            columnName: element.valueField.toString(),
            columnWidthMode: ColumnWidthMode.auto,
            label: Container(
              padding: const EdgeInsets.only(left: 5),
              alignment: _isAlignment(element.dataType.toString()),
              child: Text(
                element.valueField.toString(),
                overflow: TextOverflow.clip,
                softWrap: true,
                style: TextStyle(
                    color: Theme.of(Get.context!)
                        .bottomNavigationBarTheme
                        .selectedItemColor),
              ),
            ))
    ];
    return columns;
  }

  _isAlignment(String? type) {
    switch (type) {
      case 'DECIMAL':
        return Alignment.centerRight;
      case 'STRING':
        return Alignment.centerLeft;
      case 'DATE':
        return Alignment.centerLeft;
      case 'INT':
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }
}
