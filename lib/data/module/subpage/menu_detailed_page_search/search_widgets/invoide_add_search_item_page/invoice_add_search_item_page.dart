import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/invoide_add_search_item_page/invoice_add_search_item_controller.dart';
import 'package:rapid_app/data/widgets/app_bar/app_bar_widget.dart';


class InvoiceAddSearchItemPage extends GetView<InvoiceAddSearchItemController> {
 const  InvoiceAddSearchItemPage({super.key});

  // String? get tag => '${Get.arguments["itemList"]}';


  @override
  Widget build(BuildContext context) {
    final String title = Get.arguments?['title'] ?? '';
    return Scaffold(
      appBar:  AppBarWidget(
        title: Text(
          title.replaceAll('*', ''),
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        leadingIcon: Icons.arrow_back,
        onTapLeadingIcon: _backPress,
      ),
      body: _Body(),
    );
  }
}

class _Body extends GetView<InvoiceAddSearchItemController> {
  // String? get tag => '${Get.arguments["itemList"]}';
  @override
  final controller = Get.put(InvoiceAddSearchItemController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller.searchController,
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                controller.onChangeSearchValue();
              },
              focusNode: controller.searchFocus,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[300],
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none, // Remove the border when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none, // Remove the border when enabled
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clearSearch();
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Expanded(
          //   child: Obx(
          //         () =>
          //         Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: ListView.separated(
          //             separatorBuilder: (BuildContext context, int index) {
          //               print(
          //                   "<<<<<<<<<<<<<<<<<<<<<<<${jsonEncode(
          //                       controller.itemsList)}");
          //               return const Divider(
          //                 height: 0,
          //               );
          //             },
          //             itemCount: (controller.itemsList[controller.colName] ?? []).length,
          //             itemBuilder: (BuildContext context, int index) {
          //               print("___________________${controller.colName}");
          //               return InkWell(
          //                 onTap: () {
          //                   ///passing the selected item to previous screen
          //                   Get.back(result: [
          //                       {
          //                       'itemCode': controller
          //                           .itemsList[controller.colName]?[index].valueField
          //                           .toString(),
          //                       'itemName': controller
          //                           .itemsList[controller.colName]?[index].textField
          //                           .toString(),
          //                       }
          //                       ]);
          //                 },
          //                 child: Padding(
          //                   padding: const EdgeInsets.symmetric(
          //                       horizontal: 10.0, vertical: 14),
          //                   child: Row(
          //                     children: [
          //                       Text(
          //                         "${controller.itemsList[controller
          //                             .colName]![index].valueField}:${controller
          //                             .itemsList[controller.colName]![index]
          //                             .textField}",
          //                         style: const TextStyle(color: Colors.black),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               );
          //             },
          //           ),
          //         ),
          //   ),
          // ),
          Expanded(
            child: Obx(
              () {
                return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    debugPrint("..............samplet");
                    return const Divider(
                      height: 0,
                    );
                  },
                  itemCount: controller.searchList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if(controller.searchList.isEmpty){
                      const Center(child: Text("No data",style: TextStyle(color: Colors.black),),);
                    }else {
                      print("___________________colname${controller.colName}");
                      return InkWell(
                        onTap: () {
                          var selectedItem = controller.searchList[index];
                          Get.back(
                              result: {
                            'itemList': controller.itemsList,
                            'colName': controller.colName,
                            'index': index,
                            'selectedItem': selectedItem,
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${controller.searchList[index]
                                      .valueField}:${controller
                                      .searchList[index].textField}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
                // }
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _backPress() {
  Get.back();
}
