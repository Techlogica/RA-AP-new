// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_menu_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheMenuResponseAdapter extends TypeAdapter<CacheMenuResponse> {
  @override
  final int typeId = 8;

  @override
  CacheMenuResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheMenuResponse(
      sysId: fields[1] as int,
      tableName: fields[2] as String,
      tableData: fields[3] as dynamic,
      cacheFlag: fields[4] as String,
      offlineFlag: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CacheMenuResponse obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.sysId)
      ..writeByte(2)
      ..write(obj.tableName)
      ..writeByte(3)
      ..write(obj.tableData)
      ..writeByte(4)
      ..write(obj.cacheFlag)
      ..writeByte(5)
      ..write(obj.offlineFlag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheMenuResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
