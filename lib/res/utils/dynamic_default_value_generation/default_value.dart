import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rapid_app/data/api/api_client.dart';
import 'package:rapid_app/data/model/base/base_response.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/default_concatenator.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/formula.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/logs/logs.dart';
import 'package:rapid_app/res/values/strings.dart';
import 'combo_concatenate.dart';
import 'package:jiffy/jiffy.dart';

dynamic getDefaultValues(String defaultValue, dynamic row, String parentTable,
    dynamic parentRow, String datatype) async {
     debugPrint('................................getDefaultValues');
  try {
    Formula fc = Formula();
    dynamic resultParam = <String, dynamic>{};
    if (defaultValue.isNotEmpty) {
      if (defaultValue.startsWith("=")) {
        defaultValue = defaultValue.replaceRange(0, 1, '');
        if (defaultValue.startsWith("[FUNC")) {
          //db function
          String strFunction = defaultValue.substring(5);
          strFunction = strFunction.substring(0, strFunction.length - 2);
          var strPar = strFunction.split("(");
          String functionName = "";
          String columnName = "";
          for (var m in strPar) {
            if (m.startsWith(":")) {
              if (m.startsWith(":[")) {
                columnName = m.substring(2);
                columnName = columnName.substring(0, columnName.length - 1);
              } else {
                functionName = m.substring(1);
              }
            }
          }
          try {
            dynamic keyValue = '';
            List<Map<String, dynamic>> paramsData = [];
            for (var key in row.keys) {
              if (key == columnName) {
                keyValue = row[key];
                dynamic prms = {Strings.kName: key, Strings.kValue: keyValue};
                paramsData.add(prms);
              }
            }
            dynamic params = json.encode(paramsData);
            String query = 'SELECT $functionName (:$columnName) FROM DUAL';
            final response = await dbFunctions(query: query, param: params);
            resultParam['val'] = response.data;
          } catch (exp) {
            resultParam['val'] = 0;
          }
          return resultParam;
        }
        if (defaultValue.startsWith("[MFUNC")) {
          //db function with mutiple parameter
          //=[MFUNC:#FUNC_NAME(:P_SYS_ID=:[ND_AMOUNT]�:P_CR_USER =:[ND_DOC_DATE])]

          String strFunction =
              defaultValue.substring(defaultValue.indexOf("[MFUNC") + 6);
          final endIndex = strFunction.indexOf(")]", 0);
          strFunction = strFunction.substring(0, endIndex);

          var strPar = strFunction.split("(");
          String functionName = "";
          String columnName = "";
          for (var m in strPar) {
            if (m.startsWith(":")) {
              if (m.startsWith(":#")) {
                functionName = m.replaceRange(0, 2, '');
              } else {
                columnName = m;
              }
            }
          }

          Map<String, Object> strparam = <String, Object>{};
          strparam.clear();
          String prodcr = "";
          var tmp = "";
          var tmp2 = "";
          prodcr = await comboConcatenate(
              fformula: columnName, obj: row, ptbName: parentTable);
          if (prodcr.contains("�")) {
            var strPar1 = prodcr.split("�");
            for (var m in strPar1) {
              var strVal = m.split("=");
              for (var n in strVal) {
                if (n.startsWith(":")) {
                  tmp = n;
                } else {
                  tmp2 = n;
                }
              }
              strparam[tmp] = tmp2;
            }
          } else {
            var strVal = prodcr.split("=");
            for (var n in strVal) {
              if (n.startsWith(":")) {
                tmp = n;
              } else {
                tmp2 = n;
              }
            }
            strparam[tmp] = tmp2;
          }

          try {
            List<Map<String, dynamic>> paramsData = [];
            var columns = '';

            // Logs.logData("row:::", row.toString());
            // Logs.logData("strparam:::", strparam.toString());

            for (var key in strparam.keys) {
              columns = columns + key + ',';

              dynamic prms = {
                Strings.kName: key,
                Strings.kValue: strparam[key]
              };
              paramsData.add(prms);
            }
            columns = columns.substring(0, columns.length - 1);
            dynamic params = json.encode(paramsData);
            String query = 'SELECT $functionName ($columns) RESULT FROM DUAL';
            final response = await dbFunctions(query: query, param: params);
            dynamic rslt;
            if (response.status) {
              rslt = response.data[0]['RESULT'];
            }

            if (rslt == null) {
              resultParam['val'] = 0;
            } else {
              resultParam['val'] = rslt;
            }
          } on Exception {
            resultParam['val'] = 0;
          }
          return resultParam;
        }
        if (defaultValue.startsWith("*")) {
          try {
            resultParam['val'] = 0;
          } on Exception {
            resultParam['val'] = 0;
          }
          return resultParam;
        }
        if (defaultValue.startsWith("#")) {
          defaultValue = defaultValue.replaceRange(0, 1, '');
          if (datatype == "DATE") {
            if (defaultValue.contains(":[")) {
              Map<String, dynamic> map = row;
              if (map.isNotEmpty) {
                for (var value in map.keys) {
                  dynamic tmpval;
                  if (defaultValue.contains(value)) {
                    tmpval = row[value];
                    tmpval ??= 0;
                    String valKey = ":[" + value + "]";
                    String valValue = tmpval.toString();
                    defaultValue = defaultValue.replaceAll(valKey, valValue);
                  }
                }

                try {
                  DateTime rslt = DateTime.now();
                  if (defaultValue.startsWith("DT")) {
                    DateTime tmp = DateTime.now();
                    String dtc = "";
                    int tmp2 = 0;
                    var strVal = defaultValue.split("+");
                    for (var dt in strVal) {
                      if (dt.startsWith("DT")) {
                        dtc = dt.replaceRange(0, 2, '');
                        tmp = DateTime.parse(dtc);
                      } else {
                        tmp2 = int.parse(dt);
                      }
                    }
                    rslt =
                        DateTime.parse(Jiffy(tmp).add(days: tmp2).toString());
                  }
                  if (defaultValue.startsWith("MN")) {
                    DateTime tmp = DateTime.now();
                    String dtc = "";
                    int tmp2 = 0;
                    var strVal = defaultValue.split("+");
                    for (var dt in strVal) {
                      if (dt.startsWith("MN")) {
                        dtc = dt.replaceRange(0, 2, '');
                        tmp = DateTime.parse(dtc);
                      } else {
                        tmp2 = int.parse(dt);
                      }
                    }

                    rslt =
                        DateTime.parse(Jiffy(tmp).add(months: tmp2).toString());
                  }
                  if (defaultValue.startsWith("YR")) {
                    DateTime tmp = DateTime.now();
                    String dtc = "";
                    int tmp2 = 0;
                    var strVal = defaultValue.split("+");
                    for (var dt in strVal) {
                      if (dt.startsWith("YR")) {
                        dtc = dt.replaceRange(0, 2, '');
                        tmp = DateTime.parse(dtc);
                      } else {
                        tmp2 = int.parse(dt);
                      }
                    }
                    rslt =
                        DateTime.parse(Jiffy(tmp).add(years: tmp2).toString());
                  }

                  resultParam['val'] = rslt;
                } on Exception {
                  rethrow;
                }
                return resultParam;
              } else {
                return resultParam['val'] = '';
              }
            }
          } else {
            if (defaultValue.contains(":[")) {
              var map = row;
              if (map != null) {
                for (var value in map.keys) {
                  String tmpval;
                  if (defaultValue.contains(value)) {
                    tmpval = row[value].toString();

                    tmpval = tmpval == '' ? "0" : tmpval;
                    String valKey = ":[" + value + "]";
                    String valValue = tmpval.toString();
                    defaultValue = defaultValue.replaceAll(valKey, valValue);
                  }
                }

                RegExp exp = RegExp("&(.*?)&");
                dynamic allMatchResults = exp.stringMatch(defaultValue);
                List<dynamic> res = [];
                if (allMatchResults != null) {
                  res = allMatchResults;
                  for (Match match in res) {
                    var res = match.input;
                    var result = match.group(1).toString();

                    final rqqr = await ApiClient()
                        .rapidRepo
                        .getQueryDynamicValue(query: result);
                    double rgvql = 0;
                    if (rqqr.data != null) {
                      if (rqqr.data.Count != 0) {
                        for (Map<String, Object> kvp in rqqr.data[0]) {
                          rgvql = double.parse(kvp.values.toString());
                          defaultValue = defaultValue.replaceAll(
                              res.toString(), rgvql.toString());
                        }
                      }
                    }
                  }
                }
              }

              try {
                resultParam['val'] =
                    fc.programs(defaultValue.trim()).toString();
              } on Exception {
                resultParam['val'] = 0;
              }
              return resultParam;
            } else {
              return resultParam['val'] = '';
            }
          }
          return resultParam;
        }
        if (defaultValue.startsWith(":{")) {
          var strDefault = defaultValue.replaceRange(
              0, defaultValue.length - 1, defaultValue);
          strDefault = strDefault.replaceRange(0, 2, '');
          if (strDefault.contains("DateTime.Today")) {
            strDefault = strDefault.replaceAll(
                "DateTime.Today", Jiffy(DateTime.now(), "ddMMyyyy").toString());
          }
          var strPar = strDefault.split(".");
          String tablename = "";
          dynamic paramFld = "";
          int defctr = 0;

          for (var m in strPar) {
            if (m.startsWith(":[")) {
              if (m.contains("+")) {
                resultParam['val'] = fc.multiConcatenator(r'$' + m, parentRow);
                defctr++;
              } else {
                paramFld = m.substring(m.indexOf(":[") + 2);
                paramFld = paramFld.substring(0, paramFld.indexOf("]"));
              }
            } else {
              tablename = m;
            }
          }
          if (defctr == 0) {
            if (parentTable == tablename) {
              var val = parentRow[paramFld];
              resultParam['paramFld'] = paramFld;
              resultParam['val'] = val;
            }
          }
          return resultParam;
        }
        if (defaultValue.startsWith("ENC")) {
          //Equation
          defaultValue = defaultValue.replaceRange(0, 3, '');

          if (defaultValue.contains(":[")) {
            //column name
            Map<String, dynamic> map = row;

            for (var value in map.keys) {
              dynamic tmpval;
              if (defaultValue.contains(value)) {
                tmpval = row[value];
                tmpval ??= " ";
                String valKey = ":[" + value + "]";
                String valValue = tmpval.toString();
                defaultValue = defaultValue.replaceAll(valKey, valValue);
              }
            }
            resultParam['val'] = defaultValue;
            return resultParam;
          }
        }
        if (defaultValue.startsWith("QRY[")) {
          //for getting auto increment value query
          defaultValue = defaultValue.replaceRange(0, 4, '');
          String strFunction =
              defaultValue.substring(0, defaultValue.length - 1);

          if (strFunction.contains(":[")) {
            Map<String, dynamic> map = {};
            map.addAll(row);
            if (map.isNotEmpty) {
              for (var value in map.keys) {
                dynamic tmpval = '';
                if (strFunction.contains(value)) {
                  tmpval = row[value];
                  tmpval ??= "0";
                  String keyRplce = ":[" + value + "]";
                  String valueRplce = tmpval.toString();

                  String strFunction1 =
                      strFunction.replaceAll(keyRplce, valueRplce);
                  strFunction = strFunction1;
                }
              }
            }
          }
          final tmpOutPut = await ApiClient()
              .rapidRepo
              .getQueryDynamicValue(query: strFunction);
          if (tmpOutPut.data.length != 0) {
            Map<String, dynamic> outputData = tmpOutPut.data[0];
            for (var kvp in outputData.keys) {
              resultParam['val'] = outputData[kvp];
            }
          } else {
            return resultParam['val'] = '';
          }

          return resultParam;
        }
        if (defaultValue.startsWith("QRYPARAM[")) {
          //for query with parameters
          defaultValue = defaultValue.replaceRange(0, 9, '');
          String strFunction = defaultValue.replaceAll("]", '').trim();

          Map<String, dynamic> param = {};
          Map<String, dynamic> map = {};
          List<Map<String, dynamic>> params = [];
          map.addAll(row);
          if (map.isNotEmpty) {
            for (var value in map.keys) {
              dynamic tmpval = '';
              if (strFunction.contains(value)) {
                String rowValue = row[value];
                if (rowValue.contains('.0')) {
                  rowValue = rowValue.split('.').first;
                }
                tmpval = rowValue;
                tmpval ??= "0";
                param[value] = tmpval;
              }
            }
          }

          map.addAll(parentRow);

          if (map.isNotEmpty) {
            for (var value in map.keys) {
              dynamic tmpval = '';
              if (strFunction.contains(value)) {
                tmpval = row[value];
                if (tmpval == null) {
                  tmpval = map[value];
                  tmpval ??= "0";
                }
                if (tmpval.contains('.0')) {
                  tmpval = tmpval.split('.').first;
                }
                param[value] = tmpval;
                dynamic prms = {Strings.kName: value, Strings.kValue: tmpval};
                params.add(prms);
              }
            }
          }

          dynamic paramData = json.encode(params);
          final response =
              await dbFunctions(query: strFunction, param: paramData);

          if (response.data?.length != 0) {
            Map<String, dynamic> outputData = response.data[0];
            for (var kvp in outputData.keys) {
              resultParam['val'] = outputData[kvp];
            }
          } else {
            return resultParam['val'] = '';
          }
          return resultParam;
        }
        if (defaultValue.startsWith("QRYPARAM2[")) {
          //for query with parameters
          defaultValue = defaultValue.replaceRange(0, 10, '');
          String strFunction = defaultValue.replaceAll("]", '').trim();

          Map<String, dynamic> param = {};
          Map<String, dynamic> map = {};
          List<Map<String, dynamic>> params = [];
          map.addAll(row);
          if (map.isNotEmpty) {
            for (var value in map.keys) {
              dynamic tmpval = '';
              if (strFunction.contains(value)) {
                String rowValue = row[value];
                if (rowValue == null) {
                  rowValue = map[value];
                  rowValue ??= "0";
                }
                if (rowValue.contains('.0')) {
                  rowValue = rowValue.split('.').first;
                }
                tmpval = rowValue;
                param[value] = tmpval;
              }
            }
          }

          map.addAll(parentRow);

          if (map.isNotEmpty) {
            for (var value in map.keys) {
              dynamic tmpval = '';
              if (strFunction.contains(value)) {
                tmpval = row[value];
                if (tmpval.contains('.0')) {
                  tmpval = tmpval.split('.').first;
                }
                tmpval ??= "0";
                param[value] = tmpval;
                dynamic prms = {Strings.kName: value, Strings.kValue: tmpval};
                params.add(prms);
              }
            }
          }

          dynamic paramData = json.encode(params);
          final response =
              await dbFunctions(query: strFunction, param: paramData);

          if (response.data.length != 0) {
            Map<String, dynamic> outputData = response.data[0];
            for (var kvp in outputData.keys) {
              resultParam['val'] = outputData[kvp];
            }
          } else {
            return resultParam['val'] = '';
          }
          return resultParam;
        }
        if (defaultValue.startsWith("DATE[")) {
          defaultValue = defaultValue.replaceRange(0, 5, '');
          String strFunction =
              defaultValue.replaceRange(0, defaultValue.length - 1, '');
          String yrval = "";
          String datevl = "";
          String dyval = "";
          String eqn = "";
          String mnval = "";
          var strVal = strFunction.split(",");
          Logs.logData("strVal::", strVal.toString());
          for (var dt in strVal) {
            if (dt.startsWith(":[")) {
              if (row != null) {
                Map<String, dynamic> map = row;

                for (var value in map.keys) {
                  if (dt.contains(value)) {
                    dynamic tmpval = row[value];
                    tmpval ??= DateTime.now();
                    var formatter = DateFormat("dd/MMM/yy");
                    tmpval = formatter.format(tmpval);

                    String replaceText = ":[" + value + "]";
                    datevl = dt.replaceAll(replaceText, tmpval.toString());
                  }
                }
              }
            } else if (dt.startsWith(":")) {
              if (row != null) {
                Map<String, dynamic> map = row;

                for (var value in map.keys) {
                  if (dt.contains(value)) {
                    dynamic tmpval = row[value];
                    tmpval ??= DateTime.now();
                    var formatter = DateFormat("dd/MMM/yy");
                    tmpval = formatter.format(tmpval);

                    String replaceText = ":" + value;
                    datevl = dt.replaceAll(replaceText, tmpval.toString());
                  }
                }
              }
            } else {
              eqn = dt;
            }
          }
          String dtqry = "";
          if (RapidPref().getProjectDb() == "Oracle") {
            if (eqn.contains("DAY")) {
              dtqry = "SELECT EXTRACT(DAY FROM DATE '" +
                  datevl +
                  "' ) as DATEVL FROM DUAL";
              final q = await ApiClient()
                  .rapidRepo
                  .getQueryDynamicValue(query: dtqry);
              if (q.data != null) {
                if (q.data.Count != 0) {
                  for (Map<String, Object> kvp in q.data[0]) {
                    dyval = kvp.values.toString();
                    eqn = eqn.replaceAll("DAY", dyval);
                  }
                }
              }
            }
            if (eqn.contains("MONTH")) {
              dtqry = "SELECT EXTRACT(MONTH FROM DATE '" +
                  datevl +
                  "' ) as DATEVL FROM DUAL";
              final q = await ApiClient()
                  .rapidRepo
                  .getQueryDynamicValue(query: dtqry);
              if (q.data != null) {
                if (q.data.Count != 0) {
                  for (Map<String, Object> kvp in q.data[0]) {
                    mnval = kvp.values.toString();
                    eqn = eqn.replaceAll("MONTH", mnval);
                  }
                }
              }
            }
            if (eqn.contains("MON")) {
              dtqry = "select to_char(to_date('" +
                  datevl +
                  "','YYYY-MM-DD'),'Mon') as month from dual";
              final q = await ApiClient()
                  .rapidRepo
                  .getQueryDynamicValue(query: dtqry);
              if (q.data != null) {
                if (q.data.Count != 0) {
                  for (Map<String, Object> kvp in q.data[0]) {
                    mnval = kvp.values.toString();
                    eqn = eqn.replaceAll("MON", mnval);
                  }
                }
              }
            }
            if (eqn.contains("YEAR")) {
              dtqry = "SELECT EXTRACT(YEAR FROM DATE '" +
                  datevl +
                  "' ) as DATEVL FROM DUAL";
              final q = await ApiClient()
                  .rapidRepo
                  .getQueryDynamicValue(query: dtqry);
              if (q.data != null) {
                if (q.data.Count != 0) {
                  for (Map<String, Object> kvp in q.data[0]) {
                    yrval = kvp.values.toString();
                    eqn = eqn.replaceAll("YEAR", yrval);
                  }
                }
              }
            }
          } else {
            if (eqn.contains("DAY")) {
              dtqry = "SELECT DAY ( '" + datevl + "' ) as DATEVL ";
              final q = await ApiClient()
                  .rapidRepo
                  .getQueryDynamicValue(query: dtqry);
              if (q.data != null) {
                if (q.data.Count != 0) {
                  for (Map<String, Object> kvp in q.data[0]) {
                    dyval = kvp.values.toString();
                    eqn = eqn.replaceAll("DAY", dyval);
                  }
                }
              }
            }
            if (eqn.contains("MONTH")) {
              dtqry = "SELECT MONTH ('" + datevl + "' ) as DATEVL";
              final q = await ApiClient()
                  .rapidRepo
                  .getQueryDynamicValue(query: dtqry);
              if (q.data != null) {
                if (q.data.Count != 0) {
                  for (Map<String, Object> kvp in q.data[0]) {
                    mnval = kvp.values.toString();
                    eqn = eqn.replaceAll("MONTH", mnval);
                  }
                }
              }
            }
            if (eqn.contains("YEAR")) {
              dtqry = "SELECT YEAR('" + datevl + "' ) as DATEVL";
              final q = await ApiClient()
                  .rapidRepo
                  .getQueryDynamicValue(query: dtqry);
              if (q.data != null) {
                if (q.data.Count != 0) {
                  for (Map<String, Object> kvp in q.data[0]) {
                    yrval = kvp.values.toString();
                    eqn = eqn.replaceAll("YEAR", yrval);
                  }
                }
              }
            }
          }
          resultParam['val'] = eqn;

          return resultParam;
        }
        if (defaultValue.startsWith("CONCAT")) {
          //=CONCAT[PRTK,[FUNC:MEMID_SEQ_GEN]]
          defaultValue = defaultValue.replaceRange(0, 7, '');
          defaultValue =
              defaultValue.replaceRange(0, defaultValue.length - 1, '');
          var strPar = defaultValue.split(",");
          String functionName = "";
          String columnName = "";
          for (var item in strPar) {
            if (item.contains("[FUNC")) {
              //db function
              String strFunction = item.replaceRange(0, 5, '');
              strFunction =
                  strFunction.replaceRange(0, strFunction.length - 1, '');
              var strPar1 = strFunction.split("(");
              for (var m in strPar1) {
                if (m.startsWith(":")) {
                  if (m.startsWith(":[")) {
                    columnName = m.replaceRange(0, 2, '');
                    columnName =
                        columnName.replaceRange(0, columnName.length - 1, '');
                  } else {
                    functionName = m.replaceRange(0, 1, '');
                  }
                }
              }
              try {
                dynamic keyValue = '';
                for (var key in row.keys) {
                  if (key == columnName) {
                    keyValue = row[key];
                  }
                }
                Map<String, dynamic> paramsData = {
                  Strings.kName: columnName,
                  Strings.kValue: keyValue
                };
                dynamic params = json.encode(paramsData);
                String query = 'SELECT $functionName (:$columnName) FROM DUAL';
                final response = await dbFunctions(query: query, param: params);
                var rslt = response.data;
                defaultValue = defaultValue.replaceAll(item, rslt.toString());
                defaultValue = defaultValue.replaceAll(",", "+");
              } catch (exp) {
                resultParam['val'] = 0;
              }
            }
          }

          Map<String, dynamic> map = row;
          if (map.isNotEmpty) {
            for (var value in map.keys) {
              dynamic tmpval;
              if (defaultValue.contains(value)) {
                tmpval = row[value];
                tmpval ??= "0";
                String valKey = ":[" + value + "]";
                String valValue = tmpval.toString();
                defaultValue = defaultValue.replaceAll(valKey, valValue);
              }
            }
            String rslt = fc.concatenator(defaultValue);
            resultParam['val'] = rslt;

            return resultParam;
          }
        }
      } else if (defaultValue.startsWith(r'[$]')) {
        try {
          String strEquation = defaultValue.replaceRange(0, 1, '');
          resultParam['val'] = await comboConcatenate(
              fformula: strEquation, obj: row, ptbName: parentTable);
        } on Exception {
          resultParam['val'] = "";
        }
        return resultParam;
      } else if (defaultValue.contains("%QRY[")) {
        int xval = 0;
        String zval = "";
        var strPar = defaultValue.split("+");
        for (var m in strPar) {
          if (m.startsWith("%QRY[")) {
            defaultValue = m.replaceRange(0, 5, '');
            String strFunction =
                defaultValue.replaceRange(0, defaultValue.length - 1, '');
            final tmpoutput = await ApiClient()
                .rapidRepo
                .getQueryDynamicValue(query: strFunction);
            if (tmpoutput.data.Count != 0) {
              for (Map<String, Object> kvp in tmpoutput.data[0]) {
                xval = int.parse(kvp.values.toString());
              }
            } else {
              return resultParam['val'] = '';
            }
          } else {
            zval = m;
          }
        }
        resultParam['val'] = zval + xval.toString();

        return resultParam;
      } else if (defaultValue.startsWith("GS:[")) {
        defaultValue = defaultValue.substring(defaultValue.indexOf("[") + 1);
        defaultValue = defaultValue.substring(0, defaultValue.indexOf("]"));

        dynamic tmpOutPut = await getGlobalValue(defaultValue);
        resultParam['val'] = tmpOutPut;
        return resultParam;
      } else if (defaultValue.startsWith("\$:[")) {
        defaultValue = defaultValue.substring(defaultValue.indexOf("[") + 1);
        defaultValue = defaultValue.substring(0, defaultValue.indexOf("]"));
        dynamic tmpOutPut = '';
        if (defaultValue.trim() == "LG_ID") {
          tmpOutPut = RapidPref().getLoginUserId().toString();
        } else if (defaultValue.trim() == "LG_NAME") {
          tmpOutPut = RapidPref().getUserName().toString();
        } else {
          tmpOutPut = row[defaultValue];
        }
        resultParam['val'] = tmpOutPut;
        return resultParam;
      } else {
        if (defaultValue.trim() == "LG_ID") {
          resultParam['val'] = RapidPref().getLoginUserId().toString();
          return resultParam;
        } else if (defaultValue.trim() == "LG_NAME") {
          resultParam['val'] = RapidPref().getUserName().toString();
          return resultParam;
        } else {
          resultParam['val'] = defaultValue;
          return resultParam;
        }
      }
    } else {
      resultParam['val'] = '';
    }
  } on Exception {
    rethrow;
  }
}

