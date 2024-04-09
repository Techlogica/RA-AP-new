import 'package:flutter/material.dart';
import 'package:rapid_app/data/module/charts/chart_controller.dart';

class ChartTabBarWidget extends StatelessWidget {
  const ChartTabBarWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ChartController controller;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
      ),
      labelColor: Theme.of(context).textTheme.headline2!.color!,
      unselectedLabelColor: Theme.of(context).primaryColor,
      isScrollable: true,
      controller: controller.tabController,
      tabs: controller.tabs,
      onTap: controller.onTapTab,
    );
  }
}
