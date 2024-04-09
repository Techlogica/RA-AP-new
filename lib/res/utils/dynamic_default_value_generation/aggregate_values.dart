import 'dart:math';
import 'package:rapid_app/res/values/logs/logs.dart';

Future<num> aggrigateFunction(
    String aggFun, String column, List<dynamic> tmp) async {
  try {
    num result = 0;
    switch (aggFun.toUpperCase()) {
      case "SUM":
        result =
            tmp.map((item) => num.parse(item[column])).reduce((a, b) => a + b);
        break;
      case "AVG":
        result =
            tmp.map((item) => num.parse(item[column])).reduce((a, b) => a + b) /
                tmp.length;
        break;
      case "MIN":
        result = tmp.map((item) => num.parse(item[column])).reduce(min);
        break;
      case "MAX":
        result = tmp.map((item) => num.parse(item[column])).reduce(max);
        break;
      case "COUNT":
        result = tmp.toList().length;
        break;
    }
    return result;
  } catch (ex) {
    Logs.logData("ex::", ex.toString());
    return 0;
  }
}
