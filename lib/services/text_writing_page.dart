// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:io';

import 'package:file_cryptor/file_cryptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:safe_encrypt/constants/colors.dart';
import 'package:safe_encrypt/db/sqldb.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import '../class/lcl_notification.dart';

class TxtWritingPage extends StatefulWidget {
  const TxtWritingPage(
      {Key? key,
      required this.pageload,
      required this.title,
      required this.pin,
      required this.loading,
      required this.path})
      : super(key: key);
  final String path;
  final Function loading;
  final String pin;
  final String title;
  final Function pageload;

  @override
  State<TxtWritingPage> createState() => _TxtWritingPageState();
}

// QuillController _controller = QuillController.basic();
// var json = jsonEncode();
String incomingJSONText = '';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final local = tz.initializeTimeZones();
DateTime selectedDate = DateTime.now();
TextEditingController controler = TextEditingController(text: 'Note name');
TextEditingController controler1 = TextEditingController(text: 'Type hear');
bool filesave = false;
bool savebutton = false;
bool remainderbutton = false;
SqlDb sqlDb = SqlDb();
String filePath = '';
String textFileName = '';
int? response;
String nullDate = '';
const data = {'text': 'foo', 'value': 2, 'status': false, 'extra': null};
var hh = 'vvffddddddd' as int;
var myJSON = [hh];
int _currentIntValue = 0;
int _currentHorizontalIntValue = 0;
int? remainderDate;
// QuillController _controller = QuillController.basic();

