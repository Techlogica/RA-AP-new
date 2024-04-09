import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rapid_app/data/model/metadata_columns_model/metadata_columns_response.dart';
import 'package:rapid_app/data/module/subpage/common/export/save_file_mobile.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/menu_detailed_qr_scanner_page/menu_detailed_scanner_page.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page/list_menu_detailed_data_grid_source.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page/menu_detailed_controller.dart';
import 'package:rapid_app/data/widgets/app_bar/home_app_bar.dart';
import 'package:rapid_app/data/widgets/bottom_bar/menu_bottom_bar_widget.dart';
import 'package:rapid_app/data/widgets/bottom_sheet/common_search_bottom_sheet_widget.dart';
import 'package:rapid_app/data/widgets/loading_indicator/loading_indicator_widget.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/colours.dart';
import 'package:rapid_app/res/values/strings.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Border;

class MenuDetailedPage extends GetView<MenuDetailedController> {
  MenuDetailedPage({Key? key}) : super(key: key);

  // key for side navigation
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final _advancedDrawerController = AdvancedDrawerController();
  final GlobalKey<FabCircularMenuPlusState> fabKey = GlobalKey();

  @override
  final String? tag = '${Get.arguments["MDT_SYS_ID"]}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      key: _drawerKey,
      appBar: HomeAppBarWidget(
        title: controller.menuTitle,
        leadingIcon: const Icon(
          Icons.arrow_back,
          size: 25,
          color: colours.white,
        ),
        onTapLeadingIcon: _backPress,
        actionIcon: Icons.search,
        onTapActionIcon: () {
          _alertBoxCommonSearch();
        },
      ),
      body: const _BodyWidget(),
      floatingActionButton: MenuBottomBarWidget(
        fabKey: fabKey,
        isInsert: controller.argumentData?['INSERT'] ?? '',
        onItemTap: _onItemTap,
      ),
    );
  }

  _onItemTap(int onTapIndex) {
    if (fabKey.currentState!.isOpen) {
      fabKey.currentState!.close();
    } else {
      fabKey.currentState!.open();
    }
    if (controller.argumentData['INSERT'] == 'N') {
      switch (onTapIndex) {
        case 0:
          _alertBoxCommonSearch();
          break;
        case 1:
          _gridSearch();
          break;
        case 2:
          _gridAdvancedSearch();
          break;
        case 3:
          _exportToExcel();
          break;
        case 4:
          _exportToPdf();
          break;
      }
    } else {
      switch (onTapIndex) {
        case 0:
          _addNewDetails();
          break;
        case 1:
          _alertBoxCommonSearch();
          break;
        case 2:
          _gridSearch();
          break;
        case 3:
          _gridAdvancedSearch();
          break;
        case 4:
          _exportToExcel();
          break;
        case 5:
          _exportToPdf();
          break;
      }
    }
  }

  void _gridSearch() async {
    final data = await Get.toNamed(
      Strings.kMenuDetailsSearchPage,
      arguments: {
        "MDT_SYS_ID": controller.sysId,
        "MENU_NAME": controller.menuName,
        "MENU_TITLE": controller.menuTitle,
        "MDT_DEFAULT_WHERE": controller.menuDefaultWhere,
        "KEY_INFO": controller.keyInfo,
      },
    );
    if (data != null) {
      String mode = data['mode'].toString();
      if (mode == Strings.kParamSearch) {
        List<dynamic> response = data['MENU_COL_DATA'];
        if (response.isNotEmpty) {
          controller.singleQueryDataLength = response.length;
          controller.menuData.clear();
          controller.menuData.addAll(response);
          controller.pageNumberMenuData += 15;
        }
      }
    }
  }

  // void _addNewDetails() async {
  //   final data = await Get.toNamed(
  //     Strings.kMenuDetailsNewEditPage,
  //     arguments: {
  //       "MDT_SYS_ID": controller.sysId,
  //       "MENU_NAME": controller.menuName,
  //       "MENU_TITLE": controller.menuTitle,
  //       "MDT_DEFAULT_WHERE": controller.menuDefaultWhere,
  //       "KEY_INFO": controller.keyInfo,
  //       Strings.kMode: Strings.kParamNew,
  //       "BUTTON_LIST": controller.parentButtonList,
  //       "PARENT_ROW": controller.parentRowData,
  //       "PARENT_TABLE": controller.argumentData['PARENT_TABLE'],
  //     },
  //   );
  //   if (data != null) {
  //     String mode = data['mode'].toString();
  //     dynamic sysId = data['sysId'];
  //     if (mode == Strings.kParamNew) {
  //       if (data.containsKey('MENU_COL_DATA') && data['MENU_COL_DATA'] != null) {
  //         List<dynamic> response = data['MENU_COL_DATA'];
  //         controller.selectedSysId = sysId.toString();
  //         controller.mode = mode.toString();
  //         controller.fetchMetadataSingleData(sysId, mode.toString(), response);
  //       } else {
  //         // Handle the case when 'MENU_COL_DATA' is missing or null
  //         // You may want to log an error or show a message to the user
  //       }
  //     }
  //   }
  // }

  void _addNewDetails() async {
    final data = await Get.toNamed(
      Strings.kMenuDetailsNewEditPage,
      arguments: {
        "MDT_SYS_ID": controller.sysId,
        "MENU_NAME": controller.menuName,
        "MENU_TITLE": controller.menuTitle,
        "MDT_DEFAULT_WHERE": controller.menuDefaultWhere,
        "KEY_INFO": controller.keyInfo,
        Strings.kMode: Strings.kParamNew,
        "BUTTON_LIST": controller.parentButtonList,
        "PARENT_ROW": controller.parentRowData,
        "PARENT_TABLE": controller.argumentData['PARENT_TABLE'],
      },
    );
    if (data != null) {
      String mode = data['mode'].toString();
      dynamic sysId = data['sysId'];
      if (mode == Strings.kParamNew) {
        List<dynamic> response = data['MENU_COL_DATA'];
        controller.selectedSysId = sysId.toString();
        controller.mode = mode.toString();
        controller.fetchMetadataSingleData(sysId, mode.toString(), response);
      }
    }
  }

  void _gridAdvancedSearch() async {
    final data = await Get.toNamed(
      Strings.kMenuAdvancedSearchPage,
      arguments: {
        "MDT_SYS_ID": controller.sysId,
        "MENU_NAME": controller.menuName,
      },
    );
    if (data != null) {
      String mode = data['mode'].toString();
      if (mode == Strings.kParamSearch) {
        List<dynamic> response = data['MENU_COL_DATA'];
        if (response.isNotEmpty) {
          controller.singleQueryDataLength = response.length;
          controller.menuData.clear();
          controller.menuData.addAll(response);
          controller.pageNumberMenuData += 15;
        }
      }
    }
  }

  Future<void> _exportToExcel() async {
    final Workbook workbook = controller.keyExport.currentState!
        .exportToExcelWorkbook(
            cellExport: (DataGridCellExcelExportDetails details) {
      if (details.cellType == DataGridExportCellType.columnHeader) {
        details.excelRange.cellStyle.hAlign = HAlignType.left;
      }
    });

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    String saveName = controller.menuTitle + '.xlsx';
    await saveAndLaunchFile(bytes, saveName);
  }

  Future<void> _exportToPdf() async {
    final PdfDocument document =
        controller.keyExport.currentState!.exportToPdfDocument(
            fitAllColumnsInOnePage: true,
            cellExport: (DataGridCellPdfExportDetails details) {
              if (details.cellType == DataGridExportCellType.row) {
                // if (details.columnName == 'Shipped Date') {
                //   details.pdfCell.value = DateFormat('MM/dd/yyyy')
                //       .format(DateTime.parse(details.pdfCell.value));
                // }
              }
            },
            headerFooterExport: (DataGridPdfHeaderFooterExportDetails details) {
              final double width = details.pdfPage.getClientSize().width;
              final PdfPageTemplateElement header =
                  PdfPageTemplateElement(Rect.fromLTWH(0, 0, width, 65));

              header.graphics.drawString(
                '${RapidPref().getProjectName()}\n${controller.menuTitle}',
                PdfStandardFont(PdfFontFamily.helvetica, 13,
                    style: PdfFontStyle.bold),
                bounds: const Rect.fromLTWH(0, 25, 200, 60),
              );

              details.pdfDocumentTemplate.top = header;
            });
    final List<int> bytes = await document.save();
    String saveName = controller.menuTitle + '.pdf';
    await saveAndLaunchFile(bytes, saveName);
    document.dispose();
  }

  void _alertBoxCommonSearch() {
    Get.bottomSheet(
      CommonSearchBottomSheetWidget(
        showScanner: true,
        onTextChange: () {},
        onScannerTap: () async => {
          if (!await Permission.camera.isGranted)
            {
              await Permission.camera.request(),
            },
          Get.to(() => MenuDetailedScannerPage())?.then((value) {
            // reset page number
            controller.pageNumberMenuData = 10;
            controller.singleQueryDataLength = 0;
            // clear listed data
            controller.menuData.clear();
            controller.controllerCommonSearch.text = value;
            controller.loadMenuData();
            controller.controllerCommonSearch.text = '';
          })
        },
        onTap: () => {
          // reset page number
          controller.pageNumberMenuData = 10,
          controller.singleQueryDataLength = 0,
          // clear listed data
          controller.menuData.clear(),
          // load new data
          controller.loadMenuData(),
          Get.back(),
        },
        controller: controller.controllerCommonSearch,
      ),
      enableDrag: true,
    );
  }

  onLeadingIconTap() {
    _advancedDrawerController.showDrawer();
  }

  void _backPress() {
    Get.back();
  }
}

