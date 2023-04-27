import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/html_parser.dart';

class ICard extends StatelessWidget {
  const ICard({Key? key, required this.text, required this.icon})
      : super(key: key);

  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(icon),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
