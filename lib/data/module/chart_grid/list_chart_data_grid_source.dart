import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ListChartDataGridSource extends DataGridSource {
  ListChartDataGridSource({
    required List<dynamic> gridData,
  }) {
    dynamic gridResponse = gridData[0];
    String resp = json.encode(gridResponse);
    Map<String, dynamic> jsonData = json.decode(resp);
    _rowData = gridData
        .map<DataGridRow>(
          (e) => DataGridRow(
        cells: [
          for (var item in jsonData.keys)
            DataGridCell<dynamic>(
              columnName: item.toString(),
              value: _gridValueType(e[item.toString()].toString()),
            ),
        ],
      ),
    ).toList();
  }

  List<DataGridRow> _rowData = [];

  @override
  List<DataGridRow> get rows => _rowData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
            (e) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(
              e.value.toString(),
            ),
          );
        },
      ).toList(),
    );
  }
}

String _gridValueType(String str) {
  try {
    if (DateTime.tryParse(str) != null) {
      DateTime date = DateTime.parse(str);
      return DateFormat('dd/MMM/yyyy').format(date);
    } else {
      return str;
    }
  } catch (e) {
    return str;
  }
}