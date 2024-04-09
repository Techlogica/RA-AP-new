import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rapid_app/data/model/chart_model/chart_response.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/default_concatenator.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';
import 'package:get/get.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/logs/logs.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ChartGridController extends RapidController {
  final GlobalKey<SfDataGridState> keyExport = GlobalKey<SfDataGridState>();

  GlobalKey globalKey = GlobalKey();

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  dynamic argumentData = Get.arguments;

  RxList<ChartResponse> chartTable = RxList<ChartResponse>([]);
  RxList<dynamic> chartGridData = RxList<dynamic>([]);
  Rx<bool> isIndicatorVisibility = true.obs;

  @override
  void onInit() {
    super.onInit();
    chartTable.add(argumentData['chartTableList']);
    String gridQuery = argumentData['gridQuery'];
    fetchChartGridValues(gridQuery);
  }

  Future<void> fetchChartGridValues(String gridQuery) async {
    final response = await apiClient.rapidRepo.getChartGrid(
      query: await defaultConcatenation(formula: gridQuery),
    );
    if (response.status) {
      List<dynamic> gridData = response.data;
      chartGridData.addAll(gridData);
    } else {
      isIndicatorVisibility.value = false;
    }
  }

  Future<void> imageShare() async {
    screenshotController
        .capture(delay: const Duration(milliseconds: 5))
        .then((capturedImage) {
      _takeScreenshot();
    }).catchError((onError) {
      Logs.logData("Error", onError.toString());
    });
  }

  Future<void> _takeScreenshot()async {
    final imageFile = await screenshotController.capture();
    final t = await getTemporaryDirectory();
    final path = '${t.path}/shareImage.jpg';
    File(path).writeAsBytes(imageFile!);
    Share.shareFiles([path],
        text: chartTable[0].cChartName.toString()+'\n'+
            '-----------------------------'+
            '\n'+ RapidPref().getProjectName().toString());

  }
}
