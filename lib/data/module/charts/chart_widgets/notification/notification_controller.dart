import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../chart_screen_short/chart_screenshot_binding.dart';
import '../../../chart_screen_short/chart_screenshot_page.dart';
import '../../chart_controller.dart';

class LocalNotificationService {
  static final _LocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final BehaviorSubject<String?> onNotification = BehaviorSubject();

  LocalNotificationService() {
    initialize();
  }

  Future<void> initialize() async {
    debugPrint('Initializing LocalNotificationService...');
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationSettingsIos = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIos);

    _LocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        final localNotificationService = LocalNotificationService();
        localNotificationService.onSelectedNotification('payload',0);
      },
    );

  }

  static Future<NotificationDetails> notificationDetails() async {
    debugPrint("..........notification-details");
    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
    );
    const iOSDetails = DarwinNotificationDetails();
    return const NotificationDetails(android: androidDetails, iOS: iOSDetails);
  }
  static Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required int index, // Pass index here
    required DateTime scheduleTime,
  }) async {
    debugPrint("..........shownotification");
    await _LocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduleTime, tz.local),
      await notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // onSelectedNotification(payload, index) {
  //   if (payload != null && payload.isNotEmpty) {
  //     final ChartController controller = Get.put(ChartController());
  //     Get.to(() => const ChartScreenshotPage(),
  //         arguments: {
  //           'chartTableList': controller.chartTable[index],
  //           'chartGraphTableList': controller.chartGraphTable[index],
  //           '_getColumnsByString': controller.getColumnsByString(
  //             id: controller.chartTable[index].cSysId,
  //           ),
  //           '_getColumnsByDate': controller.getColumnsByDate(
  //             id: controller.chartTable[index].cSysId,
  //           ),
  //         },
  //         binding: ChartScreenshotBinding());
  //     debugPrint("index.........$index");
  //   }
  // }


  void onSelectedNotification(String? payload, int index) {
    if (payload != null && payload.isNotEmpty) {
      final ChartController controller = Get.find(); // Access existing controller instance
      Get.to(() => const ChartScreenshotPage(),
          arguments: {
            'chartTableList': controller.chartTable[index],
            'chartGraphTableList': controller.chartGraphTable[index],
            '_getColumnsByString': controller.getColumnsByString(
              id: controller.chartTable[index].cSysId,
            ),
            '_getColumnsByDate': controller.getColumnsByDate(
              id: controller.chartTable[index].cSysId,
            ),
          },
          binding: ChartScreenshotBinding());
      debugPrint("index.........$index");
    }
  }
}
