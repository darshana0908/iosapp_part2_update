import 'dart:async';
import 'dart:developer';

import 'dart:io';
import 'package:flash/flash.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_encrypt/constants/colors.dart';
import 'package:safe_encrypt/db/sqldb.dart';
import 'package:safe_encrypt/screens/features/gallery/nots/spacial_nots/spacial_notes_main.dart';
import 'package:safe_encrypt/services/icon.dart';
import 'package:safe_encrypt/utils/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/helper_methods.dart';
import '../settings/settings.dart';
import 'components/glalery_folder.dart';
import 'image_screen.dart';
import 'dart:convert';

class GalleryHome extends StatefulWidget {
  final String title = "Flutter Data Table";
  final bool isFake;

  final String pinNumber;
  const GalleryHome({Key? key, this.isFake = false, required this.pinNumber})
      : super(key: key);

  @override
  State<GalleryHome> createState() => _GalleryHomeState();
}

class _GalleryHomeState extends State<GalleryHome> with WidgetsBindingObserver {
  final TextEditingController _folderName = TextEditingController();
  final TextEditingController _controler = TextEditingController();

  Directory? directory;
  SqlDb sqlDb = SqlDb();
  String newPath = '';
  String oneEntity = '';
  String folderName = '';
  String platformPath = '';
  List<FileSystemEntity> folderList = [];
  Timer? timer;
  var jsonResponse = jsonDecode('{"data": []}') as Map<String, dynamic>;
  bool takingPhoto = false;
  String newpath = '';
  List<String> myfile = [];
  List<Map> myfolderlist = [];
  String? imageName;
  String finalImage = 'assets/ic.JPG';
  String assets = 'assets/ic.JPG';
  bool ownerlogin = true;
  bool isLoading = true;
  getbool() {
    setState(() {
      takingPhoto = true;
    });
  }

  getfolderlist() {
    setState(() {
      myfolderlist;
    });
    print('ggggaaaa');
  }

  gettitel() {
    setState(() {
      widget.title;
    });
  }

  @override
  void initState() {
    itemtlist();
    myfolderlist;
    MyPlatformePath();
    // takingPhoto == true ?
    WidgetsBinding.instance.addObserver(this);

    savebool();
    // : WidgetsBinding.instance.removeObserver(this);
    requestPermission(Permission.storage);
    takingPhoto = false;
    // getFolderList();

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    _folderName.dispose();

    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('$state  $takingPhoto');
    if (state == AppLifecycleState.resumed) {
      if (takingPhoto) {
        setState(() {
          takingPhoto = false;
        });
      } else {
        setState(() {
          takingPhoto = false;
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const AppIcon()),
            (Route<dynamic> route) => false);
      }
    }
  }

