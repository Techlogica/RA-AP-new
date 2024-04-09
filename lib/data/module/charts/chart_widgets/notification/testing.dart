import 'package:flutter/material.dart';

class TestingPage extends StatelessWidget {
  final String? payload;
  const TestingPage({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("hello"),),
      body:  Column(
        children: [
          Center(child: Text(payload??'',style:const TextStyle(fontSize: 29,color: Colors.black),))
        ],
      ),
    );
  }
}
