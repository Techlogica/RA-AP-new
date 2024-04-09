import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rapid_app/data/module/chart_screen_short/chart_screenshot_controller.dart';
import 'package:rapid_app/data/widgets/container/card_container_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreenshotPage extends GetView<ChartScreenshotController> {
  const ChartScreenshotPage( {Key? key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Theme.of(Get.context!).backgroundColor,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Screenshot(
                  controller: controller.screenshotController,
                  child: CardContainerWidget(
                    cardWidget: SizedBox(
                      height: 500,
                      child: Obx(
                        () {
                          if (controller.chartGraphParse.isEmpty) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .color,
                              ),
                            );
                          } else {
                            return SfCartesianChart(
                              title: ChartTitle(
                                text: controller.chartTableParse[0].cChartName
                                    .toString(),
                              ),
                              legend: Legend(
                                isVisible: true,
                                position: LegendPosition.bottom,
                                toggleSeriesVisibility: true,
                                isResponsive: false,
                              ),
                              primaryYAxis: NumericAxis(
                                title: AxisTitle(
                                  text: controller.chartTableParse[0].caName
                                      .toString(),
                                ),
                                numberFormat: NumberFormat.compact(),
                              ),
                              primaryXAxis: controller
                                          .chartTableParse[0].caIsArgument ==
                                      'key'
                                  ? CategoryAxis()
                                  : DateTimeAxis(
                                      // dateFormat: _axisLabelFormat(controller
                                      //     .chartTableLocalDB[controller.index.value].caLabelFormat),
                                      ),
                              // enableSideBySideSeriesPlacement: false,
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                              ),
                              series:
                                  controller.chartTableParse[0].caIsArgument ==
                                          'key'
                                      ? controller.getColumnsByString
                                      : controller.getColumnsByDate,
                              plotAreaBorderWidth: 0,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CircularProgressIndicator(
                        color: Theme.of(context).textTheme.subtitle2!.color,
                      ),
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
}
