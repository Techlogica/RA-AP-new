


import 'package:get/get.dart';
import 'package:rapid_app/data/module/subpage/menu_detailed_page_search/search_widgets/invoide_add_search_item_page/invoice_add_search_item_controller.dart';
import '../../../../../database/database_operations.dart';

class InvoiceAddSearchItemBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => InvoiceAddSearchItemController());
    Get.lazyPut(()=>DatabaseOperations());
  }

}