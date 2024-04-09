import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rapid_app/data/model/metadata_columns_model/metadata_columns_response.dart';
import 'package:rapid_app/data/widgets/text/text_widget.dart';
import 'package:rapid_app/res/values/colours.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ListMenuDetailedDataGridSource extends DataGridSource {
  ListMenuDetailedDataGridSource({
    required List<dynamic> rowData,
    required List<MetadataColumnsResponse> columnData,
    required this.loadMore,
    required this.clearData,
    this.columnPopup,
  }) {
    dataGridRows = rowData
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              for (var item in columnData) getGridDataCell(item, e),
            ],
          ),
        )
        .toList();
  }

  DataGridCell<dynamic> getGridDataCell(MetadataColumnsResponse item, var e) {
    if (item.mdcDatatype == 'DATE' && e[item.mdcColName] != null) {
      DateTime date = DateTime.parse(e[item.mdcColName].toString());
      if (e[item.mdcDispFormat] != null) {
        return DataGridCell<dynamic>(
          columnName: item.mdcMetatitle.toString(),
          value: DateFormat(e[item.mdcDispFormat]).format(date),
        );
      } else {
        return DataGridCell<dynamic>(
          columnName: item.mdcMetatitle.toString(),
          value: DateFormat('dd/MMM/yyyy').format(date),
          // value: DateFormat('dd/MMM/yyyy HH:mm:ss').format(date),
        );
      }
    } else if (item.mdcDatatype == 'INT') {
      String value = e[item.mdcColName].toString() ?? '';
      if (value != '') {
        var arr = value.split('.').first;
        value = arr.toString();
      }
      return DataGridCell<dynamic>(
        columnName: item.mdcMetatitle.toString(),
        value: value,
      );
    } else {
      return DataGridCell<dynamic>(
        columnName: item.mdcMetatitle.toString(),
        value: e[item.mdcColName] ?? '',
      );
    }
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  Future<void> Function() loadMore;

  Future<void> Function() clearData;

  Future<void> Function(String, String)? columnPopup;

  // for summary
  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 5),
      child: TextWidget(
          text: (summaryColumn == null)
              ? ''
              : (summaryColumn.summaryType
                          .toString()
                          .replaceAll('GridSummaryType.', ''))
                      .toUpperCase() +
                  ":" +
                  summaryValue,
          textSize: 15,
          textColor: colours.black),
    );
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (e) {
          return InkWell(
            onTap: () {
              String tempVal =
                  e.value.toString() == 'null' ? '' : e.value.toString();
              columnPopup!(e.columnName,tempVal);
            },
            child: Container(
              alignment: (e.value.runtimeType.toString() == 'double' ||
                      e.value.runtimeType.toString() == 'int')
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Text(
                e.value.toString() == 'null' ? '' : e.value.toString(),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  /// for loading (pagination)
  @override
  Future<void> handleLoadMoreRows() async {
    await Future.delayed(const Duration(seconds: 1));
    loadMore();
    notifyListeners();
  }

  /// Update DataSource
  void updateDataSource() {
    notifyListeners();
  }
  /// Pull to refresh to clear the grid data
  @override
  Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 3));
    clearData();
    notifyListeners();
  }
}
