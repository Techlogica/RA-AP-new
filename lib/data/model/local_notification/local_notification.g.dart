// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalNotificationTableAdapter
    extends TypeAdapter<LocalNotificationTable> {
  @override
  final int typeId = 9;

  @override
  LocalNotificationTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalNotificationTable(
      tabIndex: fields[0] as int,
      dateTime: fields[2] as DateTime,
      index: fields[1] as int,
      radioButtonvalue: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LocalNotificationTable obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tabIndex)
      ..writeByte(1)
      ..write(obj.index)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.radioButtonvalue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalNotificationTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
