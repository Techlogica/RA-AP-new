import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'calendar_controller.dart';

class CalenderPage extends GetView<CalenderController> {
  CalenderPage({Key? key}) : super(key: key);

  @override
  final CalenderController controller = Get.put(CalenderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetCalendar(),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(
      //     Icons.add,
      //     color: Theme.of(context).iconTheme.color!,
      //   ),
      //   backgroundColor:
      //       Theme.of(context).floatingActionButtonTheme.backgroundColor,
      //   onPressed: () => Get.toNamed(Strings.kEventEditorPage,
      //       arguments: {'selectedDate': controller.selectedDate}),
      // ),
    );
  }
}

class GetCalendar extends GetView<CalenderController> {
  GetCalendar({Key? key}) : super(key: key);

  @override
  final CalenderController controller = Get.find<CalenderController>();

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        cellBorderColor: Theme.of(context).backgroundColor,
        backgroundColor: Theme.of(context).primaryColor,
        todayHighlightColor: Theme.of(context).backgroundColor,
        allowAppointmentResize: true,
        viewNavigationMode: ViewNavigationMode.snap,
        initialDisplayDate: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day, 0, 0, 0),
        view: CalendarView.month,
        allowedViews: _allowedViews,
        showDatePickerButton: true,
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            appointmentDisplayCount: 4),
        onTap: (CalendarTapDetails details) => controller.onDateSelected(details.date!),
      ),
    );
  }
}
