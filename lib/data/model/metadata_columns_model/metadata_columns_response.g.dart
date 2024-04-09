// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_columns_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MetadataColumnsResponseAdapter
    extends TypeAdapter<MetadataColumnsResponse> {
  @override
  final int typeId = 1;

  @override
  MetadataColumnsResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MetadataColumnsResponse(
      mdcSysId: fields[1] as int?,
      mdcMdtSysId: fields[2] as int?,
      mdcColName: fields[3] as String,
      mdcDatatype: fields[4] as String?,
      mdcKeyinfo: fields[5] as String?,
      mdcMetatitle: fields[6] as String,
      mdcSeqnum: fields[7] == null ? 0 : fields[7] as int,
      mdcComboqry: fields[8] as String?,
      mdcCombowhere: fields[9] as String?,
      mdcValuefieldname: fields[10] as String?,
      mdcTextfieldname: fields[11] as String?,
      mdcColSpanmd: fields[12] as num?,
      mdcColSpanlg: fields[13] as num?,
      mdcDefaultvalue: fields[14] as String?,
      mdcColLength: fields[15] as int?,
      mdcMtgGrpname: fields[16] as String,
      mdcUnbound: fields[17] as String?,
      mdcVisible: fields[18] as String?,
      mdcCrtDate: fields[19] as DateTime?,
      mdcCrtUserid: fields[20] as String?,
      mdcUpdDate: fields[21] as DateTime?,
      mdcUpdUserid: fields[22] as String?,
      mdcRowVersion: fields[23] as int?,
      mdcReadonly: fields[24] as String?,
      mdcGridVisible: fields[25] as String?,
      mdcSort: fields[26] as String?,
      mdcDispFormat: fields[27] as String?,
      mdcShowincoloumn: fields[28] as String?,
      mdcSummaryType: fields[29] as int?,
      mdcSummaryFormat: fields[30] as String?,
      mdcEncrypt: fields[31] as String?,
      mdcGrpPosition: fields[32] as int?,
      mdcHint: fields[33] as String?,
      mdcReportparam: fields[34] as String?,
      mdcHtml: fields[35] as String?,
      mdcHtmlCond: fields[36] as String?,
      mdcIssearchDeflt: fields[37] as String?,
      mdcShwinColchosr: fields[38] as String?,
      mdcPkAutoinc: fields[39] as String?,
      mdcPlaceholdr: fields[40] as String?,
      mdcPrwTempVisble: fields[41] as String?,
      mdcEncbtnVisble: fields[42] as String?,
      mdcReturn: fields[43] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MetadataColumnsResponse obj) {
    writer
      ..writeByte(43)
      ..writeByte(1)
      ..write(obj.mdcSysId)
      ..writeByte(2)
      ..write(obj.mdcMdtSysId)
      ..writeByte(3)
      ..write(obj.mdcColName)
      ..writeByte(4)
      ..write(obj.mdcDatatype)
      ..writeByte(5)
      ..write(obj.mdcKeyinfo)
      ..writeByte(6)
      ..write(obj.mdcMetatitle)
      ..writeByte(7)
      ..write(obj.mdcSeqnum)
      ..writeByte(8)
      ..write(obj.mdcComboqry)
      ..writeByte(9)
      ..write(obj.mdcCombowhere)
      ..writeByte(10)
      ..write(obj.mdcValuefieldname)
      ..writeByte(11)
      ..write(obj.mdcTextfieldname)
      ..writeByte(12)
      ..write(obj.mdcColSpanmd)
      ..writeByte(13)
      ..write(obj.mdcColSpanlg)
      ..writeByte(14)
      ..write(obj.mdcDefaultvalue)
      ..writeByte(15)
      ..write(obj.mdcColLength)
      ..writeByte(16)
      ..write(obj.mdcMtgGrpname)
      ..writeByte(17)
      ..write(obj.mdcUnbound)
      ..writeByte(18)
      ..write(obj.mdcVisible)
      ..writeByte(19)
      ..write(obj.mdcCrtDate)
      ..writeByte(20)
      ..write(obj.mdcCrtUserid)
      ..writeByte(21)
      ..write(obj.mdcUpdDate)
      ..writeByte(22)
      ..write(obj.mdcUpdUserid)
      ..writeByte(23)
      ..write(obj.mdcRowVersion)
      ..writeByte(24)
      ..write(obj.mdcReadonly)
      ..writeByte(25)
      ..write(obj.mdcGridVisible)
      ..writeByte(26)
      ..write(obj.mdcSort)
      ..writeByte(27)
      ..write(obj.mdcDispFormat)
      ..writeByte(28)
      ..write(obj.mdcShowincoloumn)
      ..writeByte(29)
      ..write(obj.mdcSummaryType)
      ..writeByte(30)
      ..write(obj.mdcSummaryFormat)
      ..writeByte(31)
      ..write(obj.mdcEncrypt)
      ..writeByte(32)
      ..write(obj.mdcGrpPosition)
      ..writeByte(33)
      ..write(obj.mdcHint)
      ..writeByte(34)
      ..write(obj.mdcReportparam)
      ..writeByte(35)
      ..write(obj.mdcHtml)
      ..writeByte(36)
      ..write(obj.mdcHtmlCond)
      ..writeByte(37)
      ..write(obj.mdcIssearchDeflt)
      ..writeByte(38)
      ..write(obj.mdcShwinColchosr)
      ..writeByte(39)
      ..write(obj.mdcPkAutoinc)
      ..writeByte(40)
      ..write(obj.mdcPlaceholdr)
      ..writeByte(41)
      ..write(obj.mdcPrwTempVisble)
      ..writeByte(42)
      ..write(obj.mdcEncbtnVisble)
      ..writeByte(43)
      ..write(obj.mdcReturn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetadataColumnsResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
