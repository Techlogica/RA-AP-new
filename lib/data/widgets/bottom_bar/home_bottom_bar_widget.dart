import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomeBottomBarWidget extends StatefulWidget {
  const HomeBottomBarWidget({
    Key? key,
    required this.onItemTap,
  }) : super(key: key);

  final Function onItemTap;

  @override
  State<HomeBottomBarWidget> createState() => _HomeBottomBarWidgetState();
}

class _HomeBottomBarWidgetState extends State<HomeBottomBarWidget> {
  int bottomBarSelectedIndex = 0;

  final bottomIcons = [
    const Icon(
      Icons.dashboard_rounded,
      size: 30,
    ),
    const Icon(
      Icons.home,
      size: 30,
    ),
    const Icon(
      Icons.calendar_today,
      size: 30,
    ),
    const Icon(
      Icons.search,
      size: 30,
    ),
    const Icon(
      Icons.textsms_outlined,
      size: 30,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor)),
      child: CurvedNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        height: 60,
        color: Theme.of(context).backgroundColor,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() => bottomBarSelectedIndex = index);
          widget.onItemTap(index);
        },
        items: bottomIcons,
      ),
    );
  }
}
