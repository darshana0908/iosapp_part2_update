import 'dart:io';

import 'package:file_cryptor/file_cryptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:safe_encrypt/constants/colors.dart';
import 'package:safe_encrypt/db/sqldb.dart';
import 'package:safe_encrypt/screens/features/gallery/nots/my_nots_previw.dart';
import 'package:safe_encrypt/screens/features/gallery/nots/spacial_nots/spacial_nots_view.dart';
// import 'package:share_plus/share_plus.dart';
import '../../../../class/lcl_notification.dart';
import 'create_note.dart';
import 'dart:math';

class MyNots extends StatefulWidget {
  const MyNots(
      {Key? key,
      required this.notlist,
      required this.title,
      required this.imgpath,
      required this.getbool,
      required this.pin,
      required this.path})
      : super(key: key);
  final List notlist;
  final String path;
  final String pin;
  final String title;
  final String imgpath;
  final Function getbool;

  @override
  State<MyNots> createState() => _MyNotsState();
}

class _MyNotsState extends State<MyNots> {
  String mynotes = '';

  SqlDb sqlDb = SqlDb();
  List<Map> myfolderlist = [];
  bool edit = false;
  List<Map> remainders = [];
  int _currentHorizontalIntValue = 5;

  @override
  void initState() {
    widget.getbool();
    textremainder();
    print(widget.path.toString());
    // itemtlist();
    remainders;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: SpeedDial(
              buttonSize: const Size(70.0, 70.0),
              childrenButtonSize: const Size(55.0, 55.0),
              overlayColor: const Color(0xff00aeed),
              overlayOpacity: 1.0,
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
                    child: Icon(Icons.photo, color: kwhite, size: 30),
                    labelWidget: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text('Create Notes',
                            style: TextStyle(
                                color: kwhite,
                                fontSize: 22,
                                fontWeight: FontWeight.w500))),
                    onTap: () async {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => TxtWritingPage(
                      //               title: widget.title,
                      //               pin: widget.pin,
                      //               loading: loadings,
                      //               path: widget.path,
                      //             )
                      //             )
                      //             );
                    },
                    backgroundColor: Colors.black38),
              ])),
      // appBar: AppBar(
      //   backgroundColor: kdarkblue,
      //   title: const Text(' Notes list'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(
      //         Icons.remove_red_eye_outlined,
      //         color: kwhite,
      //       ),
      //       onPressed: () async {
      //         setState(() {
      //           edit = !edit;
      //         });
      //       },
      //     ),
      //   ],
      // ),
      body: GridView.builder(
          // itemCount: myfolderlist.length,
          itemCount: widget.notlist.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
          itemBuilder: (BuildContext context, index) {
            String imgPath = widget.notlist[index]['text'];
//dddddddd
            TextEditingController mycontroller = TextEditingController(
                text: widget.notlist[index]['textvalue'].toString());
            print(imgPath);

            // oneEntity = folderList[index].toString();
            // folderName = oneEntity.split('/').last.replaceAll("'", '');
            return GestureDetector(
              onTap: () async {
                if (widget.notlist[index]['dtime'] == 'null') {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyNotePrevew(
                        path: widget.notlist[index]['path'].toString(),
                        loading: widget.getbool,
                        textfilename:
                            widget.notlist[index]['imgname'].toString(),
                        textvalue:
                            widget.notlist[index]['textvalue'].toString(),
                        text: imgPath,
                      ),
                    ),
                  );
                } else {
                  await flutterLocalNotificationsPlugin
                      .cancel(widget.notlist[index]['id']);
                  int newnoti =
                      int.parse(widget.notlist[index]['dtime'].toString());
                  var response = await sqlDb.updateData(
                      "UPDATE notes SET dtime ='${widget.notlist[index]['dtime'].toString()}' WHERE text ='${widget.notlist[index]['id'].toString()}';");

                  // log(remainders[index]['dtime']);
                  NotificationApi.showScheduleNotification(
                    scheduledDate: newnoti,
                    pin: widget.notlist[index]['pin'].toString(),
                    foldername: widget.notlist[index]['title'].toString(),
                    textname: widget.notlist[index]['imgname'].toString(),
                    id: widget.notlist[index]['id'],
                    title: 'Reminder!',
                    body:
                        'Open the saved file ( filename ${widget.notlist[index]['imgname'].toString()})',
                    payload: 'kkkk',
                  );
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyNotePrevew(
                          path: widget.notlist[index]['path'].toString(),
                          loading: loadings,
                          textfilename:
                              widget.notlist[index]['imgname'].toString(),
                          textvalue:
                              widget.notlist[index]['textvalue'].toString(),
                          text: imgPath,
                        ),
                      ));
                }
                // OpenFile.open(imgPath);
                // setState(() {
                //   widget.getbool();
                //   print(widget.getbool());
                // });
              },
              child: Column(
                children: [
                  if (widget.notlist[index]['dtime'] == 'null')
                    Card(
                      child: SizedBox(
                        height: 230,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Opacity(
                              opacity: edit ? 0.0 : 1.0,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      16,
                                  height: 150,
                                  child: Image.asset(
                                    'assets/notes.png',
                                  )),
                            ),
                            Container(
                              color: kliteblue,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(),
                                  Container(
                                      alignment: Alignment.center,
                                      width: 70,
                                      height: 50,
                                      child: SingleChildScrollView(
                                          physics: const ScrollPhysics(
                                              parent:
                                                  AlwaysScrollableScrollPhysics()),
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            widget.notlist[index]['imgname'],
                                            style: TextStyle(
                                                color: kblack,
                                                fontWeight: FontWeight.w500),
                                          ))),
                                  PopupMenuButton(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                    ),
                                    color: Colors.black87,
                                    onSelected: (value) {
                                      // your logic
                                    },
                                    itemBuilder: (BuildContext bc) {
                                      return [
                                        PopupMenuItem(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextButton(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    color: kwhite,
                                                  ),
                                                  const SizedBox(
                                                    width: 17,
                                                  ),
                                                  Text(
                                                    'Add remainder',
                                                    style: TextStyle(
                                                        color: kwhite),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () async {
                                                _showMyDialog(widget
                                                    .notlist[index]['id']
                                                    .toString());
                                              },
                                            ),
                                            TextButton(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: kwhite,
                                                  ),
                                                  const SizedBox(
                                                    width: 17,
                                                  ),
                                                  Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: kwhite),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () async {
                                                var deletepath =
                                                    await sqlDb.deleteData(
                                                        'DELETE FROM notes WHERE id ="${widget.notlist[index]['id'].toString()}"');
                                                await flutterLocalNotificationsPlugin
                                                    .cancel(widget
                                                        .notlist[index]['id']);
                                                setState(() {
                                                  textremainder();
                                                  // itemtlist();
                                                  remainders;
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.share,
                                                    color: kwhite,
                                                  ),
                                                  const SizedBox(
                                                    width: 17,
                                                  ),
                                                  Text(
                                                    'Share ',
                                                    style: TextStyle(
                                                        color: kwhite),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () async {
                                                // Share.share(
                                                //   remainders[index]['textvalue'].toString(),
                                                // );
                                              },
                                            ),
                                            TextButton(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.share,
                                                    color: kwhite,
                                                  ),
                                                  const SizedBox(
                                                    width: 17,
                                                  ),
                                                  Text(
                                                    'Share as file',
                                                    style: TextStyle(
                                                        color: kwhite),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () async {
                                                _write(
                                                    widget.notlist[index]
                                                            ['textvalue']
                                                        .toString(),
                                                    widget.notlist[index]
                                                            ['imgname']
                                                        .toString());
                                                // await Share.shareFiles(['${widget.path}/$textFileName'], text: 'Great picture');

                                                delete(
                                                    '${widget.path}/$textFileName');
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        )),
                                      ];
                                    },
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  else
                    Card(
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 230,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Opacity(
                                  opacity: edit ? 0.0 : 1.0,
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          16,
                                      height: 150,
                                      child: Image.asset(
                                        'assets/notes.png',
                                      )),
                                ),
                                Container(
                                  color: kliteblue,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(),
                                      Container(
                                          alignment: Alignment.center,
                                          width: 70,
                                          height: 50,
                                          child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(widget.notlist[index]
                                                  ['imgname']))),
                                      PopupMenuButton(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                        ),
                                        color: Colors.black87,
                                        onSelected: (value) {
                                          // your logic
                                        },
                                        itemBuilder: (BuildContext bc) {
                                          return [
                                            PopupMenuItem(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextButton(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color: kwhite,
                                                      ),
                                                      const SizedBox(
                                                        width: 17,
                                                      ),
                                                      Text(
                                                        'delete',
                                                        style: TextStyle(
                                                            color: kwhite),
                                                      ),
                                                    ],
                                                  ),
                                                  onPressed: () async {
                                                    var deletepath =
                                                        await sqlDb.deleteData(
                                                            'DELETE FROM notes WHERE id ="${widget.notlist[index]['id'].toString()}"');
                                                    await flutterLocalNotificationsPlugin
                                                        .cancel(widget
                                                                .notlist[index]
                                                            ['id']);
                                                    setState(() {
                                                      textremainder();
                                                      // itemtlist();
                                                      remainders;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                TextButton(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.share,
                                                        color: kwhite,
                                                      ),
                                                      const SizedBox(
                                                        width: 17,
                                                      ),
                                                      Text(
                                                        'Share ',
                                                        style: TextStyle(
                                                            color: kwhite),
                                                      ),
                                                    ],
                                                  ),
                                                  onPressed: () async {
                                                    // Share.share(
                                                    //   remainders[index]['textvalue'].toString(),
                                                    // );
                                                  },
                                                ),
                                                TextButton(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.share,
                                                        color: kwhite,
                                                      ),
                                                      const SizedBox(
                                                        width: 17,
                                                      ),
                                                      Text(
                                                        'Share as file',
                                                        style: TextStyle(
                                                            color: kwhite),
                                                      ),
                                                    ],
                                                  ),
                                                  onPressed: () async {
                                                    _write(
                                                        widget.notlist[index]
                                                                ['textvalue']
                                                            .toString(),
                                                        widget.notlist[index]
                                                                ['imgname']
                                                            .toString());
                                                    // await Share.shareFiles(['${widget.path}/$textFileName'], text: 'Great picture');

                                                    delete(
                                                        '${widget.path}/$textFileName');
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Icon(
                                                      Icons.info,
                                                      color: kwhite,
                                                    ),
                                                    const SizedBox(
                                                      width: 17,
                                                    ),
                                                    Text('Date of remainder',
                                                        style: TextStyle(
                                                            color: kwhite)),
                                                    const SizedBox(
                                                      width: 17,
                                                    ),
                                                    Text(
                                                        widget.notlist[index]
                                                                ['dtime']
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: kblue)),
                                                  ],
                                                )
                                              ],
                                            )),
                                          ];
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 20,
                            child: Card(
                                child: IconButton(
                                    icon: const Icon(Icons.add_alert_sharp),
                                    splashColor: kblack,
                                    onPressed: () {},
                                    color: kred)),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            );
          }),
    );
  }

  Future<void> _showMyDialog(date) async {
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
                          remainderDate = _currentHorizontalIntValue;
                          print(remainderDate);
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
                            print(remainderDate);
                            // print(sheduleDate);
                            // print(_currentHorizontalIntValue);
                          }),
                        ),
                        Text('Current Remainder date: $remainderDate',
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
                            var updateResponse = sqlDb.updateData(
                                "UPDATE notes SET dtime = '$remainderDate' WHERE id = '$date'  ");
                            setState(() {
                              filesave = false;
                              textremainder();
                              // itemtlist();
                              remainders;
                            });
                            Navigator.pop(context);

                            // pickdate = pickdate;
                            print(updateResponse);
                            print('hhhhhhhhhhhh');
                            print(date);
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
                            setState(() {});
                            Navigator.pop(context);
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

  randomnum() {
    var rndnumber = "";
    var rnd = Random();
    for (var i = 0; i < 16; i++) {
      rndnumber = rndnumber + rnd.nextInt(9).toString();
    }
    print(rndnumber);
  }

  _write(String text, String filename) async {
    String filetype = '.txt';

    Directory? directory = Directory(widget.path);

    textFileName = "$filename$filetype";

    final File file = File('${directory.path}/$textFileName');
    await file.writeAsString(text);

    var newpath = '${directory.path}/$textFileName';
    await encryptFiles(textFileName, '$textFileName.aes', directory.path);
    // delete('${directory.path}/$textFileName');

    // var responsee = await sqlDb.insertData(
    //     "INSERT INTO notes ('pin','folder','text','dtime','path','imgname','textvalue') VALUES('${widget.pin}','${widget.title}','$newpath','null','${widget.path}','$textFileName','$text')");

    List<Map> responsea = await sqlDb.readData("SELECT * FROM  'notes' ");
    print(responsea);
    String gg = responsea.toString();
    // setState(() {
    //   widget.loading;
    // });
    setState(() {
      textFileName;
    });
    print('ffffffffffffffffffffff');
  }

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

  void delete(String path) {
    final dir = Directory(path);
    dir.deleteSync(recursive: true);
  }

  loadings() {
    print(
        'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg');
    setState(() {
      textremainder();

      remainders;
    });

    print('    remainders');
  }

  itemtlist() async {
    myfolderlist = await sqlDb
        .readData('SELECT  * FROM itempassword WHERE userpin = ${widget.pin}');

    // log(myfolderlist[1]['folder-id'].toString());
    setState(() {
      myfolderlist;
    });
  }

  textremainder() async {
    remainders = await sqlDb
        .readData("SELECT * FROM notes WHERE path = '${widget.path}'");

    // log(myfolderlist[1]['folder-id'].toString());
    setState(() {
      remainders;
    });
  }
}
