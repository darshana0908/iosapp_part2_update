import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/colors.dart';

// requesting permission
Future<bool> requestPermission(Permission permission) async {
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

// show snackbar
showSnackBar(BuildContext context, {required String message, Color? color, int? duration}) {
  final scaffold = ScaffoldMessenger.of(context);

  scaffold.showSnackBar(
    SnackBar(
      elevation: 10,
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      duration: Duration(seconds: duration ?? 6),
      content: Row(
        children: [
          Icon(Icons.info, color: kwhite),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: TextStyle(color: kwhite))),
        ],
      ),
    ),
  );
}