  @override
  savebool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ownerlogin', ownerlogin);
    print(ownerlogin);
  }

  updateFolderList() {
    print('kkkgggggggggggggggggggggddddddddddddddddddddd');
    setState(() {
      // getFolderList();
    });
  }

  String? imgload = '';
  String? faldername = '';
  bool enterpasward = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            color: kdarkblue,
            child: const SizedBox(
              height: 80,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: SpeedDial(
              buttonSize: const Size(70.0, 70.0),
              childrenButtonSize: const Size(55.0, 55.0),
              overlayColor: const Color(0xff00aeed),
              overlayOpacity: 0,
              activeIcon: Icons.close,
              foregroundColor: kwhite,
              activeForegroundColor: kblack,
              backgroundColor: kblue,
              activeBackgroundColor: kwhite,
              spacing: 20,
              spaceBetweenChildren: 15,
              icon: Icons.add,
              children: [
                SpeedDialChild(
                  child: Icon(Icons.add_to_photos_rounded,
                      color: kwhite, size: 30),
                  labelWidget: const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text('album',
                        style: TextStyle(
                            color: Colors.teal,
                            fontSize: 22,
                            fontWeight: FontWeight.w500)),
                  ),
                  elevation: 200,
                  backgroundColor: Colors.greenAccent,
                  onTap: () async => showCreateFolderDialog(context),
                ),
                SpeedDialChild(
                  child:
                      const Icon(Icons.note_alt, color: Colors.black, size: 30),
                  labelWidget: const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text('notes ',
                        style: TextStyle(
                            color: Colors.teal,
                            fontSize: 22,
                            fontWeight: FontWeight.w500)),
                  ),
                  elevation: 200,
                  backgroundColor: Colors.yellow,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SpacialNotesMain(
                                pin: widget.pinNumber,
                                getbool: getbool,
                              )),
                    );
                  },
                )
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: kdarkblue,
            title: const Text('Keepsafe'),
            // backgroundColor: kdarkblue,
            actions: <Widget>[
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: TextButton(
                              autofocus: true,
                              child: Text('Settings',
                                  style:
                                      TextStyle(color: kblack, fontSize: 17)),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Settings())),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: TextButton(
                              autofocus: true,
                              child: Text('Help',
                                  style:
                                      TextStyle(color: kblack, fontSize: 17)),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          drawer: CustomDrawer(
            pinNumber: widget.pinNumber,
            takinphoto: takingPhoto,
            getbool: getbool,
          ),
          body: GridView.builder(
              // itemCount: myfolderlist.length,
              itemCount: myfolderlist.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0),
              itemBuilder: (BuildContext context, index) {
                // oneEntity = folderList[index].toString();
                // folderName = oneEntity.split('/').last.replaceAll("'", '');
                return InkWell(
                    child: PlatformAlbum(
                      getbool: getbool,
                      // selected image of folder cover
                      // use provider (FolderCoverImageProvider)
                      PlatformPath: platformPath,
                      password: myfolderlist[index]['password'].toString(),
                      // myfolderlist: getFolderList,
                      getRenameFolderlist: updateFolderList,
                      title: myfolderlist[index]['folderid'].toString(),
                      album: 'Album Settings',
                      isDelete: index == 0 ? false : true,
                      path: myfolderlist[index]['path'].toString(),
                      pinnuber: myfolderlist[index]['userpin'].toString(),
                    ),
                    onTap: () {
                      log(myfolderlist[index]['path'].toString());
                      log(myfolderlist[index]['password'].toString());

                      if (myfolderlist[index]['password'] == 'null') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImageScreen(
                              pin: myfolderlist[index]['userpin'].toString(),
                              getbool: getbool,
                              title: myfolderlist[index]['folderid'].toString(),
                              path: myfolderlist[index]['path'],
                            ),
                          ),
                        );
                      } else {
                        var titlepath =
                            myfolderlist[index]['password'].toString();
                        create_pasward_dialog(index, titlepath);
                      }
                    });
              }),
        ),
      ),
    );

    // );  ),
  }

  // create folder dialog
  showCreateFolderDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: double.infinity,
              height: 270,
              padding: const EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                    maxLength: 30,
                    controller: _folderName,
                    decoration: const InputDecoration(hintText: 'Folder name')),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color.fromARGB(255, 89, 179, 92)),
                            alignment: Alignment.center,
                            child: Text(
                              'CANCEL',
                              style: TextStyle(color: kwhite),
                            ))),
                    TextButton(
                        onPressed: () async {
                          if (_folderName.text.length < 30) {
                            setState(() {
                              createFolder(_folderName.text);

                              _folderName.clear();
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: "required 30 characters",
                                // toastLength:Toast.LENGTH_SHORT ,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.redAccent,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                          // await getFolderList();
                        },
                        child: Container(
                            height: 40,
                            width: 130,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kliteblue),
                            child: Text(
                              'CREATE',
                              style: TextStyle(color: kwhite),
                            ))),
                  ],
                )
              ]),
            ),
          );
        });
  }

  itemtlist() async {
    myfolderlist = await sqlDb.readData(
        'SELECT  * FROM itempassword WHERE userpin = ${widget.pinNumber}');
    log(myfolderlist.toString());
    // log(myfolderlist[1]['folder-id'].toString());
    setState(() {
      myfolderlist;
    });
  }

  // load app folders
  // getFolderList() async {
  //   final Directory directoryi = Directory('/storage/emulated/0/Android/data/com.example.safe_encrypt/files/safe/app/new/${widget.pinNumber}');

  //   log(directoryi.toString());

  //   folderList = directoryi.listSync(followLinks: true);
  //   folderList.removeWhere((item) => item.runtimeType.toString() == '_File');
  //   setState(() {
  //     log(imageName.toString());
  //     finalImage = imageName.toString();
  //     folderList;
  //   });
  // }

  MyPlatformePath() async {
    if (Platform.isAndroid) {
      setState(() {
        directory = Directory(
            '/storage/emulated/0/Android/data/com.example.safe_encrypt/files/safe/app/new/${widget.pinNumber}');
        platformPath =
            '/storage/emulated/0/Android/data/com.example.safe_encrypt/files/safe/app/new/';
      });
    } else {
      var ios = await getApplicationSupportDirectory();
      log(ios.path);
      var myiospath = ios.path;
      setState(() {
        platformPath = '$myiospath/safe/app/new/';
        directory = Directory("$myiospath/safe/app/new/${widget.pinNumber}");
      });
    }
  }

  // creating folders
  Future<bool> createFolder(String newFolderName) async {
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
              "$newPath/safe/app/new/${widget.pinNumber}/$newFolderName"; // new directory

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

          newPath = "$newPath/safe/app/new/${widget.pinNumber}/$newFolderName";
          // new directory

          directory = Directory(newPath);
          log(directory!.path);
        } else {
          return false;
        }
      }
      // if (!await directory.exists()) {

      // }
      if (!await directory!.exists()) {
        log(directory.toString());
        await directory!.create(recursive: true);
        var response = await sqlDb.insertData(
            "INSERT INTO itempassword ('folderid','path','password','userpin','imagename','status','attempts') VALUES('$newFolderName','$newPath','null','${widget.pinNumber}','$assets','1','3')");
        print(response);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString(
            'foldername-$newFolderName-${widget.pinNumber}', assets);
        // getFolderList();
        setState(() {
          itemtlist();
          myfolderlist;
        });

        AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.SUCCES,
          showCloseIcon: true,
          title: 'Success',
          desc: '',
          btnOkOnPress: () async {
            debugPrint('Continue');

            setState(() {
              requestPermission(Permission.storage);

              Navigator.pop(context, true);
            });
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) async {
            debugPrint('Dialog Dismiss from callback $type');
          },
        ).show();
        print(response);
        print('j');
        return true;
      } else {
        AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.warning,
          showCloseIcon: true,
          title: "Oops!",
          desc: 'folder already exists',
          btnOkColor: Colors.redAccent,
          btnOkOnPress: () async {
            debugPrint('Continue');

            setState(() {
              requestPermission(Permission.storage);

              Navigator.pop(context, true);
            });
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) async {
            debugPrint('Dialog Dismiss from callback $type');
          },
        ).show();
        return false;
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  String getFolderPath() {
    return '/storage/emulated/0/Android/data/com.example.safe_encrypt/files/safe/app/new/${widget.pinNumber}/';
  }

