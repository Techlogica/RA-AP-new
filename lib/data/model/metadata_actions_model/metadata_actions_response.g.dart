// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_actions_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MetadataActionResponseAdapter
    extends TypeAdapter<MetadataActionResponse> {
  @override
  final int typeId = 7;

  @override
  MetadataActionResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MetadataActionResponse(
      mdaSysId: fields[1] as int,
      mdaMdcdSysId: fields[2] as int,
      mdaAction: fields[3] as String?,
      mdaArg1: fields[4] as String?,
      mdaArg2: fields[5] as String?,
      mdaArg3: fields[6] as String?,
      mdaSeqnum: fields[7] as int,
      mdaReturn: fields[8] as String?,
      mdaCrtDate: fields[9] as DateTime?,
      mdaCrtUserid: fields[10] as String?,
      mdaUpdDate: fields[11] as DateTime?,
      mdaUpdUserid: fields[12] as String?,
      mdaRowVersion: fields[13] as int?,
      mdaTrue: fields[14] as int?,
      mdaFalse: fields[15] as int?,
      mdaArg4: fields[16] as String?,
      mdaArg5: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MetadataActionResponse obj) {
    writer
      ..writeByte(17)
      ..writeByte(1)
      ..write(obj.mdaSysId)
      ..writeByte(2)
      ..write(obj.mdaMdcdSysId)
      ..writeByte(3)
      ..write(obj.mdaAction)
      ..writeByte(4)
      ..write(obj.mdaArg1)
      ..writeByte(5)
      ..write(obj.mdaArg2)
      ..writeByte(6)
      ..write(obj.mdaArg3)
      ..writeByte(7)
      ..write(obj.mdaSeqnum)
      ..writeByte(8)
      ..write(obj.mdaReturn)
      ..writeByte(9)
      ..write(obj.mdaCrtDate)
      ..writeByte(10)
      ..write(obj.mdaCrtUserid)
      ..writeByte(11)
      ..write(obj.mdaUpdDate)
      ..writeByte(12)
      ..write(obj.mdaUpdUserid)
      ..writeByte(13)
      ..write(obj.mdaRowVersion)
      ..writeByte(14)
      ..write(obj.mdaTrue)
      ..writeByte(15)
      ..write(obj.mdaFalse)
      ..writeByte(16)
      ..write(obj.mdaArg4)
      ..writeByte(17)
      ..write(obj.mdaArg5);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetadataActionResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
