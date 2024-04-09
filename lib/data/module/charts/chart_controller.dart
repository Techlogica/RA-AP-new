import 'dart:async';
import 'dart:convert';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rapid_app/data/model/chart_dashboard_model/chart_dashboard_response.dart';
import 'package:rapid_app/data/model/chart_graph_model/chart_graph_response.dart';
import 'package:rapid_app/data/model/chart_model/chart_response.dart';
import 'package:rapid_app/data/model/chart_tab_model/chart_tab_response.dart';
import 'package:rapid_app/data/model/metadata_columns_model/metadata_columns_response.dart';
import 'package:rapid_app/data/model/metadata_command_model/metadata_command_response.dart';
import 'package:rapid_app/data/model/metadata_table_model/metadata_table_response.dart';
import 'package:rapid_app/data/module/charts/chart_widgets/notification/notification_controller.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/default_concatenator.dart';
import 'package:rapid_app/res/utils/rapid_controller.dart';
import 'package:rapid_app/res/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../../../res/utils/rapid_pref.dart';
import '../../model/local_notification/local_notification.dart';
import '../chart_screen_short/chart_screenshot_controller.dart';
import '../chart_screen_short/chart_screenshot_page.dart';
import 'chart_widgets/alert_widget/alert_controller.dart';
import 'chart_widgets/notification/testing.dart';

class PriceMap {
  int id;
  String price;

  PriceMap({
    required this.id,
    required this.price,
  });
}

