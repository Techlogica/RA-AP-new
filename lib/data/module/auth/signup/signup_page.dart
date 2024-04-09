import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/auth/signup/signup_controller.dart';

class SignupPage extends GetView<SignupController> {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _BodyWidget(),
    );
  }
}

class _BodyWidget extends GetView<SignupController> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
