import 'package:flutter/material.dart';

class EventListTileWidget extends StatelessWidget {
  const EventListTileWidget(
      {Key? key, this.titleWidget, this.trailingWidget, this.leadingWidget})
      : super(key: key);

  final Widget? titleWidget;
  final Widget? trailingWidget;
  final Widget? leadingWidget;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: titleWidget,
      trailing: trailingWidget,
      leading: leadingWidget,
    );
  }
}