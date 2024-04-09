import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rapid_app/data/module/chart_grid/chart_grid_binding.dart';
import 'package:rapid_app/data/module/chart_grid/chart_grid_page.dart';
import 'package:rapid_app/data/module/chart_screen_short/chart_screenshot_binding.dart';
import 'package:rapid_app/data/module/chart_screen_short/chart_screenshot_page.dart';
import 'package:rapid_app/data/module/charts/chart_controller.dart';
import 'package:rapid_app/data/module/charts/chart_page.dart';
import 'package:rapid_app/data/module/charts/chart_widgets/alert_widget/alert_dialog_widget.dart';
import 'package:rapid_app/data/widgets/container/card_container_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartsListviewWidget extends StatelessWidget {
  ChartsListviewWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ChartController controller;
  bool isCalendarEnabled = true;

  final List dropdownItems = [
    const Item(
      'Grid',
      Icons.table_rows_outlined,
    ),
    const Item(
      'Share',
      Icons.share,
    ),
    const Item(
      'Refresh',
      Icons.refresh,
    ),
    const Item('alert', Icons.notifications)
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.chartTable.length,
        itemBuilder: (context, index) {
          controller.loadChartGraph(index: index);
          return CardContainerWidget(
            cardWidget: InkWell(
              // onTap: () {
              //   showDialog(
              //     context: context,
              //     builder: (BuildContext context) => CustomDialog(
              //       controller: controller,
              //       index: index,
              //       tabIndex: controller.tabController.index,
              //     ),
              //   );
              //   debugPrint("****************chart");
              // },
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 85),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            controller.chartTable[index].cChartName.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: DropdownButton<Item>(
                            underline: const SizedBox(),
                            items: dropdownItems
                                .map<DropdownMenuItem<Item>>(
                                    (item) => DropdownMenuItem(
                                        value: item,
                                        child: Row(
                                          children: [
                                            Icon(
                                              item.icon,
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                            ),
                                            Text(
                                              item.name,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .backgroundColor),
                                            )
                                          ],
                                        )))
                                .toList(),
                            onChanged: (item) {
                              controller.notify.value=false;
                              if (item!.name.toString() == 'Share') {
                                controller.index.value = index;
                                debugPrint(
                                    "index.........${controller.index.value}");
                                Get.to(() => const ChartScreenshotPage(),
                                    arguments: {
                                      'chartTableList':
                                          controller.chartTable[index],
                                      'chartGraphTableList':
                                          controller.chartGraphTable[index],
                                      '_getColumnsByString':
                                          controller.getColumnsByString(
                                        id: controller.chartTable[index].cSysId,
                                      ),
                                      '_getColumnsByDate':
                                          controller.getColumnsByDate(
                                        id: controller.chartTable[index].cSysId,
                                      ),
                                    },
                                    binding: ChartScreenshotBinding());
                              }
                              if (item.name.toString() == 'Grid') {
                                if (controller.chartTable[index].cGridString !=
                                    null) {
                                  Get.to(() => ChartGridPage(),
                                      arguments: {
                                        'chartTableList':
                                            controller.chartTable[index],
                                        'gridQuery': controller
                                            .chartTable[index].cGridString,
                                        'filterData': controller.filterData(
                                            id: controller
                                                .chartTable[index].cSysId),
                                      },
                                      binding: ChartGridBinding());
                                } else {
                                  Get.snackbar(
                                      "warning!", "Grid not available");
                                }
                              }
                              if (item.name.toString() == "Refresh") {
                                controller.loadChartGraph(index: index);
                              }
                              if(item.name.toString()=='alert'){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => CustomDialog(
                                    controller: controller,
                                    index: index,
                                    tabIndex: controller.tabController.index,
                                  ),
                                );

                              }
                            },
                            icon: Icon(
                              Icons.more_horiz,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            dropdownColor: Theme.of(context)
                                .bottomNavigationBarTheme
                                .selectedItemColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  Obx(
                    () => SfCartesianChart(
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        toggleSeriesVisibility: true,
                        isResponsive: false,
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(
                          text: controller.chartTable[index].caName,
                        ),
                        numberFormat: NumberFormat.compact(),
                      ),
                      primaryXAxis: controller.chartTable[index].caIsArgument ==
                              'key'
                          ? CategoryAxis()
                          : DateTimeAxis(
                              dateFormat: _axisLabelFormat(
                                  controller.chartTable[index].caLabelFormat),
                              interval: 6,
                            ),
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                      ),
                      series: controller.chartTable[index].caIsArgument == 'key'
                          ? controller.getColumnsByString(
                              id: controller.chartTable[index].cSysId)
                          : controller.getColumnsByDate(
                              id: controller.chartTable[index].cSysId,
                            ),
                      plotAreaBorderWidth: 0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _axisLabelFormat(int? labelFormat) {
    switch (labelFormat) {
      case 2:
        return DateFormat('dd-MM-yyyy');
      case 11:
        return DateFormat('MMM');
      case 21:
        return DateFormat('YYY');
      case 22:
        return DateFormat('EEE');
      default:
        return null;
    }
  }
}
