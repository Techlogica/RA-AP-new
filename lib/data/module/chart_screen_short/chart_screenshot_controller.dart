import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rapid_app/data/model/chart_graph_model/chart_graph_response.dart';
import 'package:rapid_app/data/model/chart_model/chart_response.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/logs/logs.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreenshotController extends RapidController {
  dynamic argumentData = Get.arguments;
  GlobalKey globalKey = GlobalKey();

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  RxList<ChartResponse> chartTableParse = <ChartResponse>[].obs;
  RxList<ChartGraphResponse> chartGraphParse = <ChartGraphResponse>[].obs;
  RxList<ColumnSeries<dynamic, dynamic>> getColumnsByDate =
      <ColumnSeries<dynamic, dynamic>>[].obs;
  RxList<ColumnSeries<dynamic, dynamic>> getColumnsByString =
      <ColumnSeries<dynamic, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    chartTableParse.add(argumentData['chartTableList']);
    chartGraphParse.add(argumentData['chartGraphTableList']);
    getColumnsByDate.value = argumentData['_getColumnsByDate'];
    getColumnsByString.value = argumentData['_getColumnsByString'];
    screenshotController
        .capture(delay: const Duration(seconds: 5))
        .then((capturedImage) {
      _takeScreenshot();
    }).catchError((onError) {
      Logs.logData("Error", onError.toString());
    });
  }

  Future<void> _takeScreenshot() async {
    final imageFile = await screenshotController.capture();
    if (imageFile == null) {
      const SnackBar(content: Text('Error: imageFile is null'),);
      return;
    }
    final t = await getTemporaryDirectory();
    final path = '${t.path}/sharedImage.jpg';
    File(path).writeAsBytesSync(imageFile);
    Share.shareFiles([path],
        text: '${chartTableParse[0].cChartName}\n-----------------------------\n'
            '${RapidPref().getProjectName()}');
    Get.back();
  }

  ChartGraphResponse? graphData({required int id}) {
    for (var value in chartGraphParse) {
      if (value.id == id) {
        return value;
      }
    }
    return null;
  }

  List<ChartGraphResponse> filterData({required int id}) {
    List<ChartGraphResponse> data = [];
    for (var value in chartGraphParse) {
      if (value.id == id) {
        data.add(value);
      }
    }
    return data;
  }
}
