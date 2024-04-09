import 'package:hive/hive.dart';

part 'local_notification.g.dart';

@HiveType(typeId: 9)
class LocalNotificationTable {
  LocalNotificationTable(
      {required this.tabIndex,
      required this.dateTime,
      required this.index,
      required this.radioButtonvalue});

  @HiveField(0)
  int tabIndex;

  @HiveField(1)
  int index;

  @HiveField(2)
  DateTime dateTime;

  @HiveField(3)
  int radioButtonvalue;
}
