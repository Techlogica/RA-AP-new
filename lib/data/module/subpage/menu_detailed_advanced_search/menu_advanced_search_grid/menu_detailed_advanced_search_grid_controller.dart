import 'dart:convert';
import 'package:get/get.dart';
import 'package:rapid_app/data/model/advanced_search_model/advanced_search_child_response.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_advanced_search/menu_advanced_search_grid/list_advanced_search_detailed_data_grid_source.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';
import 'package:rapid_app/res/values/logs/logs.dart';
import 'package:rapid_app/res/values/strings.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MenuDetailedAdvancedSearchGridController extends RapidController {
  dynamic arguments = Get.arguments;
  RxList<AdvancedSearchChildModel> advancedSearchList = RxList([]);
  late int tableId;
  late String tableName;
  late ListAdvancedSearchDetailedDataGridSource listAdvancedSearchDetailedDataGridSource;
  List<String> buttonsList = ['Search', 'Search All', 'Close'];

  Rx<bool> isButtonClickLoader = false.obs;

  onButtonClick(String data) {
    if (data == 'Close') {
      Get.back();
      Get.back();
    } else if (data == 'Search') {
      if (advancedSearchList.isNotEmpty) {
        generateQuery();
      }
    } else if (data == 'Search All') {
      if (advancedSearchList.isNotEmpty) {
        generateQuery();
      }
    }
  }

  @override
  onInit() {
    advancedSearchList = arguments['search_query'];
    tableId = arguments['MDT_SYS_ID'];
    tableName = arguments['MENU_NAME'];
    listAdvancedSearchDetailedDataGridSource =
        ListAdvancedSearchDetailedDataGridSource(rowData: advancedSearchList);
    super.onInit();
  }

  void onDeleteRow(DataGridRow row, int rowIndex) {
    // remove row
    advancedSearchList.removeAt(rowIndex);
    listAdvancedSearchDetailedDataGridSource.dataGridRows.removeAt(rowIndex);
    // refresh grid source
    listAdvancedSearchDetailedDataGridSource.updateDataSource();
  }

  void onEdit(dynamic editData, int index) async {
    Get.back(result: {
      'edit_query': editData,
      'index': index,
    });
  }

  generateQuery() {
    String queryStart = 'SELECT * FROM $tableName WHERE ';
    String query = '', queryEnd = '', modifier = '', operator = '';
    List<Map<String, dynamic>> params = [];

    for (int i = 0; i < advancedSearchList.length; ++i) {
      String columnName = advancedSearchList[i].columnName.toString().trim();
      operator = advancedSearchList[i].operator.toString().trim();
      String value1 = advancedSearchList[i].value1.toString().trim();
      String value2 = advancedSearchList[i].value2.toString().trim();
      modifier = advancedSearchList[i].modifier.toString().trim();
      String dataType = advancedSearchList[i].dataType.toString().trim();
      if (dataType == 'LOOKUP') {
        value1 = advancedSearchList[i].value1ValueField.toString().trim();
        value2 = advancedSearchList[i].value2ValueField.toString().trim();
      } else if (dataType == 'TAGBOX' || dataType == 'SFTAGBOX') {
        value1 = advancedSearchList[i].value1ValueField.toString().trim();
        value2 = advancedSearchList[i].value2ValueField.toString().trim();
      }

      if (modifier.isNotEmpty) {
        if (operator == 'BETWEEN') {
          dynamic prms = {Strings.kName: 'P1', Strings.kValue: value1};
          params.add(prms);
          prms = {Strings.kName: 'P2', Strings.kValue: value2};
          params.add(prms);
        } else {
          dynamic prms = {Strings.kName: 'P1', Strings.kValue: value1};
          params.add(prms);
        }

        if (modifier == 'DATE') {
          value1 = 'TRUNC($columnName) = TRUNC( :P1)';
          value2 = 'TRUNC($columnName) = TRUNC( :P2)';
        } else if (modifier == 'YEAR') {
          value1 = 'EXTRACT ($columnName) = EXTRACT(YEAR FROM (:P1))';
          value2 = 'EXTRACT ($columnName) = EXTRACT(YEAR FROM (:P2))';
        } else if (modifier == 'MONTH') {
          value1 = 'EXTRACT ($columnName) = EXTRACT(MONTH FROM (:P1))';
          value2 = 'EXTRACT ($columnName) = EXTRACT(MONTH FROM (:P2))';
        } else if (modifier == 'DAY') {
          value1 = 'EXTRACT ($columnName) = EXTRACT(DAY FROM (:P1))';
          value2 = 'EXTRACT ($columnName) = EXTRACT(DAY FROM (:P2))';
        } else if (modifier == 'TODAY') {
          value1 = 'TRUNC($columnName) = TRUNC( :P1)';
          value2 = 'TRUNC($columnName) = TRUNC( :P2)';
        } else if (modifier == 'LASTDAYOFMONTH') {
          value1 = 'TRUNC($columnName) = TRUNC(LAST_DAY( :P1) )';
          value2 = 'TRUNC($columnName) = TRUNC(LAST_DAY( :P2) )';
        } else if (modifier == 'FIRSTDAYOFMONTH') {
          value1 = "TRUNC($columnName) = TRUNC( :P1,'MM' )";
          value2 = "TRUNC($columnName) = TRUNC( :P2,'MM' )";
        }
      }

      if (operator == 'BETWEEN') {
        queryEnd = queryEnd +
            "$columnName $operator '$value1' "
                "AND '$value2'";
      } else if (operator == 'LIKE') {
        queryEnd = queryEnd + "$columnName $operator '%$value1%'";
      } else if (operator == 'IN') {
        queryEnd = queryEnd + "$columnName $operator ('$value1')";
      } else {
        queryEnd = queryEnd + "$columnName $operator '$value1'";
      }

      if ((i + 1) == advancedSearchList.length) {
        break;
      } else {
        queryEnd = queryEnd + ' ${advancedSearchList[i].operation} ';
      }
    }
    query = queryStart + queryEnd;
    Logs.logData("query::::", query);
    if (query.isNotEmpty) {
      if (modifier.isNotEmpty) {
        /// encode key-value param list
        dynamic paramData = json.encode(params);
        Logs.logData("param::::", params.toString());
        searchDate(body: query, param: paramData);
      } else {
        search(query: query);
      }
    }
  }

  /// common search
  Future<void> search({
    required String query,
  }) async {
    isButtonClickLoader.value = true;

    /// Getting meta data frm the API
    final menuDataResponse = await apiClient.rapidRepo.getQueryDynamicValue(
      query: query,
    );
    if (menuDataResponse.status) {
      isButtonClickLoader.value = false;
      List<dynamic> menuColumnData = menuDataResponse.data;
      Get.back(result: {
        'MENU_COL_DATA': menuColumnData,
        'mode': Strings.kParamSearch,
      });
      Get.back(result: {
        'MENU_COL_DATA': menuColumnData,
        'mode': Strings.kParamSearch,
      });
    } else {
      isButtonClickLoader.value = false;
      Get.snackbar(Strings.kMessage, menuDataResponse.message.toString());
    }
  }

  /// common search with param
  Future<void> searchDate(
      {required String body, required dynamic param}) async {
    isButtonClickLoader.value = true;

    /// Getting meta data frm the API
    final menuDataResponse = await apiClient.rapidRepo.getCommonSearch(
      query: body,
      param: param,
    );
    if (menuDataResponse.status) {
      isButtonClickLoader.value = false;
      List<dynamic> menuColumnData = menuDataResponse.data;
      Get.back(result: {
        'MENU_COL_DATA': menuColumnData,
        'mode': Strings.kParamSearch,
      });
      Get.back(result: {
        'MENU_COL_DATA': menuColumnData,
        'mode': Strings.kParamSearch,
      });
    } else {
      isButtonClickLoader.value = false;
      Get.snackbar(Strings.kMessage, menuDataResponse.message.toString());
    }
  }
}
