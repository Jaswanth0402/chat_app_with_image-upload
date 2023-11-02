import 'dart:convert';

import 'package:flutter/material.dart';

class MyImage extends StatelessWidget {
  final String? image;
  final String? sendname;
  final String? recievename;
  const MyImage({super.key,required this.image,required this.recievename,required this.sendname});

  @override
  Widget build(BuildContext context) {

    return  Align(
      alignment: recievename==sendname?Alignment.bottomRight:Alignment.bottomLeft,
      child: Image.memory(base64Decode(image!),fit: BoxFit.fill,));
  }
}