dynamic getGlobalValue(String defaultValue) async {
  String globalKey = RapidPref().getGlobalSettingKey().toString();
  if (globalKey == defaultValue) {
    String globalValue = RapidPref().getGlobalSettingValue().toString();
    return globalValue;
  }
  final result = await fetchGlobalSettingsValue(
    defaultVal: defaultValue,
  );
  if (result.status) {
    dynamic responseData = result.data[0][defaultValue];
    return responseData;
  } else {
    return '';
  }
}

Future<BaseResponse> fetchGlobalSettingsValue({
  required String defaultVal,
}) async {
  /// getting table data
  final result = await getGlobalSettingsTable();

  String tableName, tableWhere;
  if (result.status) {
    dynamic res = result.data[0];
    Map<String, dynamic> dataMap = res;
    tableName = dataMap['MDT_TBL_NAME'].toString();
    tableWhere = dataMap['MDT_DEFAULTWHERE'].toString();
  } else {
    tableName = '';
    tableWhere = '';
  }

  /// getting data from the API
  String defaultValue =
      await defaultConcatenation(formula: tableWhere, prtTbName: tableName);
  final response = await ApiClient().rapidRepo.getGlobalSettingValue(
        tableName: tableName,
        where: defaultValue,
      );

  return response;
}

Future<BaseResponse> getGlobalSettingsTable() async {
  /// getting data from the API
  final response = await ApiClient().rapidRepo.getMetaDataTableData(
        sysId: RapidPref().getGlobalSettingsTableId().toString(),
      );
  return response;
}

Future<BaseResponse> dbFunctions({
  required String query,
  required dynamic param,
}) async {
  /// Getting meta data from the API
  BaseResponse result = await ApiClient().rapidRepo.getCommonSearch(
        query: query,
        param: param,
      );
  return result;
}
