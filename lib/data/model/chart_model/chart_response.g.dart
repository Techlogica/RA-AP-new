// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharResponseAdapter extends TypeAdapter<ChartResponse> {
  @override
  final int typeId = 5;

  @override
  ChartResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartResponse(
      cSysId: fields[1] as int,
      cChartName: fields[2] as String?,
      cCgGroupId: fields[3] as int?,
      cColspanmd: fields[4] as int?,
      cLegendPosition: fields[5] as String?,
      cQueryString: fields[6] as String,
      cShowDetails: fields[7] as String?,
      cGridString: fields[8] as String?,
      cHtml: fields[9] as String?,
      cSeqNo: fields[10] as int?,
      cuSysId: fields[11] as int?,
      cuMtlUsrid: fields[12] as int?,
      cuCChartId: fields[13] as int?,
      caSysId: fields[14] as int?,
      caTitleText: fields[15] as String?,
      caChartType: fields[16] as String?,
      caCChartId: fields[17] as int?,
      caName: fields[18] as String?,
      caArgumentField: fields[19] as String?,
      caValueField: fields[20] as String?,
      caAgrtnMthd: fields[21] as String?,
      caDynamicKey: fields[22] as String?,
      caMAxes: fields[23] as String?,
      caLabelFormat: fields[24] as int?,
      caIsArgument: fields[25] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChartResponse obj) {
    writer
      ..writeByte(25)
      ..writeByte(1)
      ..write(obj.cSysId)
      ..writeByte(2)
      ..write(obj.cChartName)
      ..writeByte(3)
      ..write(obj.cCgGroupId)
      ..writeByte(4)
      ..write(obj.cColspanmd)
      ..writeByte(5)
      ..write(obj.cLegendPosition)
      ..writeByte(6)
      ..write(obj.cQueryString)
      ..writeByte(7)
      ..write(obj.cShowDetails)
      ..writeByte(8)
      ..write(obj.cGridString)
      ..writeByte(9)
      ..write(obj.cHtml)
      ..writeByte(10)
      ..write(obj.cSeqNo)
      ..writeByte(11)
      ..write(obj.cuSysId)
      ..writeByte(12)
      ..write(obj.cuMtlUsrid)
      ..writeByte(13)
      ..write(obj.cuCChartId)
      ..writeByte(14)
      ..write(obj.caSysId)
      ..writeByte(15)
      ..write(obj.caTitleText)
      ..writeByte(16)
      ..write(obj.caChartType)
      ..writeByte(17)
      ..write(obj.caCChartId)
      ..writeByte(18)
      ..write(obj.caName)
      ..writeByte(19)
      ..write(obj.caArgumentField)
      ..writeByte(20)
      ..write(obj.caValueField)
      ..writeByte(21)
      ..write(obj.caAgrtnMthd)
      ..writeByte(22)
      ..write(obj.caDynamicKey)
      ..writeByte(23)
      ..write(obj.caMAxes)
      ..writeByte(24)
      ..write(obj.caLabelFormat)
      ..writeByte(25)
      ..write(obj.caIsArgument);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
