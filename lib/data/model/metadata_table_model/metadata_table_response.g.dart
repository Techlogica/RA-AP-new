// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_table_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MetadataTableResponseAdapter extends TypeAdapter<MetadataTableResponse> {
  @override
  final int typeId = 0;

  @override
  MetadataTableResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MetadataTableResponse(
      mdtSysId: fields[1] as int,
      mdtMdpSysId: fields[2] as int?,
      mdtTblName: fields[3] as String?,
      mdtTblTitle: fields[4] as String?,
      mdtTblIschild: fields[5] as String?,
      mdtTblChild: fields[6] as String?,
      mdtChildwhere: fields[7] as String?,
      mdtDefaultwhere: fields[8] as String?,
      mdtCrtDate: fields[9] as DateTime?,
      mdtCrtUserid: fields[10] as String?,
      mdtUpdDate: fields[11] as DateTime?,
      mdtUpdUserid: fields[12] as String?,
      mdtRowVersion: fields[13] as int?,
      mdtCache: fields[14] as String?,
      mdtChildviewtype: fields[15] as String?,
      mdtSeqno: fields[16] == null ? 0 : fields[16] as int,
      mdtTblChildid: fields[17] as int?,
      mdtType: fields[18] as String?,
      mdtIcon: fields[19] as String?,
      mdtMenuPrntid: fields[20] as int?,
      mdtChildIsbtn: fields[21] as String?,
      mdtApprvlReqd: fields[22] as String?,
      mdtIsmenuchld: fields[23] as String?,
      mdtMenuTitle: fields[24] as String?,
      userId: fields[25] as int,
      mdtInsert: fields[26] as String?,
      mdtUpdate: fields[27] as String?,
      mdtDelete: fields[28] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MetadataTableResponse obj) {
    writer
      ..writeByte(28)
      ..writeByte(1)
      ..write(obj.mdtSysId)
      ..writeByte(2)
      ..write(obj.mdtMdpSysId)
      ..writeByte(3)
      ..write(obj.mdtTblName)
      ..writeByte(4)
      ..write(obj.mdtTblTitle)
      ..writeByte(5)
      ..write(obj.mdtTblIschild)
      ..writeByte(6)
      ..write(obj.mdtTblChild)
      ..writeByte(7)
      ..write(obj.mdtChildwhere)
      ..writeByte(8)
      ..write(obj.mdtDefaultwhere)
      ..writeByte(9)
      ..write(obj.mdtCrtDate)
      ..writeByte(10)
      ..write(obj.mdtCrtUserid)
      ..writeByte(11)
      ..write(obj.mdtUpdDate)
      ..writeByte(12)
      ..write(obj.mdtUpdUserid)
      ..writeByte(13)
      ..write(obj.mdtRowVersion)
      ..writeByte(14)
      ..write(obj.mdtCache)
      ..writeByte(15)
      ..write(obj.mdtChildviewtype)
      ..writeByte(16)
      ..write(obj.mdtSeqno)
      ..writeByte(17)
      ..write(obj.mdtTblChildid)
      ..writeByte(18)
      ..write(obj.mdtType)
      ..writeByte(19)
      ..write(obj.mdtIcon)
      ..writeByte(20)
      ..write(obj.mdtMenuPrntid)
      ..writeByte(21)
      ..write(obj.mdtChildIsbtn)
      ..writeByte(22)
      ..write(obj.mdtApprvlReqd)
      ..writeByte(23)
      ..write(obj.mdtIsmenuchld)
      ..writeByte(24)
      ..write(obj.mdtMenuTitle)
      ..writeByte(25)
      ..write(obj.userId)
      ..writeByte(26)
      ..write(obj.mdtInsert)
      ..writeByte(27)
      ..write(obj.mdtUpdate)
      ..writeByte(28)
      ..write(obj.mdtDelete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetadataTableResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
