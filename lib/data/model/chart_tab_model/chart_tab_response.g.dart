// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_tab_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChartTabResponseAdapter extends TypeAdapter<ChartTabResponse> {
  @override
  final int typeId = 3;

  @override
  ChartTabResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartTabResponse(
      cgSysId: fields[1] as int,
      cgGrpName: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChartTabResponse obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.cgSysId)
      ..writeByte(2)
      ..write(obj.cgGrpName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartTabResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
