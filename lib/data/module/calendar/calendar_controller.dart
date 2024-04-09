import 'package:get/get.dart';

class CalenderController extends GetxController {
  // final event_editor =  MonthViewSettings(showAgenda: true);

  // final CalendarController calendarController = CalendarController();
  // final CalendarView _view = CalendarView.week;

  final date = DateTime.now().obs;
  DateTime get selectedDate => date.value;

  void onDateSelected(DateTime value) {
    date.value = value;
  }
}
