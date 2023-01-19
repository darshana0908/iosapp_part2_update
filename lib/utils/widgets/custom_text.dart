import 'package:flutter/material.dart';
import 'package:safe_encrypt/constants/colors.dart';

class MyText extends StatelessWidget {
  MyText({Key? key, required this.text}) : super(key: key);
  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Text(
        text,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
      ),
      Divider(
        color: kblack,
        thickness: 1,
      )
    ]));
  }
}
