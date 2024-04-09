import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({
    Key? key,
    required this.image,
    required this.onTap,
    required this.title,
    this.type,
    this.isEnable
  }) : super(key: key);

  final String image;
  final String? type;
  final VoidCallback onTap;
  final String title;
  final bool? isEnable;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: Theme.of(Get.context!).textTheme.headline1!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto'),
          ),
        ),
        Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                alignment: Alignment.center,
                height: 100,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: image.toString() == ''
                      ? const DecorationImage(
                          image: AssetImage('assets/icons/placeholder.jpg'),
                        )
                      : image.contains('http')
                          ? DecorationImage(image: NetworkImage(image))
                          : DecorationImage(image: FileImage(File(image))),
                ),
              ),
            )),
      ],
    );
  }
}
