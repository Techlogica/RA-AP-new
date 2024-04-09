import 'package:rapid_app/res/utils/dynamic_default_value_generation/default_value.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';

dynamic comboConcatenate({
  required String fformula,
  dynamic obj,
  String? ptbName,
  String? tagTextValue,
}) async {
  String? tagTextValues=tagTextValue.toString().split(':').first.trim();
  try {
    String output = fformula;
    if (output.contains(":[")) {
      if (output.contains("LG_NAME")) {
        output = output.replaceAll(
            ":[LG_NAME]", RapidPref().getUserName().toString());
      }
      if (output.contains("LG_ID")) {
        output = output.replaceAll(
            ":[LG_ID]", RapidPref().getLoginUserId().toString());
      }
      if (output.contains("PROJECT_ID")) {
        String? temp = RapidPref().getProjectId().toString();
        output = output.replaceAll(":[PROJECT_ID]", temp ?? "");
      }
      // if (output.contains("PH_SUPP_CODE")) {
      //   String? temp;
      //   temp = "S00012";
      //   output = output.replaceAll(":[PH_SUPP_CODE]", temp);
      //   return output;
      // }
      // if (output.contains("GH_COMP_CODE")) {
      //   String? temp;
      //   temp = "001";
      //   output = output.replaceAll(":[GH_COMP_CODE]", temp);
      //   return output;
      // }
      // if (output.contains("SUPP_COU_CODE")) {
      //   String? temp;
      //   temp = 'UAE';
      //   output = output.replaceAll(":[SUPP_COU_CODE]", temp);
      //   return output;
      // }
      if (output.contains("GS:[")) {
        String strFunction =
        output.substring(output.indexOf("GS:[") + 4, output.indexOf("]"));
        dynamic tmpOutPut = await getGlobalValue(strFunction);
        output = output.replaceAll("GS:[$strFunction]", tmpOutPut.toString());
      }

      if (obj is Map<String, dynamic>) {
        print('....obj$obj');
        obj.forEach((key, value) {
          if (output.contains(":[$key]")) {
            output = output.replaceAll(":[$key]", value.toString().split(':').first.trim());
            print('....value$value');
            print('........key$key');
          }
        });
      }

    } else if (output.contains("PTABLE_NAME")) {
      String tvAl = ptbName ?? "";
      output = output.replaceAll(":{{PTABLE_NAME}}", tvAl);
    }
    return output;
  } on Exception {
    rethrow;
  }
}
