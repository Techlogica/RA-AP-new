import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/menu_advanced_search_grid/menu_detailed_advanced_search_grid_controller.dart';
import 'package:rapid_app/res/values/colours.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../../../widgets/app_bar/home_app_bar.dart';

class MenuDetailedAdvancedSearchGridPage
    extends GetView<MenuDetailedAdvancedSearchGridController> {
  const MenuDetailedAdvancedSearchGridPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBarWidget(
        title: '',
        leadingIcon: const Icon(
          Icons.arrow_back,
          color: colours.white,
          size: 25,
        ),
        onTapLeadingIcon: _backPress,
        actionIcon: Icons.close,
        onTapActionIcon: _backPress,
      ),
      body: _BodyWidget(),
    );
  }

  void _backPress() {
    int length = controller.advancedSearchList.length - 1;
    if (controller.advancedSearchList[length].operation!.isNotEmpty) {
      Get.back();
    } else {
      Get.back();
      Get.back();
    }
  }
}

class _BodyWidget extends GetView<MenuDetailedAdvancedSearchGridController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(top: 0),
      child: Container(
        padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: SfDataGridTheme(
                data: SfDataGridThemeData(
                    headerColor: Theme.of(Get.context!).backgroundColor,
                    rowHoverTextStyle: Theme.of(context).textTheme.headline1),
                child: SfDataGrid(
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  source: controller.listAdvancedSearchDetailedDataGridSource,
                  columns: _getColumns(),
                  allowSwiping: true,
                  swipeMaxOffset: 120,
                  startSwipeActionsBuilder: (context, row, rowIndex) {
                    return Row(
                      children: [
                        GestureDetector(
                          child: Container(
                            width: 60.0,
                            color: Theme.of(context).backgroundColor,
                            child: Center(
                              child: Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          onTap: () {
                            controller.onEdit(
                                controller.advancedSearchList[rowIndex],
                                rowIndex);
                            // _onUpdate(row, rowIndex);
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            width: 60.0,
                            color: Theme.of(context).backgroundColor,
                            child: Center(
                              child: Icon(
                                Icons.delete,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          onTap: () {
                            controller.onDeleteRow(row, rowIndex);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Expanded(
                flex: 0,
                child: Container(
                  color: Theme.of(context).backgroundColor,
                  height: 70,
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 50,
                    child: controller.isButtonClickLoader.value
                        ? SizedBox(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: controller.buttonsList.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: ElevatedButton(
                                  style: TextButton.styleFrom(
                                    //primary: Theme.of(context).backgroundColor,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    textStyle: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.onButtonClick(
                                        controller.buttonsList[index]);
                                  },
                                  child: Text(
                                    controller.buttonsList[index]
                                        .toString()
                                        .toUpperCase(),
                                  ),
                                ),
                              );
                            }),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  List<GridColumn> _getColumns() {
    return [
      GridColumn(
          columnName: 'open',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerRight,
              child: const Text(
                'Open Braces "("',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'fieldName',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Field Name',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'operator',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Operator',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'modifier',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerRight,
              child: const Text(
                'Modifier',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'value1',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerRight,
              child: const Text(
                'Value 1',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'value2',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerRight,
              child: const Text(
                'Value2',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'operation',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerRight,
              child: const Text(
                'And/Or',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'close',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerRight,
              child: const Text(
                'Close Braces ")"',
                overflow: TextOverflow.ellipsis,
              ))),
    ];
  }
}
