import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rapid_app/data/model/projects_list_model/project_list_response.dart';
import 'package:rapid_app/data/module/auth/login/login_controller.dart';
import 'package:rapid_app/data/widgets/text/text_widget.dart';
import 'package:rapid_app/data/widgets/text_field/login_text_field_widget.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/colours.dart';
import 'package:rapid_app/res/values/drawables.dart' as drawables;
import 'package:rapid_app/res/values/strings.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // resizeToAvoidBottomInset: false,
      body: _BodyWidget(),
    );
  }
}

class _BodyWidget extends GetView<LoginController> {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            width: Get.width,
            child: SizedBox(
              height: 200,
              width: Get.width,
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: 200,
                    width: Get.width,
                    child: SvgPicture.asset(
                      drawables.Drawable.kFilePath +
                          drawables.Drawable.kLoginTopShape,
                      fit: BoxFit.fill,
                      color: Theme.of(context).backgroundColor,
                    ),
                  ),
                  Center(
                    child: TextWidget(
                      alignment: TextAlign.center,
                      text: controller.argumentData['title'].toString(),
                      textSize: 24,
                      textColor: Theme.of(context).textTheme.headline2!.color!,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 45.0, right: 45.0),
              child: ListView(
                children: [
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          controller.argumentData['logo'].toString(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TextWidget(
                        alignment: TextAlign.left,
                        text: 'Login',
                        textSize: 35,
                        textColor:
                            Theme.of(context).textTheme.headline1!.color!),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 15,
                    ),
                    child: LoginTextFieldWidget(
                      hint: Strings.kUserName,
                      controller: controller.usernameController,
                      prefixIcon: Icons.person,
                      keyboardType: TextInputType.name,
                      obscureText: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Obx(
                      () => LoginTextFieldWidget(
                        hint: Strings.kPassword,
                        controller: controller.passwordController,
                        prefixIcon: Icons.lock,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: controller.isObscure.value,
                        obscureClick: () => controller.obscureToggle(),
                        shouldDisplayEyeIcon: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Obx(
                          () => controller.isLoginButtonVisibility.value
                              ? ElevatedButton(
                                  onPressed: _onTapButton,
                                  child: const Icon(Icons.arrow_forward,
                                      color: Colors.white),
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(15),
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                  ),
                                )
                              : CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                    Theme.of(context).backgroundColor,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: SvgPicture.asset(
              drawables.Drawable.kFilePath +
                  drawables.Drawable.kLoginBottomShape,
              height: Get.height / 13,
              width: Get.width,
              fit: BoxFit.cover,
              color: Theme.of(context).backgroundColor,
            ),
          ),
          Expanded(
            flex: 0,
            child: Container(
              // height: 100,
              decoration: const BoxDecoration(color: colours.card_background),
            ),
          )
        ],
      ),
    );
  }

  void _onTapButton() async {
    FocusScope.of(Get.context!).unfocus();
    if (controller.isLoginCredentialsValid()) {
      controller.loginButtonVisibility();

      /// to get token & project_id
      final result = await controller.logIn();

      /// check login API status
      if (result.statusCode == 500) {
        Get.snackbar(Strings.kMessage, Strings.k500Error.tr);
        controller.loginButtonVisibility();
      } else if (result.statusCode == 503) {
        Get.snackbar(Strings.kMessage, Strings.k503Error.tr);
        controller.loginButtonVisibility();
      } else if (result.statusCode == 400) {
        Get.snackbar(Strings.kMessage, Strings.k400Error.tr);
        controller.loginButtonVisibility();
      } else if (result.statusCode == 404) {
        Get.snackbar(Strings.kMessage, Strings.k404Error.tr);
        controller.loginButtonVisibility();
      } else if (result.statusCode == 200) {
        if (result.status) {
          RapidPref().setToken(result.data['token']);
          RapidPref().setProjectId(result.data['Project_id'].toString());
          RapidPref().setUserName(controller.usernameController.text);
          RapidPref().setUserPassword(controller.passwordController.text);

          final res = await controller.getMtlSysId(
              projectId: result.data['Project_id'].toString());
          if (res) {
            ProjectListResponse response = ProjectListResponse(
                projectName: controller.argumentData['projectName'],
                projectKey: controller.argumentData['projectKey'],
                projectUrl: controller.argumentData['url'],
                userName: controller.usernameController.text,
                password: controller.passwordController.text,
                projectId: result.data['Project_id'].toString(),
                projectTitle: RapidPref().getAppTitle().toString(),
                projectLogo: RapidPref().getAppLogo().toString());
            final userBox = await Hive.openBox<ProjectListResponse>(
                Strings.kRapidMainDatabase);
            userBox.putAt(controller.argumentData['index'], response);

            if (RapidPref().getGlobalSettingsShow() == 'Y') {
              Get.offAllNamed(
                Strings.kGlobalSettingsPage,
              );
            } else {
              Get.offAllNamed(
                Strings.kHomePage,
              );
            }
          } else {
            Get.snackbar(
                Strings.kConnectionError.tr, Strings.kSomethingWentWrong.tr);
          }
        } else {
          controller.loginButtonVisibility();
          Get.snackbar(Strings.kMessage, Strings.kFailedError);
        }
      }
    }
  }
}
