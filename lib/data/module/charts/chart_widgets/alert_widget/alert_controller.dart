
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RadioButtonController extends GetxController  {


  var selectedOption =  1.obs;

  void setSelectedOption(int value) {
    selectedOption.value = value;
  }
}