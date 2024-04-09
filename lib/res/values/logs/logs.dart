import 'dart:developer';

class Logs {
  static void logData(var logMessage, var logData) {
    bool logFlag = true;
    if (logFlag) {
      // log('Body: $body');
      // log('Response: ${response.bodyString}');
      log('$logMessage" "$logData');
    }
  }
}
