import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_app/res/values/strings.dart';

import '../container/icon_background_widget.dart';
import '../text_field/text_field_widget.dart';

class CommonSearchBottomSheetWidget extends StatelessWidget {
  const CommonSearchBottomSheetWidget({
    Key? key,
    required TextEditingController controller,
    this.onTap,
    this.onScannerTap,
    this.onTextChange,
    this.showScanner = false,
    this.scannedResult,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final VoidCallback? onTap;
  final VoidCallback? onScannerTap;
  final Function? onTextChange;
  final bool showScanner;
  final RxString? scannedResult;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.only(left: 5, top: 20, bottom: 30),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: TextFieldWidget(
              needCloseIcon: true,
              hint: Strings.kSearchHint,
              controller: _controller,
              onTextChange: (String text) {
                onTextChange!(text);
              },
            ),
          ),
          const SizedBox(width: 5),
          InkWell(
            onTap: onTap,
            child: IconBackgroundWidget(
              iconColor: Theme.of(context).backgroundColor,
              backgroundColor: Theme.of(context).cardColor,
              icon: Icons.search,
            ),
          ),
          _scannerRowWidget(context)
        ],
      ),
    );
  }

  _scannerRowWidget(BuildContext context) {
    return showScanner && _controller.text.isEmpty
        ? Row(
            children: [
              Container(
                width: 1.5,
                height: 40,
                color: Colors.grey,
              ),
              const SizedBox(width: 5),
              InkWell(
                onTap: onScannerTap,
                child: IconBackgroundWidget(
                  iconColor: Theme.of(context).backgroundColor,
                  backgroundColor: Theme.of(context).cardColor,
                  icon: Icons.qr_code_scanner_rounded,
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}
