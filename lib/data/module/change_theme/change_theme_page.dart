import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/change_theme/change_theme_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ChangeThemePage extends GetView<ChangeThemeController> {
  const ChangeThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final foregroundColor = useWhiteForeground(controller.currentColor)
        ? Colors.white
        : Colors.black;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: Obx(
        () => FloatingActionButton.extended(
          onPressed: controller.changeMode,
          icon: Icon(
            controller.isLightMode.value
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
          ),
          label: Text(controller.isLightMode.value ? 'Day' : '  Night '),
          backgroundColor: Color(controller.colorValue.value),
          foregroundColor: foregroundColor,
          elevation: 15,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: Obx(
              () => Container(
                color: Color(controller.colorValue.value),
                padding: const EdgeInsets.only(top: 20),
                height: 100,
                width: Get.width,
                child: Row(
                  children: [
                    Expanded(
                      flex: 0,
                      child: IconButton(
                          onPressed: controller.back,
                          icon: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).primaryColor,
                            size: 25,
                          )),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'Change Theme',
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline2!.color!,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'Roboto'),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 0,
                        child: IconButton(
                            onPressed: controller.back,
                            icon: Icon(
                              Icons.check,
                              color: Theme.of(context).primaryColor,
                              size: 25,
                            ))),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: HueRingPicker(
                pickerColor: controller.appTheme ?? Colors.amber,
                onColorChanged: controller.changeColor,
                enableAlpha: true,
                displayThumbColor: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
