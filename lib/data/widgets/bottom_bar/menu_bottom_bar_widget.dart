import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rapid_app/res/values/strings.dart';

class MenuBottomBarWidget extends StatefulWidget {
  const MenuBottomBarWidget({
    Key? key,
    required this.isInsert,
    required this.onItemTap,
    required this.fabKey,
  }) : super(key: key);

  final Function onItemTap;
  final String isInsert;
  final GlobalKey<FabCircularMenuPlusState> fabKey;

  @override
  State<MenuBottomBarWidget> createState() => _MenuBottomBarWidgetState();
}

class _MenuBottomBarWidgetState extends State<MenuBottomBarWidget> {
  int bottomBarSelectedIndex = 0;
  List<String> bottomNames = [];
  List<IconData> bottomIcons = [];

  @override
  Widget build(BuildContext context) {
    widget.isInsert == 'N'
        ? bottomNames = [
            Strings.kCommonSearch.tr,
            Strings.kSearch.tr,
            Strings.kAdvanceSearch.tr,
            Strings.kExportExcel.tr,
            Strings.kExportPdf.tr,
          ]
        : bottomNames = [
            Strings.kAdd.tr,
            Strings.kCommonSearch.tr,
            Strings.kSearch.tr,
            Strings.kAdvanceSearch.tr,
            Strings.kExportExcel.tr,
            Strings.kExportPdf.tr,
          ];
    widget.isInsert == 'N'
        ? bottomIcons = [
            Icons.search,
            Icons.zoom_in,
            FontAwesomeIcons.searchengin,
            FontAwesomeIcons.fileExcel,
            FontAwesomeIcons.filePdf,
          ]
        : bottomIcons = [
            Icons.add,
            Icons.search,
            Icons.zoom_in,
            FontAwesomeIcons.searchengin,
            FontAwesomeIcons.fileExcel,
            FontAwesomeIcons.filePdf,
          ];
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
