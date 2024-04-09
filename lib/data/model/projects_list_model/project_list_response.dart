import 'package:hive/hive.dart';

part 'project_list_response.g.dart';

@HiveType(typeId: 2, adapterName: "ProjectListResponseAdapter")
class ProjectListResponse extends HiveObject {
  @HiveField(1)
  String projectName;
  @HiveField(2)
  String projectKey;
  @HiveField(3)
  String projectUrl;
  @HiveField(4)
  String userName;
  @HiveField(5)
  String password;
  @HiveField(6)
  String projectId;
  @HiveField(7)
  String projectTitle;
  @HiveField(8)
  String projectLogo;

  ProjectListResponse({
    required this.projectName,
    required this.projectKey,
    required this.projectUrl,
    required this.userName,
    required this.password,
    required this.projectId,
    required this.projectTitle,
    required this.projectLogo,
  });
}
