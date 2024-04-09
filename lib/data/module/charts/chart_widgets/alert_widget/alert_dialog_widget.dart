import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:rapid_app/data/module/charts/chart_widgets/alert_widget/commn_alert_widget.dart';
import 'package:rapid_app/data/module/charts/chart_widgets/common_radio_widget.dart';
import 'package:rapid_app/data/widgets/button/login_button_widget.dart';
import '../../../../../res/utils/rapid_pref.dart';
import '../../../../model/local_notification/local_notification.dart';
import '../../chart_controller.dart';
import '../notification/notification_controller.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key,
        required this.controller,
        required this.index,
        required this.tabIndex});

  final ChartController controller;
  final int index;
  final int tabIndex;

  // void saveNotification() async {
  //   // Open the Hive box
  //   controller.box = await Hive.openBox(controller.projectName ?? '');
  //   // Get the existing list of notifications from Hive
  //   List<LocalNotificationTable> storedNotifications =
  //   (controller.box.get('notification') as List<dynamic>)
  //       .cast<LocalNotificationTable>();
  //   debugPrint("......notification${controller.box.get('notification')}");
  //   // Check if there is an existing notification for the current chart item
  //   int existingIndex = storedNotifications.indexWhere(
  //           (item) => item.tabIndex == tabIndex && item.index == index);
  //   // Get the adjusted date and time for the notification
  //   DateTime adjustedDateTime = await controller.convertToDateTime(
  //       controller.selectedTime.value,
  //       controller.selectedDate.value,
  //       index,
  //       tabIndex);
  //   // If an existing notification is found, update its date and time
  //   if (existingIndex != -1) {
  //     storedNotifications[existingIndex].dateTime = adjustedDateTime;
  //   } else {
  //     // Otherwise, create a new notification and add it to the list
  //     LocalNotificationTable newNotification = LocalNotificationTable(
  //       tabIndex: tabIndex,
  //       dateTime: adjustedDateTime,
  //       index: index,
  //       radioButtonvalue: controller.radioController.selectedOption.value,
  //     );
  //     storedNotifications.add(newNotification);
  //   }
  //   // Save the updated list of notifications back to Hive
  //   controller.box.put('notification', storedNotifications);
  //   // Close the Hive box
  //   await controller.box.close();
  //   // Show notifications
  //   for (var i = 0; i < storedNotifications.length; i++) {
  //     LocalNotificationTable notification = storedNotifications[i];
  //     LocalNotificationService.showNotification(
  //       id: i,
  //       title: 'Notification Title',
  //       body: 'Notification Body',
  //       scheduleTime: notification.dateTime,
  //       payload: 'Notification Payload',
  //     );
  //   }
  //   // Close the dialog
  //   Get.back();
  // }





  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context, 'Notifications Settings'),
    );
  }

  dialogContent(BuildContext context, title) {
    controller.radioController.selectedOption.value = controller.pref.getInt('radioButton') ?? 1;
    debugPrint("..............StoredRadioValue${controller.radioController.selectedOption.value}");
    String savedDateTimeString = controller.pref.getString('combinedDateTime') ?? "";
    controller.selectedDate.value = DateTime.tryParse(savedDateTimeString) ?? DateTime.now();
    debugPrint("..............selectedDate${controller.selectedDate.value}");
    DateTime savedDateTime = DateTime.tryParse(savedDateTimeString) ?? DateTime.now();
    controller.selectedTime.value = TimeOfDay.fromDateTime(savedDateTime);
    debugPrint("..............selected time${controller.selectedTime.value}");
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Positioned(
            left: MediaQuery.of(context).size.width * 0.65,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Positioned(
            top: 35,
            left: 20,
            right: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  margin: const EdgeInsets.only(bottom: 10),
                  color: Colors.grey.withOpacity(0.2),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.notifications_none_outlined,
                        size: 25,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "Select Daily or Monthly Updates",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Obx(() => RadioButtom(
                      radio: Radio<int>(
                        value: 1,
                        groupValue:
                        controller.radioController.selectedOption.value,
                        activeColor: Colors.blue,
                        onChanged: (int? value) {
                          if (value != null) {
                            controller.radioController
                                .setSelectedOption(value);
                            debugPrint(
                                "Selected Option: ${controller.radioController.selectedOption.value}");
                          }
                        },
                      ),
                      text: 'Daily',
                    )),
                    const SizedBox(
                      width: 15,
                    ),
                    Obx(() => RadioButtom(
                      radio: Radio<int>(
                        value: 2,
                        groupValue:
                        controller.radioController.selectedOption.value,
                        activeColor: Colors.blue,
                        onChanged: (int? value) {
                          if (value != null) {
                            controller.radioController
                                .setSelectedOption(value);
                            debugPrint(
                                "Selected Option: ${controller.radioController.selectedOption.value}");
                          }
                        },
                      ),
                      text: 'Monthly',
                    )),
                  ],
                ),
                const Text(
                  'Select Date and Time',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(() {
                  if (controller.radioController.selectedOption.value == 1) {
                    return AlertDialoge(
                      icon: Icons.access_time,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: controller.selectedTime.value,
                        );
                        if (pickedTime != null &&
                            pickedTime != controller.selectedTime.value) {
                          controller.selectedTime.value = pickedTime;
                        }
                      },
                      text: controller.selectedTime.value.format(context),
                    );
                  } else if (controller.radioController.selectedOption.value ==
                      2) {
                    return Row(
                      children: [
                        AlertDialoge(
                          icon: Icons.calendar_month_outlined,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: controller.selectedDate.value,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null &&
                                pickedDate != controller.selectedDate.value) {
                              controller.selectedDate.value = pickedDate;
                              // controller.saveSelectedDate(controller.selectedDate.value);
                            }
                          },
                          text: DateFormat('yyyy-MM-dd')
                              .format(controller.selectedDate.value),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        AlertDialoge(
                          icon: Icons.access_time,
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: controller.selectedTime.value,
                            );
                            if (pickedTime != null &&
                                pickedTime != controller.selectedTime.value) {
                              controller.selectedTime.value = pickedTime;
                              // controller.saveSelectedTime(controller.selectedTime.value,context);
                            }
                          },
                          text: controller.selectedTime.value.format(context),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  // width: 220,
                  height: 50,
                  child: LoginButtonWidget(
                    label: 'ok',
                    onTap: () async {
                      Box box;
                      var projectName = RapidPref().getProjectKey();
                      box = Hive.box(projectName ?? '');
                      try {
                        debugPrint("................working 1");
                        box = await Hive.openBox(projectName ?? '');
                        LocalNotificationTable notificationTable = LocalNotificationTable(
                          tabIndex: tabIndex,
                          dateTime: await controller.convertToDateTime(
                            controller.selectedTime.value,
                            controller.selectedDate.value,
                            index,
                            tabIndex,
                          ),
                          index: index,
                          radioButtonvalue: controller.radioController.selectedOption.value,
                        );
                        controller.localNotificationList.add(notificationTable);
                        debugPrint('......datalist:${controller.localNotificationList}');
                        box.put('notification', controller.localNotificationList);
                        debugPrint(".........table ${notificationTable.dateTime}");
                        debugPrint('......datalist:${notificationTable.index}');
                      } catch (error) {
                        debugPrint("................working 3: $error");
                      }
                      var storedNotifications = box.get('notification') ?? <LocalNotificationTable>[];
                      controller.localNotificationList = storedNotifications.cast<LocalNotificationTable>();
                      for (var i = 0; i < controller.localNotificationList.length; i++) {
                        LocalNotificationTable notification = controller.localNotificationList[i];
                        LocalNotificationService.showNotification(
                          id: i,
                          title: 'Notification Title',
                          body: 'Notification Body',
                          scheduleTime: notification.dateTime,
                          payload: 'Notification Payload', index: index,
                        );
                      }
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
