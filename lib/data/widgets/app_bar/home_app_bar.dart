import 'package:flutter/material.dart';
import '../container/icon_background_widget.dart';

class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBarWidget({
    Key? key,
    required this.title,
    required this.leadingIcon,
    this.actionIcon,
    this.onTapLeadingIcon,
    this.onTapActionIcon,
  }) : super(key: key);

  final String title;
  final Widget leadingIcon;
  final IconData? actionIcon;
  final VoidCallback? onTapLeadingIcon;
  final VoidCallback? onTapActionIcon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: onTapLeadingIcon,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 5,
            top: 15,
            bottom: 5,
          ),
          child: leadingIcon,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(
          top: 12,
        ),
        child: Text(
          title,
          style: TextStyle(color: Theme.of(context).textTheme.headline2!.color),
        ),
      ),
      centerTitle: true,
      actions: [
        if (actionIcon != null)
          InkWell(
            onTap: onTapActionIcon,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 5,
                top: 15,
                bottom: 5,
              ),
              child: IconBackgroundWidget(
                icon: actionIcon,
                backgroundColor: Theme.of(context).backgroundColor,
                iconColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
      ],
      elevation: 5,
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
