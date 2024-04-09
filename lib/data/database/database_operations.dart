import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/strings.dart';

class DatabaseOperations {
  Future<Box> openDatabase() async {
    var projectName = RapidPref().getProjectKey();
    debugPrint("-----------------db::$projectName");
    Box box;
    try {
      box = Hive.box(projectName ?? '');
    } catch (error) {
      box = await Hive.openBox(projectName ?? '');
    }
    return box;
  }

  Future<bool> isTableEmpty(String tableName) async {
    //open database
    Box box = await openDatabase();
    // read table values
    var tableData = box.get(tableName);
    return tableData == null;
  }

  Future<bool> clearTables() async {
    //open database
    Box box = await openDatabase();
    box.delete(Strings.kMetadataTable);
    box.delete(Strings.kMetadataColumns);
    box.delete(Strings.kChartTabTable);
    box.delete(Strings.kChartDashboardTable);
    box.delete(Strings.kCharts);
    return true;
  }
}
