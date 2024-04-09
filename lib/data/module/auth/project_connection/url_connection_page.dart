import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rapid_app/data/api/api_client.dart';
import 'package:rapid_app/data/model/projects_list_model/project_list_response.dart';
import 'package:rapid_app/data/module/auth/project_connection/connection_controller.dart';
import 'package:rapid_app/data/widgets/button/login_button_widget.dart';
import 'package:rapid_app/data/widgets/text_field/text_field_widget.dart';
import 'package:rapid_app/data/widgets/tile/listview_tile_widget.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/strings.dart';

class UrlConnectionPage extends GetView<ConnectionController> {
  const UrlConnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Theme.of(context).backgroundColor,
          // decoration: const BoxDecoration(
          //     gradient: LinearGradient(colors: [
          //       Color.fromRGBO(0, 218, 179, 100),
          //       Color.fromRGBO(5, 0, 255, 100),
          //     ], begin: Alignment.topLeft, end: Alignment.centerRight)),
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  FirebaseCrashlytics.instance.crash();
                },
                child: const Text("Throw Test Exception"),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'PROJECTS',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                        color: controller.isLightMode
                            ? Colors.white30
                            : Colors.black38,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0))),
                    child: Container(
                      margin: const EdgeInsets.only(top: 25.0),
                      decoration: BoxDecoration(
                          color: controller.isLightMode
                              ? Colors.white54
                              : Colors.black54,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0))),
                      child: Container(
                        margin: const EdgeInsets.only(top: 25.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 12.0),
                        decoration: BoxDecoration(
                            color: controller.isLightMode
                                ? Colors.white
                                : Colors.black,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0))),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Obx(
                            () => ListView.builder(
                              itemCount: controller.savedProjects.length,
                              itemBuilder: (context, index) {
                                return Slidable(
                                  key: const ValueKey(0),
                                  enabled: true,
                                  startActionPane: ActionPane(
                                    extentRatio: 0.20,
                                    dragDismissible: false,
                                    motion: const DrawerMotion(),
                                    dismissible:
                                        DismissiblePane(onDismissed: () {}),
                                    children: [
                                      SlidableAction(
                                        onPressed: (BuildContext context) =>
                                            _onTapListView(
                                                controller.savedProjects[index],
                                                'delete',
                                                index),
                                        backgroundColor: Colors.transparent,
                                        foregroundColor:
                                            Theme.of(context).backgroundColor,
                                        icon: Icons.delete,
                                      )
                                    ],
                                  ),
                                  endActionPane: ActionPane(
                                    extentRatio: 0.20,
                                    dragDismissible: false,
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (BuildContext context) =>
                                            _onTapListView(
                                                controller.savedProjects[index],
                                                'add',
                                                index),
                                        backgroundColor: Colors.transparent,
                                        foregroundColor:
                                            Theme.of(context).backgroundColor,
                                        icon: Icons.arrow_forward,
                                      ),
                                    ],
                                  ),
                                  child: ListTileWidget(
                                    response: controller.savedProjects[index],
                                    onTap: () {
                                      _openProjectAlertBox(
                                        projectName: controller
                                            .savedProjects[index].projectName,
                                        projectUrl: controller
                                            .savedProjects[index].projectUrl,
                                        index: index,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).backgroundColor,
            child: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            onPressed: () => _onPressedFloatingButton()),
      ),
    );
  }

  _onPressedFloatingButton() {
    _openProjectAlertBox();
  }

  _openProjectAlertBox({String? projectName, String? projectUrl, int? index}) {
    bool projectNameReadOnly = false;
    String title = Strings.kAddProject.tr;
    if (index != null) {
      controller.projectNameController.text = projectName!;
      controller.baseUrlController.text = projectUrl!;
      projectNameReadOnly = true;
      title = Strings.kEditProject.tr;
    }
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(
        top: 20,
        bottom: 10,
      ),
      contentPadding: const EdgeInsets.all(20.0),
      radius: 15.0,
      title: title,
      titleStyle: Theme.of(Get.context!)
          .textTheme
          .headline1!
          .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
      backgroundColor: Theme.of(Get.context!).primaryColor,
      barrierDismissible: false,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => TextFieldWidget(
              hint: Strings.kProjectName.tr,
              controller: controller.projectNameController,
              validate: controller.validationProjectName.value,
              errorMessage: controller.errorMsgProjectName,
              readOnlyVal: projectNameReadOnly,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(
            () => TextFieldWidget(
              hint: Strings.kUrl.tr,
              controller: controller.baseUrlController,
              validate: controller.validationUrl.value,
              errorMessage: controller.errorMsgUrl,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: LoginButtonWidget(
                  label: Strings.kCancel.tr,
                  onTap: _onTapAlertButtonCancel,
                ),
              ),
              const SizedBox(
                height: 25,
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: LoginButtonWidget(
                  label: Strings.kSave.tr,
                  onTap: () => _onTapAlertButtonAdd(index: index),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _onTapAlertButtonCancel() {
    // clear validation
    controller.validationProjectName.value = false;
    controller.validationUrl.value = false;
    controller.errorMsgProjectName = '';
    controller.errorMsgUrl = '';
    // clear controller values
    controller.projectNameController.clear();
    controller.baseUrlController.clear();
    // close alert box
    Get.back();
  }

  _onTapAlertButtonAdd({int? index}) {
    if (controller.isProjectNameCredentialValid() &&
        controller.isBaseUrlCredentialValid()) {
      if (index == null) {
        // fetch controller values
        String projectName =
            controller.projectNameController.text.toString().trim();
        String projectKey = projectName.replaceAll(' ', '');
        String url = controller.baseUrlController.text.toString().trim();

        ProjectListResponse response = ProjectListResponse(
            projectName: projectName,
            projectKey: projectKey,
            projectUrl: url,
            userName: '',
            password: '',
            projectId: '',
            projectTitle: projectName,
            projectLogo: '');
        // add to db
        controller.getUsers().add(response);
      } else {
        ProjectListResponse response = ProjectListResponse(
            projectName: controller.savedProjects[index].projectName,
            projectKey: controller.savedProjects[index].projectKey,
            projectUrl: controller.baseUrlController.text.toString().trim(),
            userName: controller.savedProjects[index].userName,
            password: controller.savedProjects[index].password,
            projectId: controller.savedProjects[index].projectId,
            projectTitle: controller.savedProjects[index].projectTitle,
            projectLogo: controller.savedProjects[index].projectLogo);
        controller.getUsers().putAt(index, response);
      }
      controller.fetchProjectsFromDb();
      // clear validation
      _onTapAlertButtonCancel();
    }
  }

  _onTapListView(
      ProjectListResponse savedProject, String type, int index) async {
    if (type == 'add') {
      // store project url, project localdbName, projectName
      RapidPref().setBaseUrl(savedProject.projectUrl);
      RapidPref().setProjectName(savedProject.projectName);
      RapidPref().setProjectKey(savedProject.projectKey);
      // update project url
      Get.find<ApiClient>().updateBaseUrl(savedProject.projectUrl);

      Get.toNamed(
        Strings.kLoginPage,
        arguments: {
          'index': index,
          'url': savedProject.projectUrl,
          'projectName': savedProject.projectName,
          'projectKey': savedProject.projectKey,
          'userName': savedProject.userName,
          'password': savedProject.password,
          'title': savedProject.projectTitle,
          'logo': savedProject.projectLogo,
        },
      );
    } else if (type == 'delete') {
      var userBox =
          await Hive.openBox<ProjectListResponse>(Strings.kRapidMainDatabase);
      userBox.deleteAt(index);
      controller.fetchProjectsFromDb();
    }
  }

  void doNothing(BuildContext context) {}
}
