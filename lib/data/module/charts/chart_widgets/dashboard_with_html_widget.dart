import 'package:flutter/material.dart';
import 'package:rapid_app/data/module/charts/chart_controller.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/default_concatenator.dart';
import 'package:url_launcher/url_launcher.dart';

class ChartDashboardWithHtmlWidget extends StatelessWidget {
  const ChartDashboardWithHtmlWidget({
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
        crossAxisCount: 4,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: controller.chartDashboardTableWithHtml.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: Image.network(
            controller.chartDashboardTableWithHtml[index].mtdImage.toString(),
            fit: BoxFit.fill,
          ),
          onTap: () => _launchURL(controller
              .chartDashboardTableWithHtml[index].mtdQuery
              .toString()),
        );
      },
    );
  }
}

Future<String> _getSrc(String iframe) async {
  String iframeVal = await defaultConcatenation(formula: iframe);
  if (iframe.contains('src=')) {
    String str = iframeVal;
    const start = 'src="';
    const end = '"';

    final startIndex = str.indexOf(start);
    final endIndex = str.indexOf(end, startIndex + start.length);

    String url = str.substring(startIndex + start.length, endIndex);
    String fullUrl = 'https:' + url;
    return fullUrl;
  } else {
    return iframe;
  }
}

_launchURL(String iframe) async {
  String url = await _getSrc(iframe);
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}