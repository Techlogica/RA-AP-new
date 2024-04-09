import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:rapid_app/data/module/charts/chart_controller.dart';
import 'dart:ui' as ui;
class ChartDashboardAmountWidget extends GetView<ChartController> {
  const ChartDashboardAmountWidget({
    required this.id,
    this.priceFormat,
    Key? key,
  }) : super(key: key);

  final int id;
  final String? priceFormat;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final price = controller.price(id: id);
        return Row(
          children: [
            SizedBox(
              child: price != null
                  ? Text(
                      _getValue(price.price, priceFormat,context) == 'null'
                          ? '---'
                          : _getValue(price.price, priceFormat,context),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color!),
                    )
                  : SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).backgroundColor,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  _getValue(String price, String? priceFormat,context) {
    if (price.isNotEmpty &&
        isNumeric(price.toString()) &&
        priceFormat != null) {
      switch (priceFormat) {
        case 'N0':
          double amt = double.parse(price);
          return amt.toInt().toString();
        case 'N2':
          return convertDecimals(price).toString();
        case '#,##,###,##.00':
          return convertDecimals(price).toString();
        default:
          return convertDecimals(price).toString();
      }
    } else {
      if (price.isEmpty) {
        return '';
      } else {
        return price.toString();
      }
    }
  }


  bool isNumeric(String value) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
    return numericRegex.hasMatch(value);
  }


  String convertDecimals(String? val) {
    double amount = double.parse(val.toString());
    String systemLocal=Intl.systemLocale;
    // debugPrint("system:$systemLocal");
    // Intl.defaultLocale = systemLocal;
    NumberFormat numberFormat = NumberFormat.decimalPattern(systemLocal);
    String convertedValue = numberFormat.format(amount);
    return convertedValue;
  }

}
