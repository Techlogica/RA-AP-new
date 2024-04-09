import 'package:flutter/material.dart';

class CardContainerWidget extends StatelessWidget {
  const CardContainerWidget({
    Key? key,
    required this.cardWidget,
  }) : super(key: key);

  final Widget cardWidget;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      elevation: 10,
      shadowColor: Theme.of(context).backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.only(left: 4, right: 4),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                width: 1,
                color: Colors.white10,
              ),
              shape: BoxShape.rectangle),
          child: cardWidget),
    );
  }
}
