import 'dart:developer';

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_encrypt/db/sqldb.dart';
import 'package:safe_encrypt/screens/features/gallery/album_settings.dart';
import 'package:safe_encrypt/screens/features/gallery/gallery_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants/colors.dart';

class PlatformAlbum extends StatefulWidget {
  final String title;
  final bool isDelete;
  final String path;
  final String album;
  final Function getRenameFolderlist;
  final String pinnuber;
  final String PlatformPath;
  final Function getbool;
  final String password;

  const PlatformAlbum({
    Key? key,
    required this.password,
    required this.PlatformPath,
    required this.getbool,
    required this.getRenameFolderlist,
    required this.title,
    required this.isDelete,
    required this.path,
    required this.album,
    required this.pinnuber,
  }) : super(key: key);

  @override
  State<PlatformAlbum> createState() => _PlatformAlbumState();
}

class _PlatformAlbumState extends State<PlatformAlbum> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  SqlDb sqlDb = SqlDb();
  String? imageName;
  String finalImage = '';
  String? assetsName;
  String finalAssets = '';
  bool enterpass = false;
  bool enteratemps = true;
  bool isImageLoading = true;
  bool folderPassword = false;
  bool passwordCharacters = false;
  List<Map> myfolderlist = [];
  int attempt = 0;
  String coverimg = '';
  bool uploadimgpath = false;
  var coverimgpath;

  String selectedValue = '';

  @override
  void initState() {
    uploadimgbool();
    print(widget.password);
    widget.title;
    loadImage();
    setState(() {});

    // loadImage();
    // TODO: implement initState
    super.initState();
  }

  uploadimgbool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  gettitel() {
    setState(() {
      widget.title;
    });
  }

  loadImage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    coverimgpath = sharedPreferences.getBool(
      'foldername-${widget.title}-${widget.pinnuber}-bool',
    );

    var imageName = sharedPreferences
        .getString('foldername-${widget.title}-${widget.pinnuber}');
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
      finalImage = imageName.toString();
      log(finalImage);
      print('ggggggggggggggggg');
      print(coverimgpath);
      log(coverimgpath.toString());
      isImageLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Container(
          // color: kwhite,
          width: MediaQuery.of(context).size.width / 2 - 16,
          height: 230,
          decoration: const BoxDecoration(),
          child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 2 - 16,
                  height: 180,
                  color: kindigo,
                  child: isImageLoading
                      ? const CupertinoActivityIndicator()
                      : uploadimgpath
                          ? Image.file(
                              File(finalImage),
                              fit: BoxFit.fill,
                            )
                          : Image.asset(finalImage, fit: BoxFit.fill)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    PopupMenuButton(
                      position: PopupMenuPosition.under,
                      splashRadius: 20,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Column(
                              children: [
                                Visibility(
                                  visible: widget.isDelete,
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    child: TextButton(
                                        style: const ButtonStyle(),
                                        autofocus: true,
                                        child: const Text('Delete',
                                            style: TextStyle(fontSize: 17)),
                                        onPressed: () {
                                          // setState(() {
                                          //   delete(widget.path);
                                          // });
                                          AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.WARNING,
                                              headerAnimationLoop: false,
                                              animType: AnimType.TOPSLIDE,
                                              showCloseIcon: true,
                                              closeIcon: const Icon(Icons
                                                  .close_fullscreen_outlined),
                                              title: 'Warning',
                                              desc:
                                                  'Are you sure want to delete folder',
                                              btnCancelOnPress: () {},
                                              onDismissCallback: (type) {
                                                debugPrint(
                                                    'Dialog Dissmiss from callback $type');
                                              },
                                              btnOkOnPress: () async {
                                                String key = '';
                                                setState(() {
                                                  finalImage =
                                                      imageName.toString();
                                                  delete(widget.path);
                                                  print(widget.pinnuber);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              GalleryHome(
                                                                pinNumber: widget
                                                                    .pinnuber,
                                                              )));
                                                });
                                              }).show();

                                          // showcoAlertDialog(context, widget.path);
                                        }),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: TextButton(
                                    autofocus: true,
                                    child: Text(
                                      widget.album,
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                    onPressed: () async {
                                      bool result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => AlbumSettings(
                                                    getbool: widget.getbool,
                                                    PlatformPath:
                                                        widget.PlatformPath,
                                                    getRenameFolderlist: widget
                                                        .getRenameFolderlist,
                                                    foldernames: widget.title,
                                                    path: widget.path,
                                                    pin: widget.pinnuber,
                                                    isDelete: widget.isDelete,
                                                  )));
                                      if (result) loadImage();
                                    },
                                  ),
                                ),

                                // check if have password
                                if (widget.password == 'null')
                                  Visibility(
                                    visible: widget.isDelete,
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: TextButton(
                                        child: const Text(
                                          'Create pasward',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        onPressed: () async {
                                          await create_pasward_dialog();
                                          await Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => GalleryHome(
                                                        pinNumber:
                                                            widget.pinnuber,
                                                      )),
                                              (Route<dynamic> route) => false);
                                        },
                                      ),
                                    ),
                                  )
                                else
                                  Container()
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> create_pasward_dialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: kdarkblue,

            // backgroundColor: kdarkblue,
            // title: const Text('AlertDialog Title'),
            content: SizedBox(
              height: 450,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: kwhite,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Create new pin",
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                      Form(
                        autovalidateMode: AutovalidateMode.always,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: _controller,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: kwhite, fontSize: 21),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter pin';
                            }
                            if (value != 4) {
                              return 'require 4 characters';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              hintText: 'enter pin ',
                              hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500),
                              label: Text('pin number',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w500))),
                        ),
                      ),
                      Form(
                        autovalidateMode: AutovalidateMode.always,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: _controller1,
                          maxLength: 4,

                          keyboardType: TextInputType.number,
                          style: TextStyle(color: kwhite, fontSize: 21),
                          // controller: emailControler,

                          decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 're enter pin',
                              hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500),
                              label: Text('re enter pin number',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w500))),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('number of attempts',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 21,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                attempt = 1;
                                enteratemps = !enteratemps;
                              });
                              print('11111');
                            },
                            child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: attempt == 1 ? kliteblue : kgray),
                                child: Text('1',
                                    style: TextStyle(
                                        color: kblack,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500))),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                attempt = 2;
                                enteratemps = false;
                              });
                              print('22222');
                            },
                            child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: attempt == 2 ? kliteblue : kgray),
                                child: Text('2',
                                    style: TextStyle(
                                        color: kblack,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500))),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                attempt = 3;
                                enteratemps = !enteratemps;
                              });
                              print('333333');
                            },
                            child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: attempt == 3 ? kliteblue : kgray),
                                child: Text('3',
                                    style: TextStyle(
                                        color: kblack,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500))),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                attempt = 4;
                                enteratemps = !enteratemps;
                              });
                              print('4444');
                            },
                            child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: attempt == 4 ? kliteblue : kgray),
                                child: Text('4',
                                    style: TextStyle(
                                        color: kblack,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500))),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                attempt = 5;
                                enteratemps = !enteratemps;
                              });
                              print('5555555');
                            },
                            child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: attempt == 5 ? kliteblue : kgray),
                                child: Text('5',
                                    style: TextStyle(
                                        color: kblack,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500))),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextButton(
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 300,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: kliteblue),
                          child: Text('Save',
                              style: TextStyle(
                                  color: kwhite,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500)),
                        ),
                        onPressed: () async {
                          int x = 5;

                          if (_controller.text.isNotEmpty &&
                              _controller.text.length == 4) {
                            if (_controller.text == _controller1.text) {
                              if (attempt > 0) {
                                String path = '';
                                var response = await sqlDb.updateData(
                                    "UPDATE itempassword SET password ='${_controller.text}',attempts = '$attempt'  WHERE path ='${widget.path}';");

                                // widget.myfolderlist();

                                Navigator.pop(context);
                                setState(() {
                                  folderPassword = true;
                                });
                                print('jjj');
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Select number of attempts",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.lightGreen,
                                    textColor: Colors.white,
                                    fontSize: 16.0);

                                print('hhhhh');
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "check  re enter pin number",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.lightGreen,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              print('ggggg');
                            }
                          } else {
                            print('gggggfff');
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  // itemtlist() async {
  //   myfolderlist = await sqlDb.readData('SELECT  * FROM itempassword WHERE userpin = ${widget.pinnuber}');
  //   log(myfolderlist.toString());
  //   // log(myfolderlist[1]['folder-id'].toString());
  //   setState(() {
  //     myfolderlist;
  //   });
  // }

  Future changeFileNameOnly(File file, String newFileName) {
    var path = widget.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);
  }

  void delete(String path) async {
    var deletepath = await sqlDb
        .deleteData('DELETE FROM itempassword WHERE path ="${widget.path}"');
    print(deletepath);
    setState(() {
      final dir = Directory(path);
      dir.deleteSync(recursive: true);
    });
  }
}
