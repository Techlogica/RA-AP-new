import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';

class ChangeThemeController extends GetxController {
  Color currentColor = Colors.amber;
  List<Color> colorHistory = [];
  RxBool isLightMode = true.obs;
  Color? appTheme = RapidPref().getAppTheme();

  get changedAppTheme => appTheme;
  late RxInt colorValue = currentColor.value.obs;
  RxBool isEnabled = false.obs;
  RxDouble cardElevation = 5.0.obs;

  ThemeMode get theme => loadTheme() ? ThemeMode.light : ThemeMode.dark;

  bool loadTheme() => RapidPref().getIsLightTheme() ?? true;

  void changeTheme(ThemeData theme) => Get.changeTheme(theme);

  void changeThemeMode(ThemeMode themeMode) => Get.changeThemeMode(themeMode);

  @override
  void onInit() {
    isLightMode.value = RapidPref().getIsLightTheme() ?? true;
    super.onInit();
  }

  void changeColor(Color color) {
    appTheme = color;
    RapidPref().setAppTheme(appTheme);
    currentColor = appTheme!;
    cardElevation.value = 5.0;
    colorValue.value = appTheme!.value;
  }

  void changeMode() {
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
      RapidPref().setIsLightTheme(true);
      isLightMode.value = true;
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      RapidPref().setIsLightTheme(false);
      isLightMode.value = false;
    }
  }

  void back() => Get.back();

  ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
        backgroundColor: Color(colorValue.value),
        primaryColor: const Color(0XFF282828),
        hintColor: Colors.white,
        textTheme: const TextTheme(
          headline1: TextStyle(color: Colors.white),
          headline2: TextStyle(color: Colors.black),
          caption: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Color(colorValue.value),
          )),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Color(colorValue.value),
          )),
          focusColor: Color(colorValue.value),
        ));
  }

  ThemeData lightTheme() {
    return ThemeData.light().copyWith(
        backgroundColor: Color(colorValue.value),
        primaryColor: Colors.white,
        hintColor: Colors.black,
        textTheme: const TextTheme(
          headline1: TextStyle(color: Colors.black),
          headline2: TextStyle(color: Colors.white),
          caption: TextStyle(color: Colors.black),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Color(colorValue.value),
          )),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Color(colorValue.value),
          )),
          focusColor: Color(colorValue.value),
        ));
  }
}
