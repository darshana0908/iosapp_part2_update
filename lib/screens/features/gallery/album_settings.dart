import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safe_encrypt/constants/colors.dart';
import 'package:safe_encrypt/db/sqldb.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'album_covers.dart';
import 'gallery_home.dart';

class AlbumSettings extends StatefulWidget {
  const AlbumSettings(
      {Key? key,
      required this.getbool,
      required this.PlatformPath,
      required this.getRenameFolderlist,
      required this.foldernames,
      required this.path,
      required this.pin,
      required this.isDelete})
      : super(key: key);
  final String PlatformPath;
  final String foldernames;
  final String path;
  final String pin;
  final bool isDelete;
  final Function getRenameFolderlist;
  final Function getbool;

  @override
  State<AlbumSettings> createState() => _AlbumSettingsState();
}

class _AlbumSettingsState extends State<AlbumSettings> {
  SqlDb sqlDb = SqlDb();
  String? newfoldername;
  String createfolder = '';
  String? imageName;
  String finalImage = '';
  String assets = 'assets/ic.JPG';
  bool islosding = false;
  bool uploadimgpath = false;
  final TextEditingController controler = TextEditingController();
  @override
  void initState() {
    log(widget.PlatformPath);
    final String foldernames;
    loadImage();

    log(imageName.toString());
    finalImage = imageName.toString();
    // TODO: implement initState
    super.initState();
  }

  loadImage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var imageName = sharedPreferences
        .getString('foldername-${widget.foldernames}-${widget.pin}');
    var coverimgpath = sharedPreferences.getBool(
      'foldername-${widget.foldernames}-${widget.pin}-bool',
    );
    if (coverimgpath == true) {
      setState(() {
        uploadimgpath = true;
      });
    } else {
      setState(() {
        uploadimgpath = false;
      });
    }
    setState(() {
      print('jjj');
      log(newfoldername.toString());
      finalImage = imageName.toString();
      createfolder = newfoldername.toString();
      islosding = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          widget.getRenameFolderlist();
        });

        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: kdarkblue,
          title: const Text('Album settings'),
          backgroundColor: kdarkblue,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'General',
                      style: TextStyle(color: kblue, fontSize: 20),
                    ),
                  ),
                  widget.isDelete
                      ? InkWell(
                          onTap: () {
                            showrenameFolderDialog(context);
                          },
                          child: Card(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                          color: kblack,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        widget.foldernames,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: kgray,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Card(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                        color: kblack,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.foldernames,
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: kgray,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Icon(
                                          Icons.lock,
                                          color: kgray,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 50,
                  ),
                  Divider(
                    color: kblack,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Album Cover',
                                  style: TextStyle(
                                      color: kblack,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Custom',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: kgray,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                width: 200,
                                height: 150,
                                child: islosding
                                    ? uploadimgpath
                                        ? Image.file(
                                            File(finalImage),
                                            fit: BoxFit.fill,
                                          )
                                        : Image.asset(finalImage,
                                            fit: BoxFit.fill)
                                    : const CupertinoActivityIndicator()),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AlbumCovers(
                                    platformePath: widget.PlatformPath,
                                    getbool: widget.getbool,
                                    updatefolderlist:
                                        widget.getRenameFolderlist,
                                    pin: widget.pin,
                                    path: widget.path,
                                    foldersname: widget.foldernames,
                                  )));
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: kblack,
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  showrenameFolderDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: double.infinity,
              height: 250,
              padding: const EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                    controller: controler,
                    decoration: const InputDecoration(hintText: 'Folder name')),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('CANCEL')),
                    TextButton(
                        onPressed: () async {
                          if (controler.text.length < 20 &&
                              controler.text.isNotEmpty) {
                            print(widget.foldernames);
                            setState(() {
                              var myfile = Directory(widget.path);
                              changeFileNameOnly(myfile, controler.text);
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Container(
                                  alignment: Alignment.center,
                                  height: 140,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'required folder name less',
                                        style: TextStyle(
                                          color: kred,
                                          fontSize: 24,
                                        ),
                                      ),
                                      Text(
                                        'of than 20 characters',
                                        style: TextStyle(
                                          color: kred,
                                          fontSize: 24,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          alignment: Alignment.center,
                                          height: 50,
                                          width: 100,
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.blue),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('UPDATE FOLDER')),
                  ],
                )
              ]),
            ),
          );
        });
  }

  Future changeFileNameOnly(myfile, newFileName) async {
    var path = myfile.path;

    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? oldKey = sharedPreferences
        .getString("foldername-${widget.foldernames}-${widget.pin}");
    log(path);
    var platformPath = "${widget.PlatformPath}${widget.pin}/$newFileName";
    log(platformPath);
    await sharedPreferences.setString(
        'foldername-$newFileName-${widget.pin}', oldKey.toString());
    var renamefolder = sqlDb.updateData(
        "UPDATE itempassword SET folderid ='$newFileName', path = '$platformPath' WHERE path ='$path';");
    print(renamefolder);
    setState(() {
      widget.getRenameFolderlist();
      log(imageName.toString());
      finalImage = imageName.toString();
      loadImage();
      log(imageName.toString());
      finalImage = imageName.toString();
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) => GalleryHome(
                  pinNumber: widget.pin,
                )),
        (Route<dynamic> route) => false).whenComplete(
      () {
        AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.SUCCES,
          showCloseIcon: true,
          title: 'Success',
          desc: '',
          btnOkText: 'Add Album',
          btnOkOnPress: () async {
            debugPrint('Continue');
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) async {
            debugPrint('Dialog Dismiss from callback $type');
          },
        ).show();
      },
    );

    setState(() {
      myfile.rename(newPath);
      loadImage();
    });
    // return
    await sharedPreferences.setString(
        'foldername-$newFileName-${widget.pin}', oldKey.toString());
    setState(() {
      loadImage();
    });
  }
}