class ChartController extends RapidController
    with GetSingleTickerProviderStateMixin {
  RxList<Tab> tabs = <Tab>[].obs;
  RxList<ChartTabResponse> chartTabTable = RxList<ChartTabResponse>([]);
  late TabController tabController;
  RxList<ChartDashboardResponse> chartDashboardTable =
      RxList<ChartDashboardResponse>([]);
  RxList<ChartDashboardResponse> chartDashboardAllDataTable =
      RxList<ChartDashboardResponse>([]);
  RxList<ChartDashboardResponse> chartDashboardTableWithSocialMedia =
      RxList<ChartDashboardResponse>([]);
  RxList<ChartDashboardResponse> chartDashboardTableWithHtml =
      RxList<ChartDashboardResponse>([]);
  RxList<PriceMap> priceMaps = RxList([]);
  RxList<ChartResponse> chartTable = RxList([]);
  RxList<ChartGraphResponse> chartGraphTable = RxList([]);

  List<LocalNotificationTable> localNotificationList = [];

  Rx<bool> isIndicatorVisibility = true.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  RxString tabSysId = ''.obs;
  RxString item = ''.obs;
  RxInt tabDataCount = 0.obs;
  RxInt index = 0.obs;
  RxBool notify = false.obs;
  Map<int, List<DateTime>> mapAlertList = {};
  // Map<int, List<DateTime>> mapAlertsharedpreference = {};
  final RadioButtonController radioController =
      Get.put(RadioButtonController());
  late SharedPreferences pref;
  late final LocalNotificationService service;
  late Box box;
  var projectName = RapidPref().getProjectKey();
  late LocalNotificationTable notificationTable;
  @override
  Future<void> onInit() async {
    super.onInit();
    _fetchChartTabs();
    tz.initializeTimeZones();
    notificationTable = LocalNotificationTable(
        tabIndex: 0, dateTime: DateTime.now(), index: 0, radioButtonvalue: 1);
    service = LocalNotificationService();
    service.initialize();
    box = await Hive.openBox(projectName ?? '');
    var notificationtable = box.get('notification');
    debugPrint("********tableinhive $notificationtable");
    // mapAlertList[0] ??= [];
    // mapAlertList[0]!.add(DateTime.now());
    // debugPrint(".......initallist$mapAlertList");
    // listenToNotification();
    getSharedPrefernce();
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
    tabs.clear();
    chartTabTable.clear();
  }

  /// chart tabs
  void _fetchChartTabs() async {
    final isChartTabEmpty = await dbAccess.isTableEmpty(Strings.kChartTabTable);
    if (isChartTabEmpty) {
      if (tabSysId.value == "-1") {
        _fetchChartDashboard();
        _fetchCharts();
      } else {
        fetchChartTabFromApi();
      }
    } else {
      fetchChartTabFromLocalDb();
    }
  }

  getSharedPrefernce() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<DateTime> convertToDateTime(
      TimeOfDay time, DateTime pickedDate, int index, int tabIndex) async {
    DateTime currentDate = DateTime.now();
    DateTime combinedDateTime;
    if (radioController.selectedOption.value == 2) {
      // Monthly notification
      combinedDateTime = DateTime(
        currentDate.year,
        currentDate.month,
        pickedDate.day,
        time.hour,
        time.minute,
      );
    } else {
      // Daily notification
      combinedDateTime = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        time.hour,
        time.minute,
      );
    }
    mapAlertList[tabIndex] ??= [];
    if (mapAlertList[tabIndex]!.length > index) {
      mapAlertList[tabIndex]?[index] = combinedDateTime;
    } else {
      for (int i = mapAlertList[tabIndex]!.length; i <= index; i++) {
        mapAlertList[tabIndex]?.add(DateTime(1970, 1, 1, 0, 0));
      }
      mapAlertList[tabIndex]?[index] = combinedDateTime;
      debugPrint(".......mapcheck${mapAlertList[tabIndex]?[index]}");
      debugPrint(".......map$mapAlertList");
    }

    // final mapList = mapAlertList.toString();
    // pref.setString('mapAlertList', mapList);
    pref.setInt('radioButton', radioController.selectedOption.value);
    pref.setString('combinedDateTime', combinedDateTime.toIso8601String());
    debugPrint(".......$combinedDateTime");
    return combinedDateTime;
  }
  // Future<DateTime> convertToDateTime(TimeOfDay time, DateTime pickedDate, int index, int tabIndex) async {
  //   DateTime combinedDateTime;
  //   if (radioController.selectedOption.value == 2) {
  //     // Monthly notification
  //     combinedDateTime = DateTime(
  //       pickedDate.year,
  //       pickedDate.month,
  //       pickedDate.day,
  //       time.hour,
  //       time.minute,
  //     );
  //     // Check if the combinedDateTime is in the past, if so, increment the month
  //     if (combinedDateTime.isBefore(DateTime.now())) {
  //       combinedDateTime = combinedDateTime.add(Duration(days: 1));
  //     }
  //   } else {
  //     // Daily notification
  //     combinedDateTime = DateTime(
  //       DateTime.now().year,
  //       DateTime.now().month,
  //       DateTime.now().day,
  //       time.hour,
  //       time.minute,
  //     );
  //     // Check if the combinedDateTime is in the past, if so, increment the day
  //     if (combinedDateTime.isBefore(DateTime.now())) {
  //       combinedDateTime = combinedDateTime.add(const Duration(days: 1));
  //     }
  //   }
  //   // Store the adjusted date and time in Hive
  //   pref.setInt('radioButton', radioController.selectedOption.value);
  //   pref.setString('combinedDateTime', combinedDateTime.toIso8601String());
  //   debugPrint("Adjusted Combined DateTime: $combinedDateTime");
  //   return combinedDateTime;
  // }

  List<ColumnSeries> getColumnsByDate({required int id}) {
    List<ChartGraphResponse> data = filterData(id: id);
    List<String> distinctKey = data
        .distinct((d) => d.csFilter)
        .select((element, index) => element.csFilter)
        .toList();

    return <ColumnSeries>[
      for (int i = 0; i < distinctKey.length; ++i)
        ColumnSeries<ChartGraphResponse, DateTime>(
          dataSource: data
              .where((element) => element.csFilter == distinctKey[i].toString())
              .toList(),
          xValueMapper: (ChartGraphResponse value, _) =>
              value.csDate ?? DateTime.now(),
          yValueMapper: (ChartGraphResponse value, _) => value.csValue,
          name: distinctKey[i].toString(),
        ),
    ];
  }

  List<ColumnSeries> getColumnsByString({required int id}) {
    List<ChartGraphResponse> data = filterData(id: id);
    List<String> distinctKey = data
        .distinct((d) => d.csFilter)
        .select((element, index) => element.csFilter)
        .toList();
    return <ColumnSeries>[
      for (int i = 0; i < distinctKey.length; ++i)
        ColumnSeries<ChartGraphResponse, String>(
          isTrackVisible: true,
          spacing: 0.5,
          dataSource: data
              .where((element) => element.csFilter == distinctKey[i].toString())
              .toList(),
          xValueMapper: (ChartGraphResponse value, _) => value.csKey,
          yValueMapper: (ChartGraphResponse value, _) => value.csValue,
          name: distinctKey[i].toString(),
        ),
    ];
  }

  Future<void> fetchChartTabFromApi() async {
    // Getting meta data frm the API
    final chartTabResponse = await apiClient.rapidRepo.getChartTabs();
    if (chartTabResponse.status) {
      _saveChartTabsToLocalDb(chartTabResponse.data);
      fetchChartTabFromLocalDb();
    } else {
      isIndicatorVisibility.value = false;
    }
  }

  // Future<DateTime> convertToDateTime(TimeOfDay time,DateTime pickedDate) async{
  //   DateTime currentDate=DateTime.now();
  //   DateTime combinedDateTime=DateTime(currentDate.year,currentDate.month,
  //    radioController.selectedOption.value==2?pickedDate.day:currentDate.day,time.hour,time.minute);
  //   SharedPreferences prefs=await SharedPreferences.getInstance();
  //   prefs.setString('combinedDateTime', combinedDateTime.toIso8601String());
  //   prefs.setInt('radioButton', radioController.selectedOption.value);
  //   debugPrint(".......$combinedDateTime");
  //   return combinedDateTime;
  // }

  Future<void> fetchChartTabFromLocalDb() async {
    //open database
    Box box = await dbAccess.openDatabase();
    chartTabTable.clear();
    // read metadata table values
    List<ChartTabResponse> chartTabTableData =
        box.get(Strings.kChartTabTable).toList().cast<ChartTabResponse>();
    if (chartTabTableData.isNotEmpty) {
      chartTabTable.value = chartTabTableData;
      onTapTab(0);
    } else {
      isIndicatorVisibility.value = false;
    }
    tabs = getTabs(chartTabTable);
    tabController = getTabController();
  }

  void _saveChartTabsToLocalDb(dynamic chartTabData) {
    if (chartTabData.length == 0) {
      tabSysId.value = "-1";
    }
    for (int i = 0; i < chartTabData.length; ++i) {
      String res = json.encode(chartTabData[i]);
      final jsonDecode = json.decode(res);
      ChartTabResponse data = ChartTabResponse.fromJson(jsonDecode);
      chartTabTable.add(data);
    }
    addChartTab();
  }

  addChartTab() async {
    //open database
    Box box = await dbAccess.openDatabase();
    // add value to table
    box.put(Strings.kChartTabTable, chartTabTable.toList());
  }

  RxList<Tab> getTabs(RxList<ChartTabResponse> chartTabs) {
    // tabs.clear();
    for (int i = 0; i < chartTabs.length; i++) {
      tabs.add(getTab(chartTabs[i].cgGrpName.toString()));
    }
    return tabs;
  }

  TabController getTabController() {
    return TabController(length: tabs.length, vsync: this);
  }

  Tab getTab(String name) {
    return Tab(
      text: name,
    );
  }

  void onTapTab(int index) {
    //index change to sysId. if no id then -1
    chartTable.clear();
    chartGraphTable.clear();
    chartDashboardTable.clear();
    chartDashboardTableWithSocialMedia.clear();
    chartDashboardTableWithHtml.clear();
    tabSysId.value = chartTabTable[index].cgSysId.toString();
    _fetchChartDashboard();
    _fetchCharts();
  }

  /// chart dashboard
  void _fetchChartDashboard() async {
    final isChartDashboardEmpty =
        await dbAccess.isTableEmpty(Strings.kChartDashboardTable);
    if (isChartDashboardEmpty) {
      await fetchChartDashboardFromApi();
    } else {
      fetchChartDashboardFromLocalDb();
    }
  }

  Future<void> fetchChartDashboardFromApi() async {
    // Getting meta data frm the API
    final chartDashboardResponse =
        await apiClient.rapidRepo.getChartDashboard();
    if (chartDashboardResponse.status) {
      _saveChartDashboardToLocalDb(chartDashboardResponse.data);
      fetchChartDashboardFromLocalDb();
    } else {
      isIndicatorVisibility.value = false;
    }
  }

  void _saveChartDashboardToLocalDb(dynamic chartDashboardData) {
    for (int i = 0; i < chartDashboardData.length; ++i) {
      String res = json.encode(chartDashboardData[i]);
      final jsonDecode = json.decode(res);
      ChartDashboardResponse data =
          ChartDashboardResponse.fromJson(jsonDecode, '');
      chartDashboardAllDataTable.add(data);
    }
    addChartDashboard();
  }

  addChartDashboard() async {
    //open database
    Box box = await dbAccess.openDatabase();
    // add value to table
    chartDashboardAllDataTable.sort((a, b) => a.mtdSeqNo.compareTo(b.mtdSeqNo));
    box.put(Strings.kChartDashboardTable, chartDashboardAllDataTable.toList());
  }

  Future<void> fetchChartDashboardFromLocalDb() async {
    //open database
    Box box = await dbAccess.openDatabase();
    chartDashboardTable.clear();
    chartDashboardTableWithSocialMedia.clear();
    chartDashboardTableWithHtml.clear();
    // read metadata table values
    List<ChartDashboardResponse> chartDashboardTableData = box
        .get(Strings.kChartDashboardTable)
        .toList()
        .cast<ChartDashboardResponse>();

    if (chartDashboardTableData.isNotEmpty) {
      List<ChartDashboardResponse> dashboardTable;
      List<ChartDashboardResponse> dashboardTableSocialMedia;
      List<ChartDashboardResponse> dashboardTableHtml;
      if (tabSysId.value == "-1") {
        dashboardTable = chartDashboardTableData
            .where((element) =>
                element.mtdType != 'SOCIALMEDIA' && element.mtdType != 'HTML')
            .toList();
        dashboardTableSocialMedia = chartDashboardTableData
            .where((element) => element.mtdType == 'SOCIALMEDIA')
            .toList();
        dashboardTableHtml = chartDashboardTableData
            .where((element) => element.mtdType == 'HTML')
            .toList();
      } else {
        dashboardTable = chartDashboardTableData
            .where((element) =>
                element.mtduCgSysId == int.parse(tabSysId.value) &&
                element.mtdType != 'SOCIALMEDIA' &&
                element.mtdType != 'HTML')
            .toList();
        dashboardTableSocialMedia = chartDashboardTableData
            .where((element) =>
                element.mtduCgSysId == int.parse(tabSysId.value) &&
                element.mtdType == 'SOCIALMEDIA')
            .toList();
        dashboardTableHtml = chartDashboardTableData
            .where((element) =>
                element.mtduCgSysId == int.parse(tabSysId.value) &&
                element.mtdType == 'HTML')
            .toList();
      }
      if (dashboardTable.isNotEmpty) {
        // sort list data
        dashboardTable.sort((a, b) => a.mtdSeqNo.compareTo(b.mtdSeqNo));
        for (int i = 0; i < dashboardTable.length; ++i) {
          dashboardTable[i].mtdText = await defaultConcatenation(
              formula: dashboardTable[i].mtdText.toString());
        }
        chartDashboardTable.value = dashboardTable;
        tabDataCount.value = tabDataCount.value + chartDashboardTable.length;
      }
      if (dashboardTableSocialMedia.isNotEmpty) {
        // sort list data
        dashboardTableSocialMedia
            .sort((a, b) => a.mtdSeqNo.compareTo(b.mtdSeqNo));
        chartDashboardTableWithSocialMedia.value = dashboardTableSocialMedia;
        tabDataCount.value =
            tabDataCount.value + chartDashboardTableWithSocialMedia.length;
      }
      if (dashboardTableHtml.isNotEmpty) {
        // sort list data
        dashboardTableHtml.sort((a, b) => a.mtdSeqNo.compareTo(b.mtdSeqNo));
        chartDashboardTableWithHtml.value = dashboardTableHtml;
        tabDataCount.value =
            tabDataCount.value + chartDashboardTableWithHtml.length;
      }
    }
  }

  /// chart dashboard amount
  Future<void> loadPrice({required int index}) async {
    final id = chartDashboardTable[index].mtdSysId;
    final response = await apiClient.rapidRepo.getChartDashboardPrice(
      query: await defaultConcatenation(
          formula: chartDashboardTable[index].mtdQuery.toString()),
    );

    String dataVal = response.data == null
        ? chartDashboardTable[index].mtdQueryValue!
        : response.data[0]['COUNT'].toString();

    List<int> priceIds = priceMaps.map((element) => element.id).toList();
    if (priceIds.contains(id)) {
      priceMaps[index] = PriceMap(
        id: id,
        price: dataVal,
      );
    } else {
      priceMaps.add(
        PriceMap(
          id: id,
          price: dataVal,
        ),
      );
    }

    chartDashboardTable[index].mtdQueryValue =
        response.data[0]['COUNT'].toString() == 'null'
            ? ''
            : response.data[0]['COUNT'].toString();

    // open database
    // Box box = await dbAccess.openDatabase();
    // box.put(Strings.kChartDashboardTable, chartDashboardTable);
  }

  PriceMap? price({required int id}) {
    for (var value in priceMaps) {
      if (value.id == id) {
        return value;
      }
    }
    return null;
  }

  /// charts
  void _fetchCharts() async {
    final isChartDataEmpty = await dbAccess.isTableEmpty(Strings.kCharts);
    if (isChartDataEmpty) {
      await fetchChartFromApi();
    } else {
      fetchChartFromLocalDb();
    }
  }

  Future<void> fetchChartFromApi() async {
    final chartDataResponse = await apiClient.rapidRepo.getCharts();
    if (chartDataResponse.status) {
      _saveChartToLocalDb(chartDataResponse.data);
      fetchChartFromLocalDb();
    } else {
      isIndicatorVisibility.value = false;
    }
  }

  Future<void> fetchChartFromLocalDb() async {
    //open database
    Box box = await dbAccess.openDatabase();
    chartTable.clear();
    // read metadata table values
    List<ChartResponse> chartTableData =
        box.get(Strings.kCharts).toList().cast<ChartResponse>();
    if (chartTableData.isNotEmpty) {
      List<ChartResponse> chartResponse;
      if (tabSysId.value == "-1") {
        chartResponse = chartTableData.toList();
      } else {
        chartResponse = chartTableData
            .where((element) => element.cCgGroupId == int.parse(tabSysId.value))
            .toList();
      }
      if (chartResponse.isNotEmpty) {
        chartTable.value = chartResponse;
        tabDataCount.value = tabDataCount.value + chartTable.length;
      }
    }
  }

  void _saveChartToLocalDb(dynamic chartTableData) {
    for (int i = 0; i < chartTableData.length; ++i) {
      String res = json.encode(chartTableData[i]);
      final jsonDecode = json.decode(res);
      ChartResponse data = ChartResponse.fromJson(jsonDecode);
      chartTable.add(data);
    }
    addChart();
  }

  addChart() async {
    //open database
    Box box = await dbAccess.openDatabase();
    // add value to table
    box.put(Strings.kCharts, chartTable.toList());
  }

  /// chart graph
  Future<void> loadChartGraph({required int index}) async {
    final id = chartTable[index].cSysId;
    final response = await apiClient.rapidRepo.getChartGraph(
      query:
          await defaultConcatenation(formula: chartTable[index].cQueryString),
    );
    if (response.status) {
      dynamic graphResponse = response.data;
      for (int i = 0; i < graphResponse.length; ++i) {
        String res = json.encode(graphResponse[i]);
        final jsonDecode = json.decode(res);
        final data = ChartGraphResponse.fromJson(jsonDecode, id);
        chartGraphTable.add(data);
      }
    }
  }

  ChartGraphResponse? graphData({required int id}) {
    for (var value in chartGraphTable) {
      if (value.id == id) {
        return value;
      }
    }
    return null;
  }

  List<ChartGraphResponse> filterData({required int id}) {
    List<ChartGraphResponse> data = [];
    for (var value in chartGraphTable) {
      if (value.id == id) {
        data.add(value);
      }
    }
    return data;
  }

  Future fetchDashboardGrid(int? mtdMdpSysId, String type) async {
    //open database
    Box box = await dbAccess.openDatabase();
    // read metadata table values
    List<MetadataTableResponse> metadataTableData =
        box.get(Strings.kMetadataTable).toList().cast<MetadataTableResponse>();

    if (metadataTableData.isNotEmpty) {
      List<MetadataTableResponse> clickedMenuTable = metadataTableData
          .where((element) => element.mdtSysId == mtdMdpSysId)
          .toList();

      if (clickedMenuTable.isNotEmpty) {
        /// call onTap function
        _onTapDashboard(
          clickedMenuTable[0].mdtSysId,
          clickedMenuTable[0].mdtTblName,
          clickedMenuTable[0].mdtTblTitle,
          clickedMenuTable[0].mdtDefaultwhere,
          clickedMenuTable[0].mdtIsmenuchld,
          clickedMenuTable[0].mdtInsert ?? 'N',
          clickedMenuTable[0].mdtUpdate,
          clickedMenuTable[0].mdtDelete,
          type,
        );
      }
    }
  }

  _onTapDashboard(
    int? mdtSysId,
    String? menuName,
    String? menuTitle,
    String? defaultCondition,
    String? isChild,
    String? isInsert,
    String? isUpdate,
    String? isDelete,
    String type,
  ) async {
    Map<String, dynamic> editData = {}; // parent table data
    Map<String, dynamic> parentRowData = {}; // parent table data
    List<MetadataCommandResponse> parentButtonList = []; // parent table buttons
    defaultCondition ??= '';

    if (type == 'grid') {
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
          "EDIT_DATA": editData,
          "BUTTON_LIST": parentButtonList,
          "PARENT_ROW": parentRowData,
          "PARENT_TABLE": '',
        },
      );
    } else {
      String keyInfo = '';
      //open database
      Box box = await dbAccess.openDatabase();
      // read metadata columns table value
      List<MetadataColumnsResponse> gridTableTitles = box
          .get(Strings.kMetadataColumns + mdtSysId.toString())
          .toList()
          .cast<MetadataColumnsResponse>();

      if (gridTableTitles.isNotEmpty) {
        /// fetch keyInfo value
        keyInfo = gridTableTitles
            .where((element) => element.mdcKeyinfo == 'PK')
            .first
            .mdcColName;
      }
      Get.toNamed(
        Strings.kMenuDetailsNewEditPage,
        arguments: {
          "MDT_SYS_ID": mdtSysId,
          "MENU_NAME": menuName,
          "MENU_TITLE": menuTitle,
          "MDT_DEFAULT_WHERE": defaultCondition,
          "KEY_INFO": keyInfo,
          Strings.kMode: Strings.kParamNew,
          "BUTTON_LIST": parentButtonList,
          "PARENT_ROW": parentRowData,
          "PARENT_TABLE": '',
        },
      );
    }
  }

  // void listenToNotification() {
  //   LocalNotificationService.onNotification.stream.listen(onNotificationListner);
  // }
  //
  // void onNotificationListner(String? payload) {
  //   // final ChartScreenshotController controller = Get.put(ChartScreenshotController());
  //   if(payload != null && payload.isNotEmpty){
  //     debugPrint('.............gettopayload $payload');
  //     // Get.to(() =>  const ChartScreenshotPage());
  // }
  // }
}
