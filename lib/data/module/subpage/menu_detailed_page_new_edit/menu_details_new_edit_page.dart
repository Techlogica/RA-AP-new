import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_new_edit/menu_details_new_edit_controller.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_new_edit/new_edit_widget/new_edit_widget.dart';
import 'package:rapid_app/data/widgets/app_bar/app_bar_widget.dart';
import 'package:rapid_app/res/values/colours.dart';

class MenuDetailsNewEditPage extends GetView<MenuDetailsNewEditController> {
  const MenuDetailsNewEditPage({Key? key}) : super(key: key);

  @override
  String? get tag => '${Get.arguments["MDT_SYS_ID"]}';

  @override
  Widget build(BuildContext context) {
    // MenuDetailsNewEditController controller = Get.put(MenuDetailsNewEditController());
    return Scaffold(
      appBar: AppBarWidget(
        title: Obx(
          () => Text(
            controller.getPageCaption(),
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
        leadingIcon: Icons.arrow_back,
        onTapLeadingIcon: backPress,
      ),
      body: _BodyWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(
        () => controller.childTables.isNotEmpty
            ? HawkFabMenu(
                backgroundColor: Colors.transparent,
                blur: 3.0,
                icon: AnimatedIcons.menu_close,
                fabColor: Theme.of(context).primaryColor,
                iconColor: Theme.of(context).backgroundColor,
                body: const Text("data"),
                items: [
                  for (int i = 0; i < controller.childTables.length; ++i)
                    HawkFabMenuItem(
                      label: controller.childTables[i].mdtTblTitle,
                      ontap: () => controller.childPageMove(index: i),
                      icon: const Icon(Icons.add),
                      labelColor: Theme.of(context).colorScheme.background,
                      color: Colors.black12,
                      labelBackgroundColor: colours.black,
                      ///edited
                    ),
                ],
              )
            : const SizedBox(),
      ),
    );
  }

  void backPress() {
    Get.back(result: {
      'sysId': controller.pkKeyValue,
      'mode': controller.mode,
    });
  }
}

class _BodyWidget extends GetView<MenuDetailsNewEditController> {

  @override
  String? get tag => '${Get.arguments["MDT_SYS_ID"]}';
  int index = 0;
  int ctr = 1;

  double crossaxis(context, int index, crossAxisCount) {
    // print('ColSpan at index $index: ${controller.selectedTabColumnsList[index].mdcColSpanmd}');
    if (controller.selectedTabColumnsList[index].mdcColSpanmd! >= 8) {
      crossAxisCount = 1;
    }
    double itemWidth = crossAxisCount == 1
        ? MediaQuery.of(context).size.width * 0.50
        : (controller.selectedTabColumnsList[index].mdcColSpanmd == 3
        ||controller.selectedTabColumnsList[index].mdcColSpanmd == 4 ||
                controller.selectedTabColumnsList[index].mdcColSpanmd == 5)
            ? MediaQuery.of(context).size.width * 0.30
            : MediaQuery.of(context).size.width;
    ctr += 1;
    // print(".............${itemWidth + 90}");
    return itemWidth + 60;
  }


  @override
  Widget build(BuildContext context) {
    // Get.put(MenuDetailsNewEditController());
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Top section
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Obx(() {
              if (controller.tabs.isEmpty) {
                if (controller.isIndicatorVisibility.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).backgroundColor,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              } else {
                return TabBar(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  indicator: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).backgroundColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                  labelColor: Theme.of(context).backgroundColor,
                  unselectedLabelColor:
                      Theme.of(context).textTheme.displayLarge!.color!,
                  isScrollable: true,
                  controller: controller.tabController,
                  tabs: controller.tabs,
                  onTap: controller.onTapTab,
                );
              }
            }),
          ),

          ///body section
          Expanded(
            flex: 1,
            child: Obx(
              () => SingleChildScrollView(
                child: SizedBox(
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      for (int index = 0; index < controller.selectedTabColumnsList.length; ++index)
                        // if (controller.valueSetFlag.value)
                          SizedBox(
                            width: (controller.selectedTabColumnsList[index].mdcColSpanmd! >= 6)
                                ? screenWidth
                                : crossaxis(context, index, 3),
                            child: NewEditWidget(
                              indexList: index,
                              textEditingController:
                                  controller.getControllerValue(
                                   controller.selectedTabColumnsList[index].mdcColName,
                                index,
                                false,
                              ),
                              width: crossaxis(context, index, 4),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Expanded(
          //   flex: 1,
          //   child: Obx(
          //     () => ListView.builder(
          //       shrinkWrap: true,
          //       padding: const EdgeInsets.symmetric(horizontal: 10),
          //       itemCount: controller.selectedTabColumnsList.length,
          //       itemBuilder: (context, index) {
          //         print("????????????${controller.selectedTabColumnsList[index].mdcColName}");
          //         return controller.valueSetFlag.value
          //             ? NewEditWidget(
          //                 indexList: index,
          //                 textEditingController: controller.getControllerValue(
          //                     controller
          //                         .selectedTabColumnsList[index].mdcColName,
          //                     index,
          //                     false),
          //               )
          //             : const SizedBox();
          //       },
          //     ),
          //   ),
          // ),
          // Default value

          // Check conditions and set crossAxisCount accordingly

          // Expanded(
          //   flex: 1,
          //   child: Obx(
          //     () => GridView.builder(
          //       // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       //   crossAxisCount: crossAxisCount,
          //       //   mainAxisSpacing: 40,
          //       //   crossAxisSpacing: 24,
          //       //   // width / height: fixed for *all* items
          //       //   childAspectRatio: 0.75,
          //       // ),
          //
          //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          //         maxCrossAxisExtent: 200,
          //         mainAxisExtent: 60,
          //       ),
          //       shrinkWrap: true,
          //       padding: const EdgeInsets.symmetric(horizontal: 5),
          //       itemCount: controller.selectedTabColumnsList.length,
          //       itemBuilder: (context, index) {
          //         if (ctr == 2) {
          //           ctr = 1;
          //         }
          //         print("????????????${controller.selectedTabColumnsList[index].mdcColSpanmd}");
          //         return controller.valueSetFlag.value
          //             ? NewEditWidget(
          //                 width: crossaxis(context, index, ctr),
          //                 indexList: index,
          //                 textEditingController: controller.getControllerValue(
          //                   controller.selectedTabColumnsList[index].mdcColName,
          //                   index,
          //                   false,
          //                 ),
          //                 // Implement your logic to calculate width
          //               )
          //             : const SizedBox();
          //       },
          //     ),
          //   ),
          // ),

          ///bottom
          Expanded(
            flex: 0,
            child: Container(
              color: Theme.of(context).backgroundColor,
              height: 70,
              alignment: Alignment.centerRight,
              child: Obx(
                    () => Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 50,
                        child: Obx(() => controller.isButtonClickLoader.value
                            ? SizedBox(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                            : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: controller.buttonsList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                child: ElevatedButton(
                                  child: Text(
                                    controller.buttonsList[index].mdcdText
                                        .toString()
                                        .toUpperCase(),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                    Theme.of(context).backgroundColor,
                                    backgroundColor:
                                    Theme.of(context).primaryColor,
                                    textStyle: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  onPressed: () {

                                    controller.onButtonClick(controller
                                        .buttonsList[index].mdcdSysId);
                                  },
                                ),
                              );
                            })),
                      ),
                    ),
                    controller.isChildTablePlusIcon.value == true
                        ? const SizedBox(
                      width: 75,
                    )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
