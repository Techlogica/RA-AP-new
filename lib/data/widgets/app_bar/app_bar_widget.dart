import 'package:flutter/material.dart';
import '../container/icon_background_widget.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    Key? key,
    required this.title,
    required this.leadingIcon,
    this.actionIcon,
    this.onTapLeadingIcon,
    this.onTapActionIcon,
  }) : super(key: key);

  final Widget title;
  final IconData leadingIcon;
  final IconData? actionIcon;
  final VoidCallback? onTapLeadingIcon;
  final VoidCallback? onTapActionIcon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 5,
            top: 15,
          ),
          child: IconBackgroundWidget(
            icon: leadingIcon,
            backgroundColor: Theme.of(context).backgroundColor,
            iconColor: Theme.of(context).primaryColor,
          ),
        ),
        onTap: onTapLeadingIcon,
      ),
      title: Padding(
        padding: const EdgeInsets.only(
          top: 15,
        ),
        child: title,
      ),
      centerTitle: true,
      actions: [
        if (actionIcon != null)
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 5,
                top: 15,
              ),
              child: IconBackgroundWidget(
                icon: actionIcon,
                backgroundColor: Theme.of(context).backgroundColor,
                iconColor: Theme.of(context).primaryColor,
              ),
            ),
            onTap: onTapActionIcon,
          ),
      ],
      elevation: 5,
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
