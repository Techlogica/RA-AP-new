import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventEditingController extends GetxController {
  final TextEditingController eventNameController = TextEditingController();
  dynamic arguments = Get.arguments;

  final startDate = DateTime.now().obs;
  DateTime get startingDate => startDate.value;
  final endDate = DateTime.now().obs;
  DateTime get endingDate => endDate.value;
  final initialDate = DateTime.now().obs;
  DateTime get initDate => initialDate.value;
  final initialTime = TimeOfDay.now();
  final isAllDay = false.obs;
  bool get allDay => isAllDay.value;
  RxString startTime = ''.obs;
  RxString endTime = ''.obs;
  final formKey = GlobalKey<FormState>();

  void allButtonChange(bool value) {
    isAllDay.value = value;
  }

  @override
  void onClose() {
    super.onClose();
    eventNameController.dispose();
  }

  startDatePicker() async {
    final DateTime? pickedStartDate = await showDatePicker(
        context: Get.context!,
        initialDate: initDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(3000));
    startDate.value = pickedStartDate!;
  }

  startTimePicker() async {
    TimeOfDay? pickedStartTime = await showTimePicker(
      context: Get.context!,
      initialTime: initialTime,
    );
    DateTime time = DateTime(initialDate.value.year, initialDate.value.month,
        initialDate.value.day, pickedStartTime!.hour, pickedStartTime.minute);
    startTime.value = DateFormat.jm().format(time);
  }

  endDatePicker() async {
    final DateTime? pickedEndDate = await showDatePicker(
        context: Get.context!,
        initialDate: initDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(3000));
    endDate.value = pickedEndDate!;
    if (startDate.value.isAfter(pickedEndDate)) {
      startDate.value = pickedEndDate;
    }
  }

  endTimePicker() async {
    TimeOfDay? pickedEndTime = await showTimePicker(
      context: Get.context!,
      initialTime: initialTime,
    );
    DateTime time = DateTime(initialDate.value.year, initialDate.value.month,
        initialDate.value.day, pickedEndTime!.hour, pickedEndTime.minute);
    endTime.value = DateFormat.jm().format(time);
  }

  @override
  void onInit() {
    initialDate.value = arguments['selectedDate'];
    startDate.value = initialDate.value;
    endDate.value = initialDate.value.add(const Duration(days: 1));
    super.onInit();
  }
}
