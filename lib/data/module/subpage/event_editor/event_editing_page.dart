import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rapid_app/data/widgets/container/card_container_widget.dart';
import 'package:rapid_app/data/widgets/tile/event_list_tile_widget.dart';
import 'package:rapid_app/res/values/colours.dart';
import 'package:rapid_app/res/values/strings.dart';
import 'event_editing_controller.dart';

class EventEditingPage extends GetView<EventEditingController> {
  const EventEditingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                //primary: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              onPressed: () {},
              child: const Text('SAVE'))
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: EventEditingWidget(
        eventNameController: controller.eventNameController,
      ),
    );
  }
}

class EventEditingWidget extends GetView<EventEditingController> {
  EventEditingWidget(
      {Key? key, required TextEditingController eventNameController})
      : _eventNameController = eventNameController,
        super(key: key);

  final TextEditingController _eventNameController;

  final List<String> itemList = [
    Strings.kNever.tr,
    Strings.kDaily.tr,
    Strings.kWeekly.tr,
    Strings.kMonthly.tr,
    Strings.kYearly.tr
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
        alignment: Alignment.topCenter,
        color: Theme.of(context).backgroundColor,
        child: CardContainerWidget(
            cardWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              // key: _fromKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: Strings.kAddTitle,
                    ),
                    onFieldSubmitted: (title) =>
                        title.isEmpty ? 'Title Cannot be empty' : null,
                    controller: _eventNameController,
                  )
                ],
              ),
            ),
            EventListTileWidget(
              titleWidget: const Text(Strings.kAllDay),
              trailingWidget: Obx(
                () => Switch(
                  value: controller.isAllDay.value,
                  onChanged: (value) {
                    controller.allButtonChange(value);
                  },
                ),
              ),
              leadingWidget: const Icon(
                Icons.access_time,
                color: colours.black,
              ),
            ),
            EventListTileWidget(
                titleWidget: Obx(
                  () => InkWell(
                    onTap: () => controller.startDatePicker(),
                    child: const SizedBox(
                      height: 35,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text(''),
                        // Text(
                        //     DateFormat('EEE, MMM dd yyyy')
                        //         .format(controller.startingDate ??
                        //             controller.initialDate.value)
                        //         .toString(),
                        //     textAlign: TextAlign.right),
                      ),
                    ),
                  ),
                ),
                trailingWidget: Obx(
                  () => controller.allDay
                      ? const Text('')
                      : SizedBox(
                          height: 35,
                          child: InkWell(
                            onTap: () => controller.startTimePicker(),
                            child: Text(
                              controller.startTime.value.isEmpty
                                  ? DateFormat.jm()
                                      .format(controller.initialDate.value)
                                      .toString()
                                  : controller.startTime.value,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                ),
                leadingWidget: Text(Strings.kStart.tr)),
            EventListTileWidget(
                titleWidget: Obx(
                  () => SizedBox(
                    height: 35,
                    child: InkWell(
                      onTap: () => controller.endDatePicker(),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text('', textAlign: TextAlign.right),
                      ),
                    ),
                  ),
                ),
                trailingWidget: Obx(
                  () => controller.allDay
                      ? const Text('')
                      : SizedBox(
                          height: 35,
                          child: InkWell(
                            onTap: () => controller.endTimePicker(),
                            child: Text(
                              controller.endTime.value.isEmpty
                                  ? DateFormat.jm()
                                      .format(controller.initialDate.value)
                                      .toString()
                                  : controller.endTime.value,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                ),
                leadingWidget: Text(Strings.kEnd.tr)),
            const Divider(
              height: 3,
              thickness: 0.5,
              color: colours.black,
            ),
          ],
        )));
  }
}
