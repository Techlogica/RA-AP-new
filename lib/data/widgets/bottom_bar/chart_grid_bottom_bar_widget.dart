import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rapid_app/res/values/strings.dart';

class ChartGridBottomBarWidget extends StatefulWidget {
  const ChartGridBottomBarWidget({
    Key? key,
    required this.onItemTap,
    required this.fabKey,
  }) : super(key: key);

  final Function onItemTap;
  final GlobalKey<FabCircularMenuPlusState> fabKey;

  @override
  State<ChartGridBottomBarWidget> createState() =>
      _ChartGridBottomBarWidgetState();
}

class _ChartGridBottomBarWidgetState extends State<ChartGridBottomBarWidget> {
  int bottomBarSelectedIndex = 0;
  List<String> bottomNames = [
    Strings.kDashboard.tr,
    Strings.kExportExcel.tr,
    Strings.kExportPdf.tr,
    Strings.kScreenShort.tr,
  ];
  List<IconData> bottomIcons = [
    Icons.dashboard_rounded,
    FontAwesomeIcons.fileExcel,
    FontAwesomeIcons.filePdf,
    Icons.camera,
  ];

  @override
  Widget build(BuildContext context) {
    return FabCircularMenuPlus(
        key: widget.fabKey,
        fabSize: 50,
        fabOpenIcon: Icon(
          Icons.menu,
          color: Theme.of(context).primaryColor,
        ),
        fabCloseIcon: Icon(
          Icons.close,
          color: Theme.of(context).primaryColor,
        ),
        alignment: Alignment.bottomRight,
        fabColor: Theme.of(context).backgroundColor,
        ringColor: Theme.of(context).backgroundColor,
        children: [
          for (int i = 0; i < bottomIcons.length; ++i)
            IconButton(
              icon: Icon(
                bottomIcons[i],
                size: 35,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => widget.onItemTap(i),
            ),
        ]);
  }
}
