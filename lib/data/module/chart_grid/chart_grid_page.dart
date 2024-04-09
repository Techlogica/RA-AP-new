import 'dart:convert';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/chart_grid/chart_grid_controller.dart';
import 'package:rapid_app/data/module/chart_grid/list_chart_data_grid_source.dart';
import 'package:rapid_app/data/module/subpage/common/export/save_file_mobile.dart';
import 'package:rapid_app/data/widgets/app_bar/home_app_bar.dart';
import 'package:rapid_app/data/widgets/bottom_bar/chart_grid_bottom_bar_widget.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/colours.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Alignment, Column, Row, Border;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ChartGridPage extends GetView<ChartGridController> {
   ChartGridPage({Key? key}) : super(key: key);

  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBarWidget(
        title: controller.chartTable[0].cChartName.toString(),
        leadingIcon: const Icon(
          Icons.arrow_back,
          size: 25,
          color: colours.white,
        ),
        onTapLeadingIcon: _backPress,
      ),
      body: _BodyWidget(),
      floatingActionButton: ChartGridBottomBarWidget(
        fabKey: fabKey,
        onItemTap: _onItemTap,
      ),
    );
  }

  _onItemTap(int onTapIndex) {
    if (fabKey.currentState!.isOpen) {
      fabKey.currentState!.close();
    }  else {
      fabKey.currentState!.open();
    }
    switch (onTapIndex) {
      case 0:
        _backPress();
        break;
      case 1:
        _exportToExcel();
        break;
      case 2:
        _exportToPdf();
        break;
      case 3:
        controller.imageShare();
        break;
    }
  }

  void _backPress() {
    Get.back();
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
    String saveName = controller.chartTable[0].cChartName.toString() + '.xlsx';
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
                RapidPref().getProjectName().toString() +
                    '\n' +
                    controller.chartTable[0].cChartName.toString(),
                PdfStandardFont(PdfFontFamily.helvetica, 13,
                    style: PdfFontStyle.bold),
                bounds: const Rect.fromLTWH(0, 25, 200, 60),
              );

              details.pdfDocumentTemplate.top = header;
            });
    final List<int> bytes = await document.save();
    String saveName = controller.chartTable[0].cChartName.toString() + '.pdf';
    await saveAndLaunchFile(bytes, saveName);
    document.dispose();
  }
}

class _BodyWidget extends GetView<ChartGridController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).backgroundColor,
      // padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
      alignment: Alignment.topLeft,
      child: Screenshot(
        controller: controller.screenshotController,
        child: Obx(
          () {
            if (controller.chartGridData.isEmpty &&
                controller.isIndicatorVisibility.value) {

              return SizedBox(
                width: double.infinity,
                height: 50,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).textTheme.subtitle2!.color,
                  ),
                ),
              );
            } else {
              return SfDataGridTheme(
                data: SfDataGridThemeData(
                headerColor: Theme.of(Get.context!).backgroundColor),
                child: SfDataGrid(
                  key: controller.keyExport,
                  columnWidthMode: ColumnWidthMode.auto,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  columns: _getColumns(),
                  source: ListChartDataGridSource(
                  gridData: controller.chartGridData,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  List<GridColumn> _getColumns() {
    List<GridColumn> columns;
    dynamic gridResponse = controller.chartGridData[0];
    String resp = json.encode(gridResponse);
    Map<String, dynamic> jsonData = json.decode(resp);
    columns = <GridColumn>[
      for (var element in jsonData.keys)
        GridColumn(
          columnName: element.toString(),
          columnWidthMode: ColumnWidthMode.auto,
          label: Container(
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.center,
            child: Text(
              element.toString(),
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
}
