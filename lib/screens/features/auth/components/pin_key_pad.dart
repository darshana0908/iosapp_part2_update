import 'package:flutter/material.dart';

class PinKeyPad extends StatefulWidget {
  const PinKeyPad({Key? key, required this.keypad, required this.click})
      : super(key: key);

  final String keypad;
  final Function() click;
  @override
  State<PinKeyPad> createState() => _PinKeyPadState();
}

class _PinKeyPadState extends State<PinKeyPad> {
  @override
  Widget build(BuildContext context) {
    return InkWell(borderRadius: BorderRadius.circular(100),
 
      onTap: widget.click,
      child: Container(
        alignment: Alignment.center,
        width: 105,
        height: 105,
    
        child: Text(
          widget.keypad,
          style: const TextStyle(
              color: Colors.white, fontSize: 40, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
