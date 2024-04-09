import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/menu_details_search_controller.dart';
import 'package:rapid_app/data/widgets/app_bar/home_app_bar.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/search_text_field_widget.dart';
import 'package:rapid_app/res/values/colours.dart';

class MenuDetailsSearchPage extends GetView<MenuDetailsSearchController> {
  const MenuDetailsSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBarWidget(
        title: 'Search Detail',
        leadingIcon: const Icon(
          Icons.arrow_back,
          size: 25,
          color: colours.white,
        ),
        onTapLeadingIcon: _backPress,
      ),
      body: _BodyWidget(),
    );
  }

  void _backPress() {
    Get.back();
  }
}

class _BodyWidget extends GetView<MenuDetailsSearchController> {
  int index = 0;
  int ctr = 1;

  double crossaxis(context, int index, crossAxisCount) {
    print(
        '........................1 $index: ${controller.selectedTabColumnsList[index].mdcColSpanmd}');
    if (controller.selectedTabColumnsList[index].mdcColSpanmd! >= 8) {
      crossAxisCount = 1;
    }
    double itemWidth = crossAxisCount == 1
        ? MediaQuery.of(context).size.width * 0.50
        : (controller.selectedTabColumnsList[index].mdcColSpanmd == 2 ||
                controller.selectedTabColumnsList[index].mdcColSpanmd == 3 ||
                controller.selectedTabColumnsList[index].mdcColSpanmd == 4 ||
                controller.selectedTabColumnsList[index].mdcColSpanmd == 5)
            ? MediaQuery.of(context).size.width * 0.30
            : MediaQuery.of(context).size.width;
    ctr += 1;
    // print(".............${itemWidth + 90}");
    return itemWidth + 60;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Top section
          Container(
            alignment: Alignment.topLeft,
            height: 50,
            color: Theme.of(context).backgroundColor,
            child: Container(
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
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                      ),
                    ),
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor:
                        Theme.of(context).textTheme.headline1!.color!,
                    isScrollable: true,
                    controller: controller.tabController,
                    tabs: controller.tabs,
                    onTap: controller.onTapTab,
                  );
                }
              }),
            ),
          ),

          ///body section
          // Expanded(
          //   flex: 1,
          //   child: Obx(
          //     () => ListView.builder(
          //       shrinkWrap: true,
          //       padding: const EdgeInsets.symmetric(horizontal: 10),
          //       itemCount: controller.selectedTabColumnsList.length,
          //       itemBuilder: (context, index) {
          //         print('................... $index: ${controller.selectedTabColumnsList[index].mdcColSpanmd}');
          //         return SearchTextFieldWidget(
          //           indexList: index,
          //           textEditingController: controller.getControllerValue(
          //             controller.selectedTabColumnsList[index].mdcColName,
          //
          //           ), width: screenWidth,
          //         );
          //       },
          //     ),
          //   ),
          // ),

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
                      for (int index = 0;
                          index < controller.selectedTabColumnsList.length;
                          ++index)
                        // if (controller.valueSetFlag.value)
                        SizedBox(
                          width: (controller.selectedTabColumnsList[index]
                                      .mdcColSpanmd! >=
                                  6)
                              ? screenWidth
                              : crossaxis(context, index, 3),
                          child: SearchTextFieldWidget(
                            indexList: index,
                            textEditingController:
                                controller.getControllerValue(
                                    controller.selectedTabColumnsList[index]
                                        .mdcColName,
                                    index,
                                    false),
                            width: crossaxis(context, index, 4),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          ///bottom section
          Expanded(
            flex: 0,
            child: Container(
              color: Theme.of(context).backgroundColor,
              height: 70,
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 50,
                child: Obx(
                  () => controller.isButtonClickLoader.value
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
                                  horizontal: 5, vertical: 5),
                              child: ElevatedButton(
                                child: Text(
                                  controller.buttonsList[index].mdcdText
                                      .toString()
                                      .toUpperCase(),
                                ),
                                style: TextButton.styleFrom(
                                  //primary: Theme.of(context).backgroundColor,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  textStyle: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  controller.onButtonClick(
                                      controller.buttonsList[index].mdcdSysId);
                                },
                              ),
                            );
                          }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
