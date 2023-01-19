import 'package:flutter/material.dart';
import 'package:safe_encrypt/constants/colors.dart';
import 'package:safe_encrypt/screens/features/auth/components/pin_number/user_pin.dart';

class AppIcon extends StatefulWidget {
  const AppIcon({Key? key}) : super(key: key);

  @override
  State<AppIcon> createState() {
    return _AppIconState();
  }
}

class _AppIconState extends State<AppIcon> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserPIn(),
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kdarkblue,
      body: Column(children: [
        const SizedBox(
          height: 140,
        ),
        Center(
            child: SizedBox(
                height: 125,
                child: Image.asset(
                  'assets/ic2.JPG',
                  fit: BoxFit.fill,
                ))),
      ]),
    );
  }
}