class _BodyWidget extends GetView<MenuDetailedController> {
  const _BodyWidget({Key? key}) : super(key: key);

  /// Determine to decide whether the device in landscape or in portrait
  final bool isLandscapeInMobileView = false;

  @override
  get tag => '${Get.arguments["MDT_SYS_ID"]}';

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: SizedBox(
        child: Obx(
          () => Opacity(
            opacity: 1,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(
                        headerColor:
                            Theme.of(Get.context!).colorScheme.background,
                        rowHoverTextStyle:
                            Theme.of(context).textTheme.displayLarge),
                    child: SfDataGrid(
                      key: controller.keyExport,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      source: ListMenuDetailedDataGridSource(
                        rowData: controller.menuData,
                        columnData: controller.selectedMenuColumns,
                        loadMore: controller.loadMenuData,
                        clearData: controller.clearGridData,
                        columnPopup: (String colName, String value) {
                          return controller.selectedColumnPopup(colName, value);
                        },
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
                              return SizedBox.fromSize(size: Size.zero);
                            }
                          },
                        );
                      },
                      tableSummaryRows: _getSummaryColumns(),
                      columns: _getColumns(),
                      allowSorting: true,
                      allowPullToRefresh: true,
                      allowMultiColumnSorting: true,
                      showSortNumbers: true,
                      allowSwiping: controller.argumentData['UPDATE'] == 'Y' ||
                              controller.argumentData['DELETE'] == 'Y'
                          ? true
                          : false,
                      swipeMaxOffset:
                          controller.argumentData['UPDATE'] == 'Y' &&
                                  controller.argumentData['DELETE'] == 'Y'
                              ? 120.0
                              : 60.0,
                      startSwipeActionsBuilder: (context, row, rowIndex) {
                        return Row(
                          children: [
                            if (controller.argumentData['UPDATE'] == 'Y')
                              GestureDetector(
                                child: Container(
                                  width: 60.0,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  child: Center(
                                    child: Icon(
                                      Icons.edit,
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  _onEdit(controller.menuData[rowIndex]);
                                  // _onUpdate(row, rowIndex);
                                },
                              ),
                            if (controller.argumentData['DELETE'] == 'Y')
                              GestureDetector(
                                child: Container(
                                  width: 60.0,
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .color,
                                  child: Center(
                                    child: Icon(
                                      Icons.delete,
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  _onDelete(row, rowIndex);
                                },
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<GridTableSummaryRow> _getSummaryColumns() {
    List<MetadataColumnsResponse> tableData = controller.selectedMenuColumns;
    List<GridTableSummaryRow> rows;
    rows = <GridTableSummaryRow>[
      GridTableSummaryRow(
        color: Theme.of(Get.context!).cardColor,
        showSummaryInRow: false,
        columns: [
          for (var element in tableData)
            if (element.mdcSummaryType != null)
              GridSummaryColumn(
                name: element.mdcShowincoloumn.toString(),
                columnName: element.mdcShowincoloumn.toString() == 'ACTION'
                    ? tableData[0].mdcMetatitle
                    : element.mdcShowincoloumn.toString(),
                summaryType: _isSummeryType(element.mdcSummaryType),
              ),
        ],
        position: GridTableSummaryRowPosition.bottom,
      ),
    ];
    return rows;
  }

  _isSummeryType(int? typeNumber) {
    switch (typeNumber) {
      case 1:
        return GridSummaryType.sum;
      case 2:
        return GridSummaryType.maximum;
      case 3:
        return GridSummaryType.minimum;
      case 4:
        return GridSummaryType.average;
      case 5:
        return GridSummaryType.count;
    }
  }

  List<GridColumn> _getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      for (var element in controller.selectedMenuColumns)
        GridColumn(
          columnName: element.mdcMetatitle.toString(),
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          label: Container(
            padding: const EdgeInsets.only(left: 5),
            alignment: _isAlignment(element.mdcDatatype),
            child: Text(
              element.mdcMetatitle.toString(),
              overflow: TextOverflow.clip,
              softWrap: true,
              style: TextStyle(
                  color: Theme.of(Get.context!)
                      .bottomNavigationBarTheme
                      .selectedItemColor),
            ),
          ),
        ),
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

  void _onDelete(DataGridRow row, int rowIndex) {
    controller.menuDataGridSource = ListMenuDetailedDataGridSource(
      rowData: controller.menuData,
      columnData: controller.selectedMenuColumns,
      loadMore: controller.loadMenuData,
      clearData: controller.clearGridData,
    );
    dynamic deleteData = controller.menuData[rowIndex];
    String rowId = deleteData[controller.keyInfo].toString();

    // remove row from menu data
    controller.removeGridRow(rowIndex: rowIndex, rowId: rowId);
    // refresh grid source
    // controller.menuDataGridSource.updateDataSource();
  }

  void _onEdit(dynamic editData) async {
    for (int i = 0; i < controller.metadataColumnsTable.length; ++i) {
      if (controller.metadataColumnsTable[i].mdcDatatype == 'INT' ||
          controller.metadataColumnsTable[i].mdcDatatype == 'CHECKBOX') {
        String value =
            editData[controller.metadataColumnsTable[i].mdcColName].toString();
        if (value != '') {
          var arr = value.split('.').first;
          value = arr.toString();
        }
        editData[controller.metadataColumnsTable[i].mdcColName] = value;
      }
    }
    final data = await Get.toNamed(
      Strings.kMenuDetailsNewEditPage,
      arguments: {
        "MDT_SYS_ID": controller.sysId,
        "MENU_NAME": controller.menuName,
        "MENU_TITLE": controller.menuTitle,
        "MDT_DEFAULT_WHERE": controller.menuDefaultWhere,
        "KEY_INFO": controller.keyInfo,
        Strings.kMode: Strings.kParamEdit,
        "EDIT_DATA": editData,
        "BUTTON_LIST": controller.parentButtonList,
        "PARENT_ROW": controller.parentRowData,
        "PARENT_TABLE": controller.argumentData['PARENT_TABLE'],
      },
    );
    if (data != null) {
      String mode = data['mode'].toString();
      dynamic sysId = data['sysId'];
      if (mode == Strings.kParamEdit) {
        controller.selectedSysId = sysId.toString();
        controller.mode = mode.toString();
        List<dynamic> response = data['MENU_COL_DATA'];
        controller.fetchMetadataSingleData(sysId, mode.toString(), response);
      }
    }
  }
}
