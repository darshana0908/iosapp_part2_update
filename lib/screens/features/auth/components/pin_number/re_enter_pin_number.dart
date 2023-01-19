import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_encrypt/accsess_name/address.dart';
import 'package:safe_encrypt/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:safe_encrypt/db/sqldb.dart';
import 'package:safe_encrypt/utils/helper_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../gallery/gallery_home.dart';
import '../pin_key_pad.dart';

class ReEnterPin extends StatefulWidget {
  const ReEnterPin({Key? key, required this.controler_pin}) : super(key: key);
  final TextEditingController controler_pin;

  @override
  State<ReEnterPin> createState() => _ReEnterPinState();
}

class _ReEnterPinState extends State<ReEnterPin> {
  @override
  void initState() {
    gettocken();

    // TODO: implement initState
    super.initState();
  }

  SqlDb sqlDb = SqlDb();

  final TextEditingController controler_re_enter_pin = TextEditingController();
  Directory? directory;
  bool backspacecolorchange = true;
  String newPath = '';
  bool newpin_nuber = true;
  String assets = 'assets/ic.JPG';
  var getmytocken;
  String mainFolder = "Main Album";
  var getEmail;
  var getName;
  gettocken() async {
    log('here');
    var url = Uri.http(token_ip, '$token_path/generateaccesstoken');
    var response = await http.post(url, body: {
      "grant_type": "client_credentials",
      "client_id": "test",
      "client_secret": "test123"
    });
    var mytocken = jsonDecode(response.body);
    getmytocken = mytocken['access_token'];
    print(mytocken['access_token']);
  }

