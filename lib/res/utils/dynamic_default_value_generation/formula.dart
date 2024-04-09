import 'package:equations/equations.dart';
import 'package:stack/stack.dart';

class Formula {
  programs(String input) {
    try {

      const parser = ExpressionParser();
      var result = parser.evaluate(input);

      return result;
    } on Exception {
      return 0;
    }
  }

  String concatenator(String input) {
    try {
      var list = input
          .split("([+])")
          .where((x) => x.isNotEmpty)
          .where((x) =>
      x
          .toString()
          .isNotEmpty);
      String result = "";

      Stack numStack = Stack();
      Stack opStack = Stack();
      bool fetchNumber = true;
      for (var m in list) {
        if (m == "(") {
          opStack.push(m);
        } else if (m == ")") {
          walkString(numStack: numStack, opStack: opStack, close: true);
        } else {
          if (fetchNumber) {
            if (m.contains(":[SPACE]")) {
              String number = " ";
              numStack.push(number);
            } else {
              String number = m.trim();
              numStack.push(number);
            }
          } else {
            if (m == "+" || m == "-") {
              walkString(numStack: numStack, opStack: opStack, close: false);
            }
            opStack.push(m);
          }
          fetchNumber = !fetchNumber;
        }
      }
      walkString(numStack: numStack, opStack: opStack, close: false);

      result = numStack.pop().toString();
      return result;
    } on Exception {
      return '';
    }
  }

  double calculate(String input) {
    try {
      var list =
      input.split("([+*-/()])").where((x) =>
      x
          .toString()
          .isNotEmpty);
      double result = 0;

      Stack numStack = Stack();
      Stack opStack = Stack();
      bool fetchNumber = true;
      for (var m in list) {
        if (m == "(") {
          opStack.push(m);
        } else if (m == ")") {
          walk(numStack: numStack, opStack: opStack, close: true);
        } else {
          if (fetchNumber) {
            double number = double.parse(m.trim());
            numStack.push(number);
          } else {
            if (m == "+" || m == "-") {
              walk(numStack: numStack, opStack: opStack);
            }
            opStack.push(m);
          }
          fetchNumber = !fetchNumber;
        }
      }
      walk(numStack: numStack, opStack: opStack);
      result = double.parse(numStack.pop());
      return result;
    } on Exception {
      return 0;
    }
  }

  void walk({Stack? numStack, Stack? opStack, bool close = false}) {
    try {
      if (numStack!.isNotEmpty && opStack!.isNotEmpty) {
        while (opStack.size() > 0 && numStack.size() > 1) {
          if (opStack.top().toString() == "(") {
            if (close) {
              opStack.pop();
            }
            break;
          }
          String operation = opStack.pop().toString();
          double d2 = double.parse(numStack.pop());
          double d1 = double.parse(numStack.pop());
          double z1 = 0;
          switch (operation) {
            case "+":
              z1 = d1 + d2;
              break;
            case "-":
              z1 = d1 - d2;
              break;
            case "*":
              z1 = d1 * d2;
              break;
            case "/":
              z1 = d1 / d2;
              break;
          }
          numStack.push(z1);
        }
      }
    } on Exception {
      rethrow;
    }
  }

  void walkString({
    Stack? numStack,
    Stack? opStack,
    bool close = false,
  }) {
    try {
      if (opStack!.isNotEmpty && numStack!.isNotEmpty) {
        while (opStack.size() > 0 && numStack.size() > 1) {
          if (opStack.top().toString() == "(") {
            if (close) {
              opStack.pop();
            }
            break;
          }
          String operation = opStack.pop().toString();
          String d2 = numStack.pop().toString();
          String d1 = numStack.pop().toString();
          String z1 = "";
          switch (operation) {
            case "+":
              z1 = d1 + d2;
              break;
          }
          numStack.push(z1);
        }
      }
    } on Exception {
      rethrow;
    }
  }

  dynamic multiConcatenator(String formula, dynamic obj) {
    try {
      String output;
      dynamic tmpval;
      Formula fc = Formula();

      String strEquation = formula.replaceRange(0, 1,'');

      if (obj != null) {
        var map = obj;

        for (var value in map.Keys) {
          if (strEquation.contains("[FUNC")) {
            var str = strEquation.split("?");
            dynamic str2 = "";
            dynamic str1 = "";
            for(var m in str)
            {
              if (m.contains("[FUNC")) {
                //str1 = Convert.ToDateTime(DbFunctions(m, obj));
              }
              else {
                str2 += m;
              }
              strEquation = str1 + str2;
            }

            output = fc.programs(strEquation).toString();
          }

          if (strEquation.contains(value)) {
            tmpval = obj[value];
            tmpval ??= "''";
            String valueType = ":[" + value + "]";
            strEquation =
                strEquation.replaceAll(valueType, tmpval.toString());
          }
        }
        for (int i = 0; strEquation.contains(":["); i++) {
          String befrstrEquatio = strEquation.substring(
              0, strEquation.indexOf(":["));
          String aftrstrEquatio = strEquation.substring(
              strEquation.indexOf("]") + 1);
          strEquation = befrstrEquatio + "''" + aftrstrEquatio;
        }
      }
      output = concatenator(strEquation).toString();
      return output;
    }
    on Exception {
      rethrow;
    }
  }
}
