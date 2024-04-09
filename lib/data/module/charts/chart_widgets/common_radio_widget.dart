import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RadioButtom extends StatelessWidget {
   RadioButtom({super.key,
  this.radio,required this.text,this.onTap});
  var radio;
  String text;
  var onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          radio,
          Text(text,style: const TextStyle(color: Colors.black),),
        ],
      ),
    );
  }
}