class _TxtWritingPageState extends State<TxtWritingPage> {
  @override
  void initState() {
    setState(() {
      controler.text;
    });

    // _controller.addListener(() {
    //   'fffff';
    //   print('Here I am, rock me like a hurricane!!!');
    // });
    filesave = false;
    NotificationApi.init();
    listenNotification();
    tz.initializeTimeZones();
    var locations = tz.timeZoneDatabase.locations;
    print(locations.length); // => 429
    print(locations.keys.first); // => "Africa/Abidjan"
    print(locations.keys.last);
    print(widget.loading);

    // Noti.initialize(flutterLocalNotificationsPlugin);
    // TODO: implement initState
    super.initState();
    var fToast = FToast();
    var fToast2 = fToast;
    fToast2.init(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  showdialog() {
    setState(() {
      _showMyDialog;
    });
  }

  loadd() {
    setState(() {
      print('saan');
      widget.loading();
    });
  }

  void listenNotification() {
    NotificationApi.onNotifications.stream.listen(onclickedNotification);
  }

  void onclickedNotification(String? paylod) {
    print('jjjjjjjjjjjjjj');
  }

  remainderdb() async {}

  bool takingPhoto = false;
  getbool() {
    setState(() {
      takingPhoto = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          setState(() {
            // savebutton = false;
            // await widget.loading();
            widget.pageload();
            Navigator.pop(context);
          });

          // Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          backgroundColor: kwhite,
          floatingActionButton: filesave
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    _showMyDialog();
                  },
                )
              : null,
          appBar: AppBar(
            title: const Text('create notes'),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  // savebutton = false;
                  // await widget.loading();
                  widget.pageload();
                  Navigator.pop(context);
                });
              },
              icon: const Icon(Icons.arrow_back),
            ),
            backgroundColor: kdarkblue,
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35), color: kwhite),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: kwhite),
                      child: Card(
                        color: kwhite,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: const InputDecoration(),
                            controller: controler1,
                            maxLines: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  savefiledialog();
                  setState(() {
                    savebutton = false;
                    controler.clear();
                    remainderDate = 0;
                    remainderbutton = false;
                  });
                },
                child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 2, 235, 123),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'Save',
                      style: TextStyle(color: kwhite, fontSize: 21),
                    )),
              ),
            ]),
          ),
        ));
  }

  Future<void> savefiledialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            // backgroundColor: kdarkblue,
            // title: const Text('AlertDialog Title'),
            content: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Title',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                ),
                TextField(
                  controller: controler,
                  maxLength: 30,
                  maxLines: 2,
                  readOnly: savebutton ? true : false,
                  decoration: InputDecoration(
                    hintText: "Type hear",
                    suffixIcon: savebutton
                        ? const Icon(
                            Icons.check_outlined,
                            color: Color.fromARGB(255, 5, 197, 104),
                            size: 26,
                          )
                        : TextButton(
                            child: Container(
                                alignment: Alignment.center,
                                width: 60,
                                height: 40,
                                color: kliteblue,
                                child: Text(
                                  'Add',
                                  style: TextStyle(color: kwhite),
                                )),
                            onPressed: () async {
                              if (controler.text.isNotEmpty) {
                                if (controler.text.length < 30) {
                                  response = await sqlDb.insertData(
                                      "INSERT INTO notes ('pin','folder','text','dtime','path','imgname','textvalue') VALUES('${widget.pin}','${widget.title}','null','null','${widget.path}','${controler.text}','${controler1.text}')");

                                  List<Map> responsea = await sqlDb
                                      .readData("SELECT * FROM  'notes' ");
                                  print(responsea);
                                  setState(() {
                                    savebutton = true;
                                    filesave = true;
                                  });
                                  Fluttertoast.showToast(
                                      msg: " (${controler.text}) Title Saved",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.lightGreen,
                                      textColor: Colors.white,
                                      fontSize: 16.0);

                                  // setState(() {
                                  //   // Navigator.pop(context);
                                  //   controler.clear();
                                  //   controler1.clear();
                                  // });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: " Required less than 30 characters",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Text File Name Required",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                          ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                  width: 350,
                ),
                savebutton
                    ? Column(
                        children: [
                          Text(
                            'Set Remainder',
                            style: TextStyle(
                                color: kblack,
                                fontSize: 21,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 16),
                          NumberPicker(
                            value: _currentHorizontalIntValue,
                            minValue: 0,
                            maxValue: 100,
                            step: 1,
                            itemHeight: 100,
                            axis: Axis.horizontal,
                            onChanged: (value) {
                              setState(() {
                                _currentHorizontalIntValue = value;
                              });
                            },
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.black26),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Container(
                                  color:
                                      const Color.fromARGB(255, 15, 224, 123),
                                  width: 70,
                                  height: 40,
                                  child: Icon(
                                    Icons.remove,
                                    color: kwhite,
                                    size: 27,
                                  ),
                                ),
                                onPressed: () => setState(() {
                                  final newValue =
                                      _currentHorizontalIntValue - 1;
                                  _currentHorizontalIntValue =
                                      newValue.clamp(0, 100);
                                  remainderDate = _currentHorizontalIntValue;
                                  print(sheduleDate);
                                  // print(_currentHorizontalIntValue);
                                }),
                              ),
                              Text(
                                  'Current Remainder days: $_currentHorizontalIntValue',
                                  style: TextStyle(color: kblack)),
                              IconButton(
                                icon: Container(
                                  color:
                                      const Color.fromARGB(255, 15, 224, 123),
                                  width: 70,
                                  height: 40,
                                  child: Icon(
                                    Icons.add,
                                    color: kwhite,
                                    size: 27,
                                  ),
                                ),
                                onPressed: () => setState(() {
                                  final newValue =
                                      _currentHorizontalIntValue + 1;
                                  _currentHorizontalIntValue =
                                      newValue.clamp(0, 100);
                                  remainderDate = _currentHorizontalIntValue;
                                  print(remainderDate);
                                  // print(_currentHorizontalIntValue.toString());
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 200,
                            height: 50,
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 50,
                ),
                savebutton
                    ? TextButton(
                        onPressed: () async {
                          if (remainderDate != 0) {
                            print(controler.text);
                            print(widget.pin);
                            print(widget.title);
                            log(filePath.toString());
                            print('ddddddd');
                            var updateResponse = sqlDb.updateData(
                                "UPDATE notes SET dtime = '$remainderDate' WHERE id = '$response'  ");
                            setState(() {
                              filesave = false;
                            });
                            pickdate = pickdate;
                            print(updateResponse);
                            print('hhhhhhhhhhhh');
                            print(response);
                            print(remainderDate);
                            // print(updateResponse);
                            // int response = await sqlDb.insertData(
                            //     "INSERT INTO notes ('pin','folder','text','dtime') VALUES('${widget.pin}','${widget.title}','$textFileName','$pickdate')");
                            // print(response);
                            NotificationApi.showScheduleNotification(
                              id: response!,
                              foldername: widget.title,
                              pin: widget.pin,
                              textname: controler.text,
                              title: 'Reminder!',
                              body:
                                  'Open the saved file ( filename ${controler.text})',
                              payload: 'lllll',
                              scheduledDate: remainderDate!,
                            );
                            setState(() {
                              loadd();
                              _currentHorizontalIntValue = 0;
                            });
                            Navigator.pop(context);
                            // await Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => ImageScreen(
                            //       title: widget.title,
                            //       // imgpath: widget.path,
                            //       getbool: widget.loading,
                            //       pin: widget.pin,
                            //       path: widget.path,
                            //     ),
                            //   ),
                            // );
                            // (Route<dynamic> route) => false);
                          } else {
                            Navigator.pop(context);
                            // await Navigator.pushAndRemoveUntil(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (_) => ImageScreen(
                            //         title: widget.title,
                            //         // imgpath: widget.path,
                            //         getbool: widget.loading,
                            //         pin: widget.pin,
                            //         path: widget.path,
                            //       ),
                            //     ),
                            //     (Route<dynamic> route) => true);
                          }

                          // Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstPinNumber()));
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: kliteblue,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Save',
                              style: TextStyle(color: kwhite, fontSize: 19),
                            )),
                      )
                    : Container()
              ],
            )),
          );
        });
      },
    );
  }

  // _write(String text) async {
  //   String filetype = '.txt';
  //   Directory? directory = Directory(widget.path);

  //   String textt = controler.text;
  //   log(textt);

  //   textFileName = "${controler.text}$filetype";

  //   final File file = File('${directory.path}/$textFileName');
  //   await file.writeAsString(text);
  //   filePath = file.toString();
  //   log(filePath.toString());
  //   var newpath = '${directory.path}/$textFileName';
  //   await encryptFiles(textFileName, '$textFileName.aes', directory.path);
  //   delete('${directory.path}/$textFileName');
  //   log(controler1.text);
  //   response = await sqlDb.insertData(
  //       "INSERT INTO notes ('pin','folder','text','dtime','path','imgname','textvalue') VALUES('${widget.pin}','${widget.title}','$newpath','null','${widget.path}','${controler.text}','$text')");
  //   print(response);
  //   List<Map> responsea = await sqlDb.readData("SELECT * FROM  'notes' ");
  //   String gg = responsea.toString();
  //   // setState(() {
  //   //   widget.loading;
  //   // });
  //   print('ffffffffffffffffffffff');
  // }

  Future<File> encryptFiles(
      String inputFileName, String outputFileName, String directory) async {
    FileCryptor fileCryptor = FileCryptor(
      key: 'Your 32 bit key.................',
      iv: 16,
      dir: directory,
    );

    return fileCryptor.encrypt(
        inputFile: inputFileName, outputFile: outputFileName);
  }

  DateTime? sheduleDate;
  String? pickdate;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Colors.brown[100],
                // backgroundColor: kdarkblue,
                // title: const Text('AlertDialog Title'),
                content: SingleChildScrollView(
                    child: Column(
                  children: [
                    Text(
                      'Set Remainder',
                      style: TextStyle(
                          color: kblack,
                          fontSize: 21,
                          fontWeight: FontWeight.w500),
                    ),
                    const Divider(color: Colors.grey, height: 32),
                    const SizedBox(height: 16),
                    NumberPicker(
                      value: _currentHorizontalIntValue,
                      minValue: 0,
                      maxValue: 100,
                      step: 1,
                      itemHeight: 100,
                      axis: Axis.horizontal,
                      onChanged: (value) {
                        setState(() {
                          _currentHorizontalIntValue = value;
                        });
                      },
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black26),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.remove,
                            color: kblue,
                          ),
                          onPressed: () => setState(() {
                            final newValue = _currentHorizontalIntValue - 1;
                            _currentHorizontalIntValue = newValue.clamp(0, 100);
                            remainderDate = _currentHorizontalIntValue;
                            print(sheduleDate);
                            // print(_currentHorizontalIntValue);
                          }),
                        ),
                        Text(
                            'Current Remainder date: $_currentHorizontalIntValue',
                            style: TextStyle(color: kblack)),
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            color: kblue,
                          ),
                          onPressed: () => setState(() {
                            final newValue = _currentHorizontalIntValue + 1;
                            _currentHorizontalIntValue = newValue.clamp(0, 100);
                            remainderDate = _currentHorizontalIntValue;
                            print(remainderDate);
                            // print(_currentHorizontalIntValue.toString());
                          }),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_alert_sharp,
                          ),
                          onPressed: () async {
                            print(controler.text);
                            print(widget.pin);
                            print(widget.title);
                            log(filePath.toString());
                            print('ddddddd');
                            var updateResponse = sqlDb.updateData(
                                "UPDATE notes SET dtime = '$remainderDate' WHERE id = '$response'  ");
                            setState(() {
                              filesave = false;
                            });
                            pickdate = pickdate;
                            print(updateResponse);
                            print('hhhhhhhhhhhh');
                            print(response);
                            print(remainderDate);
                            // print(updateResponse);
                            // int response = await sqlDb.insertData(
                            //     "INSERT INTO notes ('pin','folder','text','dtime') VALUES('${widget.pin}','${widget.title}','$textFileName','$pickdate')");
                            // print(response);
                            NotificationApi.showScheduleNotification(
                              id: response!,
                              foldername: widget.title,
                              pin: widget.pin,
                              textname: controler.text,
                              title: 'Reminder!',
                              body:
                                  'Open the saved file ( filename ${controler.text})',
                              payload: 'lllll',
                              scheduledDate: remainderDate!,
                            );
                            setState(() {
                              loadd();
                              remainderbutton = true;
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 200,
                    ),
                  ],
                )),
              );
            },
          );
        });
  }

  Future<void> displayTimeDialog() async {
    String selectedTime;
    final TimeOfDay? time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        selectedTime = time.format(context);
      });
    }
  }

  Future<void> displayyTimeDialog() async {
    String selectedTimee;
    final TimeOfDay? time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        selectedTimee = time.format(context);
      });
    }
  }
// deleting files

  void delete(String path) {
    final dir = Directory(path);
    dir.deleteSync(recursive: true);
  }
}
