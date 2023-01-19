import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_encrypt/constants/colors.dart';

import '../../../utils/helper_methods.dart';
import '../auth/auth_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  final Directory directory = Directory(
      '/storage/emulated/0/Android/data/com.example.safe_encrypt/files');
  static const String realFolder = "folder";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kdarkblue,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(height: MediaQuery.of(context).size.height / 6 * 1),
            SizedBox(
                height: 230,
                width: 280,
                child: Image.asset(
                  'assets/ic.JPG',
                  fit: BoxFit.fill,
                )),
            SizedBox(height: MediaQuery.of(context).size.height / 6 * 1),
            Text(
              'Keepsafe needs access to  your file storage',
              style: TextStyle(
                  fontSize: 28, color: kwhite, fontWeight: FontWeight.w500),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 15),
            Text(
              'this allows keepsafe to access and  encrypt your photos or videos.',
              style: TextStyle(
                  fontSize: 19, color: kgray, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 25),
            InkWell(
              onTap: () async {
                var status = await Permission.storage.status;
                if (status.isGranted) {
                  // You can request multiple permissions at once.
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.storage,
                    Permission.camera,
                  ].request();
                  print(statuses[Permission
                      .storage]); // it should print PermissionStatus.granted
                }
                if (await requestPermission(Permission.storage)) {
                  // await createFolder(realFolder);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthScreen()));
                  // Either the permission was already granted before or the user just granted it.
                }
              },
              child: Container(
                alignment: Alignment.center,
                color: kblue,
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'GRANT ACCESS',
                  style: TextStyle(
                      fontSize: 17, color: kwhite, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 25),
            TextButton(
              child: const Text(
                'EXIT',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onPressed: () => exit(0),
            )
          ]),
        ),
      ),
    );
  }
}
