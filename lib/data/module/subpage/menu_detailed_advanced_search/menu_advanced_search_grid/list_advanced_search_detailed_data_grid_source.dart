import 'package:flutter/material.dart';
import 'package:rapid_app/data/model/advanced_search_model/advanced_search_child_response.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ListAdvancedSearchDetailedDataGridSource extends DataGridSource {
  ListAdvancedSearchDetailedDataGridSource({
    required List<AdvancedSearchChildModel> rowData,
  }) {
    dataGridRows = rowData
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'open', value: e.open),
              DataGridCell<String>(columnName: 'fieldNam', value: e.fieldName),
              DataGridCell<String>(columnName: 'operator', value: e.operator),
              DataGridCell<String>(columnName: 'modifier', value: e.modifier),
              DataGridCell<String>(columnName: 'value1', value: e.value1),
              DataGridCell<String>(columnName: 'value2', value: e.value2),
              DataGridCell<String>(columnName: 'operation', value: e.operation),
              DataGridCell<String>(columnName: 'close', value: e.close),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
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
    }).toList());
  }

  /// Update DataSource
  void updateDataSource() {
    notifyListeners();
  }
}
