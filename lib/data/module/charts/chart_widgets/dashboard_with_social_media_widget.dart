import 'package:flutter/material.dart';
import 'package:rapid_app/data/module/charts/chart_controller.dart';
import 'package:rapid_app/data/widgets/container/home_card_view_widget.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/default_concatenator.dart';
import 'package:rapid_app/res/values/logs/logs.dart';
import 'package:url_launcher/url_launcher.dart';

class ChartDashboardWithSocialMedialWidget extends StatelessWidget {
  const ChartDashboardWithSocialMedialWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ChartController controller;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: controller.chartDashboardTableWithSocialMedia.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: Center(
            child: viewIcon(
                icon: controller
                    .chartDashboardTableWithSocialMedia[index].mtdImage
                    .toString(),
                iconColor: Theme.of(context).textTheme.headline1!.color!,
                iconSize: 24),
          ),
          onTap: () => _launchURL(controller
              .chartDashboardTableWithSocialMedia[index].mtdLink
              .toString()),
        );
      },
    );
  }

  _launchURL(String link) async {
    Logs.logData("before link::", link.toString());
    String url = await defaultConcatenation(formula: link);
    Logs.logData("after link::", url.toString());
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