// Cam-IMG 1664964306767412.jpg
  void delete(String path) {
    takingPhoto = false;

    final dir = Directory(path);
    dir.deleteSync(recursive: true);
  }

  Future<void> create_pasward_dialog(index, titelpath) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // backgroundColor: kdarkblue,
          // title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Column(
                children: [
                  const Text('Enter PassWord'),
                  TextField(
                    textAlign: TextAlign.center,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    controller: _controler,
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
                      child: Text('confirm',
                          style: TextStyle(
                              color: kwhite,
                              fontSize: 21,
                              fontWeight: FontWeight.w500)),
                    ),
                    onPressed: () async {
                      log(myfolderlist[index]['password'].toString());

                      print(widget.title);
                      if (myfolderlist[index]['password'].toString() ==
                          _controler.text) {
                        var response = await sqlDb.updateData(
                            "UPDATE itempassword SET Status ='1' WHERE path ='${myfolderlist[index]['path'].toString()}';");
                        setState(() {
                          itemtlist();
                          myfolderlist;
                        });
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImageScreen(
                              pin: myfolderlist[index]['userpin'].toString(),
                              getbool: getbool,
                              title: myfolderlist[index]['folderid'].toString(),
                              path: myfolderlist[index]['path'],
                            ),
                          ),
                        );

                        print('ddddddddddddddddddddd');
                        _controler.clear();
                      } else {
                        if (_controler.text.isNotEmpty) {
                          if (myfolderlist[index]['status'].toString() !=
                                  myfolderlist[index]['attempts'].toString() &&
                              myfolderlist[index]['status'].toString() == '1') {
                            String msg =
                                "you have entered  wrong password 1 time";
                            _showMessage(msg);
                            var response = await sqlDb.updateData(
                                "UPDATE itempassword SET Status ='2' WHERE path ='${myfolderlist[index]['path'].toString()}';");
                            setState(() {
                              itemtlist();
                              myfolderlist;
                              _controler.clear();
                            });
                          } else if (myfolderlist[index]['status'].toString() ==
                              myfolderlist[index]['attempts'].toString()) {
                            String msg =
                                "Warning ! you have entered wrong password many times .\nthis folder will be deleted";
                            _showMessage(msg);
                            var path = myfolderlist[index]['path'].toString();
                            foldetdelete(path);
                            _controler.clear();
                          }
                          if (myfolderlist[index]['status'].toString() !=
                                  myfolderlist[index]['attempts'].toString() &&
                              myfolderlist[index]['status'].toString() == '2') {
                            String msg =
                                "you have entered  wrong password 2 time";
                            _showMessage(msg);
                            setState(() {
                              itemtlist();
                              myfolderlist;
                              _controler.clear();
                            });

                            var response = await sqlDb.updateData(
                                "UPDATE itempassword SET Status ='3' WHERE path ='${myfolderlist[index]['path'].toString()}';");
                          } else if (myfolderlist[index]['status'].toString() ==
                              myfolderlist[index]['attempts'].toString()) {
                            String msg =
                                "Warning ! you have entered wrong password many times .\nthis folder will be deleted";
                            _showMessage(msg);
                            var path = myfolderlist[index]['path'].toString();
                            foldetdelete(path);
                            _controler.clear();
                          }
                          if (myfolderlist[index]['status'].toString() !=
                                  myfolderlist[index]['attempts'].toString() &&
                              myfolderlist[index]['status'].toString() == '3') {
                            String msg =
                                "you have entered  wrong password 3 time";
                            _showMessage(msg);
                            setState(() {
                              itemtlist();
                              myfolderlist;
                              _controler.clear();
                            });
                            var response = await sqlDb.updateData(
                                "UPDATE itempassword SET Status ='4' WHERE path ='${myfolderlist[index]['path'].toString()}';");
                          } else if (myfolderlist[index]['status'].toString() ==
                              myfolderlist[index]['attempts'].toString()) {
                            String msg =
                                "Warning ! you have entered wrong password many times .\nthis folder will be deleted";
                            _showMessage(msg);
                            var path = myfolderlist[index]['path'].toString();
                            foldetdelete(path);
                            _controler.clear();
                          }
                          if (myfolderlist[index]['status'].toString() !=
                                  myfolderlist[index]['attempts'].toString() &&
                              myfolderlist[index]['status'].toString() == '4') {
                            String msg =
                                "you have entered  wrong password 4 time";
                            _showMessage(msg);
                            setState(() {
                              itemtlist();
                              myfolderlist;
                              _controler.clear();
                            });
                            var response = await sqlDb.updateData(
                                "UPDATE itempassword SET Status ='5' WHERE path ='${myfolderlist[index]['path'].toString()}';");
                          } else if (myfolderlist[index]['status'].toString() ==
                              myfolderlist[index]['attempts'].toString()) {
                            String msg =
                                "Warning ! you have entered wrong password many times .\nthis folder will be deleted";
                            _showMessage(msg);
                            var path = myfolderlist[index]['path'].toString();
                            foldetdelete(path);
                            _controler.clear();
                          }
                          if (myfolderlist[index]['status'].toString() !=
                                  myfolderlist[index]['attempts'].toString() &&
                              myfolderlist[index]['status'].toString() == '5') {
                            String msg =
                                "you have entered  wrong password 5 time";
                            _showMessage(msg);
                            setState(() {
                              itemtlist();
                              myfolderlist;
                              _controler.clear();
                            });
                          } else if (myfolderlist[index]['status'].toString() ==
                              myfolderlist[index]['attempts'].toString()) {
                            String msg =
                                "Warning ! you have entered wrong password many times .\nthis folder will be deleted";
                            _showMessage(msg);
                            var path = myfolderlist[index]['path'].toString();
                            foldetdelete(path);
                            _controler.clear();
                          }
                        } else {
                          String msg = "Please enter valid password";
                          _showMessage(msg);
                        }
                      }
                      print('gggg');
                      print(myfolderlist[index]['path'].toString());

                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ],
          )),
        );
      },
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    showFlash(
        context: context,
        duration: const Duration(seconds: 10),
        builder: (_, controller) {
          return Flash(
            controller: controller,
            position: FlashPosition.top,
            behavior: FlashBehavior.fixed,
            child: FlashBar(
              icon: const Icon(
                Icons.lock_clock_outlined,
                size: 36.0,
                color: Colors.black,
              ),
              content: Text(message),
              primaryAction: TextButton(
                onPressed: () => controller.dismiss(),
                child: const Text('DISMISS',
                    style: TextStyle(color: Colors.amber)),
              ),
            ),
          );
        });
  }

  void foldetdelete(String path) async {
    var deletepath =
        await sqlDb.deleteData('DELETE FROM itempassword WHERE path ="$path"');
    print(deletepath);
    setState(() {
      itemtlist();
      myfolderlist;

      final dir = Directory(path);
      dir.deleteSync(recursive: true);
    });
  }
}
