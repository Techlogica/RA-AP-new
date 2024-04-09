import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/charts/chart_controller.dart';
import 'package:rapid_app/data/module/charts/chart_widgets/common_dashboard_widget.dart';
import 'package:rapid_app/data/module/charts/chart_widgets/dashboard_with_html_widget.dart';
import 'package:rapid_app/data/module/charts/chart_widgets/dashboard_with_social_media_widget.dart';
import 'package:rapid_app/data/module/charts/chart_widgets/tab_bar_widget.dart';
import 'package:rapid_app/data/module/charts/chart_widgets/charts_widget.dart';

class ChartPage extends GetView<ChartController> {
  const ChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _ChartBody();
  }
}

class Item {
  const Item(this.name, this.icon);
  final String name;
  final IconData icon;
}

class _ChartBody extends GetView<ChartController> {
  const _ChartBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            color:Theme.of(context).backgroundColor,
            child: Container(
              padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
              child: Obx(() {
                if (controller.tabs.isEmpty) {
                  if (controller.isIndicatorVisibility.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).backgroundColor,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                } else {
                  return controller.tabDataCount.value == 0
                      ? const SizedBox()
                      : ChartTabBarWidget(controller: controller);
                }
              }),
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                Obx(() {
                  if (controller.chartDashboardTableWithHtml.isEmpty) {
                    return const SizedBox();
                  } else {
                    return ChartDashboardWithHtmlWidget(
                      controller: controller,
                    );
                  }
                }),
                Obx(() {
                  if (controller.chartDashboardTableWithSocialMedia.isEmpty) {
                    return const SizedBox();
                  } else {
                    return ChartDashboardWithSocialMedialWidget(
                      controller: controller,
                    );
                  }
                }),
                Obx(() {
                  if (controller.chartDashboardTable.isEmpty) {
                    return const SizedBox();
                  }  else {
                    return ChartCommonDashboardWidget(
                    controller: controller,
                  );
                  }
                }),
                ChartsListviewWidget(
                  controller: controller,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
