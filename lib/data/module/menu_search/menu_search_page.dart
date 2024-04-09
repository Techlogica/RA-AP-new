import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/menu_search/menu_search_controller.dart';
import 'package:rapid_app/data/widgets/container/home_card_view_widget.dart';
import 'package:rapid_app/data/widgets/text/text_widget.dart';
import 'package:rapid_app/res/values/strings.dart';

class MenuSearchPage extends GetView<MenuSearchController> {
  const MenuSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _MenuWidget();
  }
}

class _MenuWidget extends GetView<MenuSearchController> {
  const _MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
      child: Obx(
        () {
          if (controller.firstPageData.isEmpty &&
              controller.isIndicatorVisibility.value) {
            Timer(const Duration(seconds: 2), controller.fetchMetaData);
            return SizedBox(
              width: double.infinity,
              height: 50,
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  flex: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: BreadCrumb.builder(
                      itemCount: controller.menuTitleBarList.length,
                      builder: (index) {
                        return BreadCrumbItem(
                            content: TextWidget(
                              text: controller.menuTitleBarList[index].title
                                  .toString(),
                              textColor: Theme.of(context).backgroundColor,
                              textSize: 15,
                            ),
                            onTap: () {
                              controller.fetchMenusFromLocalDb(sysId: 0);
                            });
                      },
                      divider: Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).textTheme.headline1!.color!,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: controller.firstPageData.length,
                    itemBuilder: (context, index) {
                      return HomeCardViewWidget(
                        icon: controller.firstPageData[index].mdtIcon.toString(),
                        title: controller.firstPageData[index].mdtTblTitle.toString(),
                        iconColor: Colors.white,
                        index: index,
                        backgroundColor: Theme.of(context).cardColor,
                        onTap: () => _onTap(
                          controller.firstPageData[index].mdtSysId,
                          controller.firstPageData[index].mdtTblName,
                          controller.firstPageData[index].mdtTblTitle,
                          controller.firstPageData[index].mdtDefaultwhere,
                          controller.firstPageData[index].mdtIsmenuchld,
                          controller.firstPageData[index].mdtInsert,
                          controller.firstPageData[index].mdtUpdate,
                          controller.firstPageData[index].mdtDelete,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  _onTap(
      int? mdtSysId,
      String? menuName,
      String? menuTitle,
      String? defaultCondition,
      String? isChild,
      String? isInsert,
      String? isUpdate,
      String? isDelete) {
    // check list is empty (there are no submenus under that sys_id).
    // if Y=contain child menus,
    if (isChild == 'Y') {
      // call sub menus
      controller.fetchMenusFromLocalDb(sysId: mdtSysId);
    } else {
      controller.fetchMenusFromLocalDb(sysId: 0);
      defaultCondition ??= '';
      Get.toNamed(
        Strings.kMenuDetailedPage,
        arguments: {
          "MDT_SYS_ID": mdtSysId,
          "MENU_NAME": menuName,
          "MENU_TITLE": menuTitle,
          "MDT_DEFAULT_WHERE": defaultCondition,
          "INSERT": isInsert,
          "UPDATE": isUpdate,
          "DELETE": isDelete,
        },
      );
    }
  }
}
