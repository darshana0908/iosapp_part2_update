// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safe_encrypt/constants/colors.dart';
import 'package:safe_encrypt/screens/features/gallery/gallery_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pin_key_pad.dart';

// ignore: must_be_immutable
class UserPIn extends StatefulWidget {
  UserPIn({
    Key? key,
  }) : super(
          key: key,
        );

  List documents = [];
  bool owner = false;
  bool isLoading = true;
  bool clearicon = false;

  @override
  State<UserPIn> createState() => _UserPInState();
}

class _UserPInState extends State<UserPIn> {
  final TextEditingController controler_re_enter_pin = TextEditingController();
  bool backspacecolorchange = true;
  bool bActive = false;
  bool newpin_nuber = true;
  String usern = '';
  String pas = '';
  String data = '';

  bool confirm_pin = true;
  String name = '';
  bool ownerlogin = true;
  bool isLoading = true;

  late SharedPreferences preferences;
  @override
  void initState() {
    // getData();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: confirm_pin ? kdarkblue : kred,
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 12,
                          ),
                          confirm_pin
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  child: Image.asset(
                                    'assets/ic2.JPG',
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : const Text(''),
                          Text(
                            confirm_pin ? "" : " Pin Number Is Wrong Try Again",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: TextField(
                              textAlign: TextAlign.center,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              style: TextStyle(color: kwhite, fontSize: 60),
                              controller: controler_re_enter_pin,
                              keyboardType: TextInputType.none,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.backspace_rounded,
                                      size: 30,
                                      color: backspacecolorchange
                                          ? Colors.white60
                                          : kwhite),
                                  onPressed: () {
                                    controler_re_enter_pin.text =
                                        controler_re_enter_pin.text.substring(
                                            0,
                                            controler_re_enter_pin.text.length -
                                                1);
                                    setState(() {
                                      bActive = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          // const SizedBox(
                          //   height: 25,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PinKeyPad(
                                  keypad: '1',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;
                                      bActive = true;
                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}1';
                                    });
                                  }),
                              PinKeyPad(
                                  keypad: '2',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;
                                      bActive = true;
                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}2';
                                    });
                                  }),
                              PinKeyPad(
                                  keypad: '3',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;
                                      bActive = true;
                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}3';
                                    });
                                  }),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PinKeyPad(
                                  keypad: '4',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;
                                      bActive = true;
                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}4';
                                    });
                                  }),
                              PinKeyPad(
                                  keypad: '5',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;
                                      bActive = true;
                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}5';
                                    });
                                  }),
                              PinKeyPad(
                                  keypad: '6',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;
                                      bActive = true;
                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}6';
                                    });
                                  }),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PinKeyPad(
                                  keypad: '7',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;
                                      bActive = true;
                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}7';
                                    });
                                  }),
                              PinKeyPad(
                                  keypad: '8',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;
                                      bActive = true;
                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}8';
                                    });
                                  }),
                              PinKeyPad(
                                  keypad: '9',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;
                                      bActive = true;
                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}9';
                                    });
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                data,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 45,
                                    fontWeight: FontWeight.w600),
                              ),
                              PinKeyPad(
                                  keypad: '0',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;
                                      bActive = true;
                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}0';
                                    });
                                  }),
                              const SizedBox(
                                width: 42,
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () async {
                                  var _platform;

                                  if (controler_re_enter_pin.text.isNotEmpty) {
                                    if (Platform.isAndroid) {
                                      String path =
                                          "/storage/emulated/0/Android/data/com.example.safe_encrypt/files/safe/app/new/${controler_re_enter_pin.text}";
                                      bool directoryExists =
                                          await Directory(path).exists();
                                      bool fileExists =
                                          await File(path).exists();
                                      if (directoryExists || fileExists) {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => GalleryHome(
                                                  pinNumber:
                                                      controler_re_enter_pin
                                                          .text),
                                            ));
                                      } else {
                                        setState(() {
                                          confirm_pin = false;
                                          controler_re_enter_pin.clear();
                                        });
                                      }
                                    } else {
                                      // if ios
                                      var newPath;
                                      var directory =
                                          await getApplicationSupportDirectory();

                                      var iospath = directory.path;
                                      log(iospath);
                                      // creating the folder path

                                      // new directory

                                      // log(directory.path);

                                      print(newPath);
                                      // print(Directory(path));
                                      String path =
                                          '$iospath/safe/app/new/${controler_re_enter_pin.text}';
                                      log(path);
                                      // "/Users/ruwantha/Library/Developer/CoreSimulator/Devices/03528093-9FD9-4186-8F06-116553659B0A/data/Containers/Data/Application/C05536A4-9160-4136-BFDB-440B9A0187E6/Library/Application Support/safe/app/new/${controler_re_enter_pin.text}";
                                      bool directoryExists =
                                          await Directory(path).exists();
                                      bool fileExists =
                                          await File(path).exists();
                                      if (directoryExists || fileExists) {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => GalleryHome(
                                                  pinNumber:
                                                      controler_re_enter_pin
                                                          .text),
                                            ));
                                      } else {
                                        setState(() {
                                          confirm_pin = false;
                                          controler_re_enter_pin.clear();
                                        });
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 105,
                                  height: 105,
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: Colors.white60,
                                    size: 45,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
