import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/model/combo_box_model/lookup_response.dart';
import '../../../../../../res/utils/rapid_controller.dart';

class InvoiceAddSearchItemController extends RapidController {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  RxList<LookupResponse> searchList = RxList<LookupResponse>();
  RxMap<String, List<LookupResponse>> itemsList = RxMap({});
  String colName = "";
  RxBool isDataLoading = false.obs, isInvoicesLocationSelected = true.obs;
  RxString invoiceLocation = ''.obs, returnLocation = ''.obs;

  @override
  void onInit() {
    getAllItemsList();
    itemsList = Get.arguments?["lookupList"] ?? '';
    colName = Get.arguments?['colName'] ?? "";
   searchList.addAll(itemsList[colName] ?? []);
    // print("//////////////////////${searchList}");
    super.onInit();
  }

  void clearSearch() {
    searchController.clear();
    getAllItemsList();
  }
  // void getAllItemsList() {
  //   searchList.clear();
  //   searchList.addAll(Get.arguments['itemsList']);
  // }

  void getAllItemsList() {
    List<LookupResponse>? itemList = Get.arguments?['itemsList'];
    if (itemList != null) {
      itemsList[colName] = itemList;
      // print("******************************${itemsList}");
      searchList.addAll(itemList);
      // print("All Items in Search List:${jsonEncode(searchList)}");
    }
  }

void onChangeSearchValue() {
  if (searchController.text.isEmpty) {
    searchList.assignAll(itemsList[colName] ?? []);
    // print("All Items in Search List:${jsonEncode(searchList)}");
  } else {
    List<LookupResponse> filteredList = (itemsList[colName] ?? []).where((element) {
      return element.textField.toLowerCase().contains(searchController.text.toLowerCase()) ||
          element.valueField.toLowerCase().contains(searchController.text.toLowerCase());
    }).toList();

    searchList.assignAll(filteredList);
    // print("Search Results:${jsonEncode(searchList)}");
  }
}

}




// void onChangeSearchValue() {
//   if (searchController.text.isEmpty) {
//     searchList.assignAll(itemsList[colName] ?? []);
//     print("All Items in Search List:${jsonEncode(searchList)}");
//   } else {
//     List<LookupResponse> filteredList = (itemsList[colName] ?? []).where((element) {
//       return element.textField.toLowerCase().contains(searchController.text.toLowerCase()) ||
//           element.valueField.toLowerCase().contains(searchController.text.toLowerCase());
//     }).toList();
//
//     searchList.assignAll(filteredList);
//     print("Search Results:${jsonEncode(searchList)}");
//   }
// }








// void changeSearchValue() {
//   if (searchController.text.isEmpty) {
//     clearSearch();
//   } else {
//     /// Filtering data
//     List<LookupResponse> searchList = itemsList
//         .where((item) =>
//         item.textField.toLowerCase().contains(
//             searchController.text.toLowerCase()))
//         .toList();
//
//     /// Updating itemsList using GetX's update method
//     itemsList.clear();
//     itemsList.addAll(searchList);
//   }
// }

