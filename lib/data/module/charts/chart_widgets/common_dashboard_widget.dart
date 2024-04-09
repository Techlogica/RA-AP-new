import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/charts/chart_controller.dart';
import 'package:rapid_app/data/module/charts/chart_widgets/dashboard_amount_widget.dart';
import 'package:rapid_app/data/widgets/container/card_container_widget.dart';
import 'package:rapid_app/data/widgets/container/home_card_view_widget.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:share_plus/share_plus.dart';
import 'alert_widget/alert_dialog_widget.dart';

class ChartCommonDashboardWidget extends StatelessWidget {
  const ChartCommonDashboardWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ChartController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.chartDashboardTable.length,
        itemBuilder: (context, index) {
          controller.loadPrice(index: index);
          return Slidable(
            closeOnScroll: true,
            key: const ValueKey(0),
            startActionPane: ActionPane(
              extentRatio: 0.20,
              dragDismissible: false,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  autoClose: true,
                  onPressed: (BuildContext context) =>
                      controller.loadPrice(index: index),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Theme.of(context).backgroundColor,
                  icon: Icons.refresh,
                ),
              ],
            ),
            endActionPane: ActionPane(
              extentRatio: 0.20,
              dragDismissible: false,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  autoClose: true,
                  onPressed: (BuildContext context) {
                    _dashboardShare(controller, index);
                  },
                  backgroundColor: Colors.transparent,
                  foregroundColor: Theme.of(context).backgroundColor,
                  icon: Icons.ios_share,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: CardContainerWidget(
                cardWidget: Obx(
                  () => InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (BuildContext context) =>
                          CustomDialog(controller: controller, index: index,
                            tabIndex: controller.tabController.index));
                    },
                    child: Column(
                      children: [
                        controller.chartDashboardTable[index].mtdMdtSysId == null
                            ? const SizedBox(
                                height: 0,
                              )
                            : Expanded(
                                flex: 0,
                                child: Row(
                                  children: [
                                    const Expanded(flex: 1, child: SizedBox()),
                                    InkWell(
                                      child: Icon(
                                        Icons.add,
                                        size: 24,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .color!,
                                      ),
                                      onTap: () {
                                        controller.fetchDashboardGrid(
                                            controller.chartDashboardTable[index]
                                                .mtdMdtSysId,
                                            'add');
                                      },
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    InkWell(
                                      child: Icon(
                                        Icons.list,
                                        size: 24,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .color!,
                                      ),
                                      onTap: () {
                                        controller.fetchDashboardGrid(
                                            controller.chartDashboardTable[index]
                                                .mtdMdtSysId,
                                            'grid');
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                        Row(
                          children: [
                            Expanded(
                                flex: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: viewIcon(
                                      icon: controller
                                          .chartDashboardTable[index].mtdImage
                                          .toString(),
                                      iconColor: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .color!,
                                      iconSize: 24),
                                )),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        controller
                                            .chartDashboardTable[index].mtdText
                                            .toString(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline1!
                                                .color!),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        const Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              height: 1,
                                            )),
                                        Expanded(
                                          flex: 0,
                                          child: ChartDashboardAmountWidget(
                                            id: controller
                                                .chartDashboardTable[index]
                                                .mtdSysId,
                                            priceFormat: controller
                                                .chartDashboardTable[index]
                                                .mtdDisplayFormat,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        controller
                                            .chartDashboardTable[index].mtdSubtext
                                            .toString(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline1!
                                                .color!),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _dashboardShare(ChartController controller, int index) {
    Share.share(controller.chartDashboardTable[index].mtdText.toString() +
        '\n' +
        controller
            .price(id: controller.chartDashboardTable[index].mtdSysId)!
            .price +
        '\n' +
        controller.chartDashboardTable[index].mtdSubtext.toString() +
        '\n' +
        '-----------------------------' +
        '\n' +
        RapidPref().getProjectName().toString());
  }
}
