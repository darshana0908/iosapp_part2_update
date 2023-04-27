import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../screens/features/auth/components/pin_number/first_pin_number.dart';
import '../../services/icon.dart';
import 'package:path/path.dart' as path;

class CustomDrawer extends StatefulWidget {
  final String pinNumber;
  final bool takinphoto;
  final Function getbool;
  const CustomDrawer(
      {Key? key,
      required this.pinNumber,
      required this.takinphoto,
      required this.getbool})
      : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? imageName;

  bool isloding = false;
  String finalImage = '';

  String assetPath = 'assets/ic.JPG';
  int? i;
  // File? finalImage = null;

  @override
  void initState() {
    loadImage();

    super.initState();
  }

  loadImage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var imageName =
        sharedPreferences.getString('profileImage-${widget.pinNumber}');

    setState(() {
      finalImage = imageName.toString();
      log(finalImage);
      isloding = true;
    });
  }

  bool app = true;
  @override
  Widget build(BuildContext context) {
    var listTile = ListTile(
      leading: const Icon(Icons.person),
      title: const Text(' My Vault '),
      onTap: () {
        Navigator.pop(context);
      },
    );
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.darken, color: kindigo),
              //BoxDecoration
              child: InkWell(
                onTap: () {
                  uploadPhoto();
                  setState(() {
                    widget.getbool();
                    print(widget.getbool());
                  });
                },
                child: Center(
                  child: Stack(
                    children: [
                      if (finalImage.isNotEmpty)
                        CircleAvatar(
                            foregroundImage:
                                FileImage(File(finalImage.toString())),
                            radius: 80)
                      else
                        isloding
                            ? const CupertinoActivityIndicator()
                            : CircleAvatar(backgroundColor: kblack, radius: 80),
                      const Positioned(
                          bottom: 20,
                          right: 20,
                          child: Icon(Icons.camera_alt,
                              size: 28, color: Colors.deepPurple)),
                    ],
                  ),
                ),
              )),
          listTile,
          ListTile(
            leading: const Icon(Icons.create),
            title: const Text(' Create New Vault'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FirstPinNumber()),
              );
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstPinNumber()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text(' New Vault Login'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AppIcon()),
                  (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Quit'),
            onTap: () => exit(0),
          ),
        ],
      ),
    );
  }

  uploadPhoto() async {
    final ImagePicker picker = ImagePicker();

    String fileType;
    String imgName;
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (Platform.isAndroid) {
        print('cccccccccccccccccccccccccccccccccccccccccccccccccccccc');
        String imgPath =
            '/storage/emulated/0/Android/data/com.example.safe_encrypt/files/safe/app/new/';
        fileType = path.extension(image.path);

        imgName = "Cam-IMG ${DateTime.now()}$fileType";
        File fileToSave = File(image.path);
        fileToSave.copy('$imgPath${widget.pinNumber}/$imgName');

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('profileImage-${widget.pinNumber}',
            '$imgPath${widget.pinNumber}/$imgName');

        // var value = sharedPreferences.getString('profileImage-${widget.pinNumber}');
        // log(value.toString());
        setState(() {
          log(imageName.toString());
          finalImage = '$imgPath${widget.pinNumber}/$imgName';
        });
        print(imageName);
      } else {
        // if ios

        var directory = await getApplicationSupportDirectory();

        var iospath = directory.path;
        log(iospath);

        fileType = path.extension(image.path);

        imgName = "Cam-IMG ${DateTime.now()}$fileType";
        File fileToSave = File(image.path);
        log('$iospath/safe/app/new/${widget.pinNumber}/$imgName');
        var iosimg = '$iospath/safe/app/new/${widget.pinNumber}/$imgName';
        fileToSave.copy('$iosimg');

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString(
            'profileImage-${widget.pinNumber}', '$iosimg');

        // var value = sharedPreferences.getString('profileImage-${widget.pinNumber}');
        // log(value.toString());
        setState(() {
          log(imageName.toString());
          finalImage = '$iosimg';
        });
        print(imageName);
      }
    }
  }

  void delete(String path) {
    final Dir = Directory(path);

    Dir.deleteSync(recursive: true);
    log(imageName.toString());
  }
}
