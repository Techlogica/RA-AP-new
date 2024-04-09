import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/utils/rapid_pref.dart';
import '../../../res/values/drawables.dart';
import '../../../res/values/strings.dart';
import '../../service/auth_service/local_auth_service.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  String? projectName = RapidPref().getLoggedInProjectName();
  String? projectIcon = RapidPref().getProjectIcon();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: projectIcon != null
                ? Image.network(
                    projectIcon!,
                    height: 80,
                    width: 100,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    Drawable.kIconFilePath + Drawable.kAppIcon,
                    fit: BoxFit.contain,
                  ),
          ),
          Center(
            child: SizedBox(
              // width: 250.0,
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 30.0,
                  color: Theme.of(context).backgroundColor,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w900,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                        projectName != null ? projectName.toString() : 'RA-AP'),
                  ],
                  onTap: () {},
                ),
              ),
            ),
            // child: TextWidget(
            //     text: Strings.kAppName,
            //     textSize: 20,
            //     textColor: Theme.of(context).backgroundColor),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _authenticate();
    super.initState();
  }

  void _authenticate() async {
    bool canAuthenticate = await LocalAuth.canAuthenticate();
    if (canAuthenticate) {
      print('cannnnnnnnnnnnnnnnnnnn');
      bool isAuthenticated = await LocalAuth.authenticate();
      if (isAuthenticated) {
        var isToken = RapidPref().getToken() ?? '';
        Get.offNamed(
            (isToken == '') ? Strings.kUrlConnectionPage : Strings.kHomePage);
      } else {
        _authenticate();
      }
    } else {
      print('canttttttttttt');
      var isToken = RapidPref().getToken() ?? '';
      Get.offNamed(
          (isToken == '') ? Strings.kUrlConnectionPage : Strings.kHomePage);
    }
  }
}
