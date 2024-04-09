// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_list_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectListResponseAdapter extends TypeAdapter<ProjectListResponse> {
  @override
  final int typeId = 2;

  @override
  ProjectListResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectListResponse(
      projectName: fields[1] as String,
      projectKey: fields[2] as String,
      projectUrl: fields[3] as String,
      userName: fields[4] as String,
      password: fields[5] as String,
      projectId: fields[6] as String,
      projectTitle: fields[7] as String,
      projectLogo: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectListResponse obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.projectName)
      ..writeByte(2)
      ..write(obj.projectKey)
      ..writeByte(3)
      ..write(obj.projectUrl)
      ..writeByte(4)
      ..write(obj.userName)
      ..writeByte(5)
      ..write(obj.password)
      ..writeByte(6)
      ..write(obj.projectId)
      ..writeByte(7)
      ..write(obj.projectTitle)
      ..writeByte(8)
      ..write(obj.projectLogo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectListResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
