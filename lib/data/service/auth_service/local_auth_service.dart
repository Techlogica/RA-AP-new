import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  static final LocalAuthentication auth = LocalAuthentication();

  static Future<bool> canAuthenticate() async =>
      await auth.canCheckBiometrics || await auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      if (!await canAuthenticate()) return false;

      return await auth.authenticate(
          localizedReason: 'Use face ID to authenticate',
          options: const AuthenticationOptions(
              stickyAuth: true, useErrorDialogs: true));
    } catch (e) {
      debugPrint('Error $e');
      return false;
    }
  }
}
