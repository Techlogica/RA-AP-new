import 'package:rapid_app/res/utils/dynamic_default_value_generation/default_value.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';

class User {
  String lgId;
  String lgName;

  User({required this.lgId, required this.lgName});
}

dynamic defaultConcatenation(
    {required String formula, String? prtTbName}) async {
  try {
    String output = "";
    String userid = RapidPref().getLoginUserId().toString();
    String username = RapidPref().getUserName().toString();
    // User user = User(lgId: userid, lgName: username);

    String strEquation = formula;
    if (strEquation.contains("=[FUNC:")) {
      String strsubequation =
          strEquation.substring(strEquation.indexOf("=[FUNC:"));

      Map<String, dynamic> objuser = <String, dynamic>{};
      objuser["LG_NAME"] = username;
      objuser["LG_ID"] = userid;

      dynamic result = await getDefaultValues(
          strsubequation.substring(0, strsubequation.indexOf(")]") + 2),
          objuser,
          "",
          objuser,
          "STRING");

      String data = result['val'].toString();
      var valSpl = data.split('): ');
      String resultData = valSpl[1].substring(0, valSpl[1].length - 2);

      strEquation = strEquation.replaceAll(
          strsubequation.substring(0, strsubequation.indexOf(")]") + 2),
          resultData);
    }
    if (strEquation.contains("LG_NAME")) {
      String tempi = username;
      strEquation = strEquation.replaceAll(":[LG_NAME]", tempi);
    }
    if (strEquation.contains("LG_ID")) {
      String tempid = userid;
      strEquation = strEquation.replaceAll(":[LG_ID]", tempid);
    }
    if (strEquation.contains("PROJECT_ID")) {
      String temp;
      temp = RapidPref().getProjectId().toString();
      strEquation = strEquation.replaceAll(":[PROJECT_ID]", temp);
    }
    if (strEquation.contains("PTABLE_NAME")) {
      String tval;
      tval = prtTbName.toString();
      strEquation = strEquation.replaceAll(":{{PTABLE_NAME}}", tval);
    }
    if (strEquation.contains("GS:[")) {
      String strFunction =
          strEquation.substring(strEquation.indexOf("GS:[") + 4);
      strFunction = strFunction.substring(0, strFunction.indexOf("]"));

      dynamic tmpOutPut = await getGlobalValue(strFunction);
      String rplceBfr = 'GS:[$strFunction]';
      strEquation = strEquation.replaceAll(rplceBfr, tmpOutPut);
    }
    output = strEquation;
    return output;
  } on Exception {
    rethrow;
  }
}