  Future register() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      log('internetvvvvvv');
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      log('internetvvvvvv');
      // I am connected to a wifi network.
    } else {
      log('internetvvvvvvgggggggggggggggggggggg');
    }
    // Obtain shared preferences.
    final sharedPreferences = await SharedPreferences.getInstance();

    var headers = {
      'Authorization': 'Bearer $getmytocken',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    if (controler_re_enter_pin.text == widget.controler_pin.text) {
      FacebookAuth.instance.getUserData().then((value) async {
        String email = value['email'].toString();
        String uid = value['uid'].toString();
        String name = value['name'].toString();
        log(name);
        log(uid);
        log(email);
        headers.addAll(headers);
        var response = await http
            .post(Uri.parse('$data_address/resource'), headers: headers, body: {
          "status": 'fb',
          "name": value['name'].toString(),
          "email": email,
          "uid": uid,
        });

        var res = jsonDecode(response.body.toString());
        log(response.toString());
        log(res['id'].toString());
        String userId = res['id'].toString();

        await sharedPreferences.setString('user_id', userId);
        log(userId);

        if (response.statusCode == 200) {
        } else {
          print(response.reasonPhrase);
        }
        // var data = jsonDecode(response.body);
      });
    }
    if (controler_re_enter_pin.text == widget.controler_pin.text) {
      final user = FirebaseAuth.instance.currentUser!;
      final pinNumber = controler_re_enter_pin.text.toString();
      final username = user.displayName.toString();
      final email = user.email.toString();
      final uid = user.uid.toString();
      log(uid);
      log(email);
      log(username);
      log(uid);
      await sharedPreferences.setString('email', email);
      headers.addAll(headers);
      var response = await http.post(Uri.parse('$data_address/resource'),
          headers: headers,
          body: {
            'name': username.toString(),
            'email': email,
            'status': 'gmail',
            'uid': uid
          });

      var res = jsonDecode(response.body.toString());
      log(response.body.toString());
      log(res['id'].toString());
      String userId = res['id'].toString();

      await sharedPreferences.setString('user_id', userId);
      log(userId);

      if (response.statusCode == 200) {
      } else {
        print(response.reasonPhrase);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kdarkblue,
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: kwhite,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            newpin_nuber
                                ? "Re Enter Pin Number."
                                : " Pin Number is wrong Try again",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height /
                                  6 *
                                  0.25),
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
                                      color: backspacecolorchange
                                          ? Colors.white60
                                          : kwhite),
                                  onPressed: () {
                                    controler_re_enter_pin.text =
                                        controler_re_enter_pin.text.substring(
                                            0,
                                            controler_re_enter_pin.text.length -
                                                1);
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PinKeyPad(
                                  keypad: '1',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;

                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}1';
                                    });
                                  }),
                              PinKeyPad(
                                  keypad: '2',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;

                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}2';
                                    });
                                  }),
                              PinKeyPad(
                                  keypad: '3',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;

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

                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}4';
                                    });
                                  }),
                              PinKeyPad(
                                  keypad: '5',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;

                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}5';
                                    });
                                  }),
                              PinKeyPad(
                                  keypad: '6',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;

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

                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}7';
                                    });
                                  }),
                              PinKeyPad(
                                  keypad: '8',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;

                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}8';
                                    });
                                  }),
                              PinKeyPad(
                                  keypad: '9',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;

                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}9';
                                    });
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(),
                              PinKeyPad(
                                  keypad: '0',
                                  click: () {
                                    setState(() {
                                      backspacecolorchange = false;

                                      controler_re_enter_pin.text =
                                          '${controler_re_enter_pin.text}0';
                                    });
                                  }),
                              const SizedBox(
                                width: 65,
                              ),
                              IconButton(
                                onPressed: () async {
                                  if (controler_re_enter_pin.text ==
                                      widget.controler_pin.text) {
                                    createFolder(controler_re_enter_pin.text);
                                    // register(getmytocken);
                                    await register();
                                  } else {
                                    setState(() {
                                      newpin_nuber = false;
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.white60,
                                  size: 45,
                                ),
                              ),
                              const SizedBox(
                                width: 34,
                              )
                            ],
                          ),
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

  Future<bool> createFolder(String folderName) async {
    try {
      directory = Directory(
          '/storage/emulated/0/Android/data/com.example.safe_encrypt/files');
      // checks if android
      if (Platform.isAndroid) {
        // request permission
        if (await requestPermission(Permission.storage)) {
          // getting the phone directory
          directory = await getExternalStorageDirectory();
          log(directory!.path);

          // creating the folder path

          List<String> folders = directory!.path.split("/");

          for (int i = 1; i < folders.length; i++) {
            String folder = folders[i];
            newPath += "/$folder";
          }

          newPath =
              "$newPath/safe/app/new/$folderName/Main Album"; // new directory

          directory = Directory(newPath);
          log(directory!.path);
        } else {
          return false;
        }
      } else {
        // if iOS
        log("dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");
        var status = await Permission.storage.status;

        // if iOS

        if (status.isGranted) {
          directory = await getApplicationSupportDirectory();

          // creating the folder path

          List<String> folders = directory!.path.split("/");

          for (int i = 1; i < folders.length; i++) {
            String folder = folders[i];
            newPath += "/$folder";
          }

          newPath = "$newPath/safe/app/new/$folderName/Main Album";
          // new directory

          directory = Directory(newPath);
          log(directory!.path);
        } else {
          return false;
        }
      }

      // creating the directory
      if (!await directory!.exists()) {
        await directory!.create(recursive: true);
        var response = await sqlDb.insertData(
            "INSERT INTO itempassword ('folderid','path','password','userpin','imagename','status','attempts') VALUES('$mainFolder','$newPath','null','${widget.controler_pin.text}','$assets','0','3')");
        print(response);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString(
            'foldername-$mainFolder-${widget.controler_pin.text}', assets);
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  GalleryHome(pinNumber: controler_re_enter_pin.text),
            ));
      }

      if (await directory!.exists().whenComplete(
        () async {
          AwesomeDialog(
              btnOkText: 'Continue',
              context: context,
              dialogType: DialogType.INFO,
              headerAnimationLoop: false,
              animType: AnimType.TOPSLIDE,
              showCloseIcon: true,
              closeIcon: const Icon(Icons.close_fullscreen_outlined),
              title: 'Oops! ',
              desc: 'you already have a Vault',
              btnOkOnPress: () async {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => GalleryHome(
                            pinNumber: controler_re_enter_pin.text)),
                    (Route<dynamic> route) => false);
                // await Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => GalleryHome(pinNumber: controler_re_enter_pin.text),
                //     ));
              }).show();
        },
      )) {}
    } catch (e) {
      log(e.toString());
    }
    return false;
  }
}
