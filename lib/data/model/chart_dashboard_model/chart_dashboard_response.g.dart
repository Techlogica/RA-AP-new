// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_dashboard_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChartDashboardResponseAdapter
    extends TypeAdapter<ChartDashboardResponse> {
  @override
  final int typeId = 4;

  @override
  ChartDashboardResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartDashboardResponse(
      mtdSysId: fields[1] as int,
      mtdText: fields[2] as String?,
      mtdImage: fields[3] as String?,
      mtdQuery: fields[4] as String?,
      mtdBgColor: fields[5] as String?,
      mtdDisplayFormat: fields[6] as String?,
      mtdSeqNo: fields[7] as int,
      mtdSubtext: fields[8] as String?,
      mtdType: fields[9] as String?,
      mtdFreeze: fields[10] as String?,
      mtdWidth: fields[11] as String?,
      mtdHeight: fields[12] as String?,
      mtdColspammd: fields[13] as String?,
      mtdMdpSysId: fields[14] as int?,
      mtduSysId: fields[15] as int?,
      mtduMtdDashId: fields[16] as int?,
      mtduMtlUserId: fields[17] as int?,
      mtduCgSysId: fields[18] as int?,
      mtdLink: fields[19] as String?,
      mtdQueryValue: fields[20] as String?,
      mtdMdtSysId: fields[21] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ChartDashboardResponse obj) {
    writer
      ..writeByte(21)
      ..writeByte(1)
      ..write(obj.mtdSysId)
      ..writeByte(2)
      ..write(obj.mtdText)
      ..writeByte(3)
      ..write(obj.mtdImage)
      ..writeByte(4)
      ..write(obj.mtdQuery)
      ..writeByte(5)
      ..write(obj.mtdBgColor)
      ..writeByte(6)
      ..write(obj.mtdDisplayFormat)
      ..writeByte(7)
      ..write(obj.mtdSeqNo)
      ..writeByte(8)
      ..write(obj.mtdSubtext)
      ..writeByte(9)
      ..write(obj.mtdType)
      ..writeByte(10)
      ..write(obj.mtdFreeze)
      ..writeByte(11)
      ..write(obj.mtdWidth)
      ..writeByte(12)
      ..write(obj.mtdHeight)
      ..writeByte(13)
      ..write(obj.mtdColspammd)
      ..writeByte(14)
      ..write(obj.mtdMdpSysId)
      ..writeByte(15)
      ..write(obj.mtduSysId)
      ..writeByte(16)
      ..write(obj.mtduMtdDashId)
      ..writeByte(17)
      ..write(obj.mtduMtlUserId)
      ..writeByte(18)
      ..write(obj.mtduCgSysId)
      ..writeByte(19)
      ..write(obj.mtdLink)
      ..writeByte(20)
      ..write(obj.mtdQueryValue)
      ..writeByte(21)
      ..write(obj.mtdMdtSysId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartDashboardResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
