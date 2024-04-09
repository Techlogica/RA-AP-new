import 'package:flutter/material.dart';

class RapidLoadingIndicator extends StatelessWidget {
  const RapidLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: const BorderDirectional(
          top: BorderSide(
            width: 1.0,
            color: Color(0x42000000),
          ),
        ),
      ),
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
          Theme.of(context).textTheme.bodyText2!.color,
        ),
      ),
    );
  }
}
