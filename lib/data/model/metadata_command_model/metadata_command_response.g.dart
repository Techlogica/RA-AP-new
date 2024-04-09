// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_command_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MetadataCommandResponseAdapter
    extends TypeAdapter<MetadataCommandResponse> {
  @override
  final int typeId = 6;

  @override
  MetadataCommandResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MetadataCommandResponse(
      mdcdSysId: fields[1] as int,
      mdcdMdtSysId: fields[2] as int,
      mdcdText: fields[3] as String,
      mdcdRenderstyle: fields[4] as String?,
      mdcdSeqnum: fields[5] as int,
      mdcdType: fields[6] as String?,
      mdcdAlt: fields[7] as String?,
      mdcdShift: fields[8] as String?,
      mdcdCtrl: fields[9] as String?,
      mdcdCode: fields[10] as String?,
      mdcdCrtDate: fields[11] as DateTime?,
      mdcdCrtUserid: fields[12] as String?,
      mdcdUpdDate: fields[13] as DateTime?,
      mdcdUpdUserid: fields[14] as String?,
      mdcdRowVersion: fields[15] as int?,
      mdcdTitle: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MetadataCommandResponse obj) {
    writer
      ..writeByte(16)
      ..writeByte(1)
      ..write(obj.mdcdSysId)
      ..writeByte(2)
      ..write(obj.mdcdMdtSysId)
      ..writeByte(3)
      ..write(obj.mdcdText)
      ..writeByte(4)
      ..write(obj.mdcdRenderstyle)
      ..writeByte(5)
      ..write(obj.mdcdSeqnum)
      ..writeByte(6)
      ..write(obj.mdcdType)
      ..writeByte(7)
      ..write(obj.mdcdAlt)
      ..writeByte(8)
      ..write(obj.mdcdShift)
      ..writeByte(9)
      ..write(obj.mdcdCtrl)
      ..writeByte(10)
      ..write(obj.mdcdCode)
      ..writeByte(11)
      ..write(obj.mdcdCrtDate)
      ..writeByte(12)
      ..write(obj.mdcdCrtUserid)
      ..writeByte(13)
      ..write(obj.mdcdUpdDate)
      ..writeByte(14)
      ..write(obj.mdcdUpdUserid)
      ..writeByte(15)
      ..write(obj.mdcdRowVersion)
      ..writeByte(16)
      ..write(obj.mdcdTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetadataCommandResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
