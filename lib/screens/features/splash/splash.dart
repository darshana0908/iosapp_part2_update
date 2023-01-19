import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_encrypt/screens/features/permission/permission_screen.dart';
import 'package:safe_encrypt/services/icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/colors.dart';

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  // Obtain shared preferences.

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  late SharedPreferences preferences;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    Future.delayed(
      const Duration(seconds: 1),
      () {
        loadbool();
      },
    );
  }

  loadbool() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      var ownerlogin = sharedPreferences.getBool('ownerlogin');
      if (ownerlogin == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AppIcon()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PermissionScreen()),
        );
      }
    });
  }

  final sharedPreferences = SharedPreferences.getInstance();
  TextEditingController controler_pin = TextEditingController();

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

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
