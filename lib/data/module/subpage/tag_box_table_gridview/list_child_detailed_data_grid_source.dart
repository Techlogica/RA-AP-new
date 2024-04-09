import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rapid_app/data/model/tag_box_model/tag_box_column_response.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ListChildDetailedDataGridSource extends DataGridSource {
  ListChildDetailedDataGridSource({
    required List<dynamic> rowData,
    required List<TagBoxColumnResponse> columnData,
    required this.loadMore,
  }) {
    dataGridRows = rowData
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [for (var item in columnData) getGridDataCell(item, e)],
          ),
        )
        .toList();
  }

  DataGridCell<dynamic> getGridDataCell(TagBoxColumnResponse item, var e) {
    if (item.dataType == 'DATE' && e[item.columnName] != null) {
      DateTime dateTime = DateTime.parse(e[item.columnName].toString());
      return DataGridCell<dynamic>(
        columnName: item.valueField.toString(),
        value: DateFormat('dd-MMM-yyyy').format(dateTime),
      );
    } else {
      return DataGridCell<dynamic>(
        columnName: item.valueField.toString(),
        value: e[item.columnName] ?? '',
      );
    }
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  Future<void> Function() loadMore;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>(
      (e) {
        return Container(
          alignment: (e.value.runtimeType.toString() == 'double' ||
                  e.value.runtimeType.toString() == 'int')
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text(
            e.value.toString(),
          ),
        );
      },
    ).toList());
  }

  ///for loading
  @override
  Future<void> handleLoadMoreRows() async {
    await Future.delayed(const Duration(seconds: 1));
    loadMore();
    notifyListeners();
  }

  ///update DataSource
  void updateDataSource() {
    notifyListeners();
  }
}
