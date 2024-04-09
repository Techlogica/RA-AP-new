import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetTraceId {
  String generateRandomString() {
    const _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
    Random _rnd = Random();
    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    String genKey = getRandomString(6);
    return genKey.toUpperCase();
  }

  Color generateRandomColor(int index) {
    if (index == 0) {
      return Theme.of(Get.context!).iconTheme.color!;
    } else {
      int balance = index % 2;
      if (balance == 0) {
        return Theme.of(Get.context!).iconTheme.color!;
      } else {
        return Theme.of(Get.context!).backgroundColor;
      }
    }
  }

  String generateRandomHexaString() {
    const hex = '0123456789abcdef';
    Random _rnd = Random();

    String getRandomHexaString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => hex.codeUnitAt(_rnd.nextInt(hex.length))));
    String key1 = getRandomHexaString(8);
    String key2 = getRandomHexaString(4);
    String key3 = getRandomHexaString(4);
    String key4 = getRandomHexaString(4);
    String key5 = getRandomHexaString(12);
    String genKey = key1 + '-' + key2 + '-' + key3 + '-' + key4 + '-' + key5;
    return genKey;
  }
}
