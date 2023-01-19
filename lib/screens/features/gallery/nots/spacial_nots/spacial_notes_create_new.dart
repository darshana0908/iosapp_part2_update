import 'dart:convert';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:safe_encrypt/constants/colors.dart';
import 'package:safe_encrypt/db/sqldb.dart';
import 'package:http/http.dart' as http;
import 'package:safe_encrypt/screens/features/gallery/image_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateSpacialNotes extends StatefulWidget {
  const CreateSpacialNotes(
      {Key? key,
      // required this.title,
      required this.pin,
      required this.getbool})
      : super(key: key);
  // final String path;
  final String pin;
  final Function getbool;
  // final Function loadNotes;
  @override
  State<CreateSpacialNotes> createState() => _CreateSpacialNotesState();
}

HtmlEditorController controller1 = HtmlEditorController(processInputHtml: true);
TextEditingController controller = TextEditingController();
TextEditingController pincontroller = TextEditingController();
TextEditingController newRandomControler = TextEditingController();

SqlDb sqlDb = SqlDb();
FocusNode _focusNode = FocusNode();

class _CreateSpacialNotesState extends State<CreateSpacialNotes> {
  // String rndnumber = '';
  var getMyToken;
  String rndnumber = '';
  bool openTitleBox = false;
  bool updatenotes = false;
  final ScrollController scrolcontroller = ScrollController();
  @override
  void initState() {
    // getbool();
    internet();
    getToken();
    sqldatanotes();

    // TODO: implement initState
    super.initState();
  }

  getbool() {
    setState(() {
      widget.getbool();
      print(widget.getbool());
    });
  }

  internet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.
    } else {
      Fluttertoast.showToast(
          msg: "No internet connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    // I am connected to a wifi network.
  }

  getToken() async {
    print('here');
    var url = Uri.http('207.244.230.39', '/mobileapp1/v1/generateaccesstoken');
    var response = await http.post(url, body: {
      "grant_type": "client_credentials",
      "client_id": "test",
      "client_secret": "test123"
    });
    var myToken = jsonDecode(response.body);
    getMyToken = myToken['access_token'];
    print(myToken['access_token']);
  }

  Future spNotes(
    String notesValue,
  ) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var getemail = sharedPreferences.getString('email');
    var id = sharedPreferences.getString('user_id');
    String userId = id.toString();
    String myemail = getemail.toString();
    print('dddddddddddddddddddddddddddddddddddddddddddcc');
    print(userId);
    print(getemail);

    String myrandomcode = updatenotes ? newRandomControler.text : rndnumber;
    print(rndnumber);
    print(notesValue);
    print(controller.text);
    var headers = {
      'Authorization': 'Bearer $getMyToken',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request(
        'POST', Uri.parse('http://207.244.230.39/mobileapp1/v1/notes'));
    request.bodyFields = {
      'notes_name': controller.text,
      'notes_value': notesValue,
      'random_num': myrandomcode,
      'date_time': DateTime.now().toString(),
      'user_fid': userId,
      'pin': pincontroller.text
    };
    print(userId);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    pincontroller.clear();
    newRandomControler.clear();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    rndnumber = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kdarkblue,
        floatingActionButton: SizedBox(
            height: 100,
            width: 70,
            child: openTitleBox
                ? FloatingActionButton(
                    highlightElevation: 50,
                    onPressed: () async {
                      controller.clear();
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi) {
                        setState(() {
                          getToken();
                          generateRandomString(15);
                          savefiledialog();
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "No internet connection",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.lightGreen,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: const Icon(Icons.add),
                  )
                : null),
        body: Scrollbar(
          thickness: 30,
          trackVisibility: true,
          interactive: true,
          showTrackOnHover: true,
          radius: const Radius.circular(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {});
                        },
                        child: Container(
                          color: kwhite,
                          child: HtmlEditor(
                            controller: controller1, //required
                            htmlEditorOptions: const HtmlEditorOptions(
                                hint: "Type your Text here",
                                characterLimit: 4000,
                                adjustHeightForKeyboard: true,
                                androidUseHybridComposition: false,
                                autoAdjustHeight: true),

                            callbacks: Callbacks(
                              onBeforeCommand: (String? currentHtml) {
                                print('html before change is $currentHtml');
                              },
                              onInit: () {
                                print('jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj');
                                widget.getbool();
                              },
                            ),

                            htmlToolbarOptions: const HtmlToolbarOptions(
                              defaultToolbarButtons: [
                                FontButtons(
                                  bold: true,
                                  clearAll: true,
                                  italic: true,
                                  strikethrough: true,
                                  subscript: true,
                                  superscript: true,
                                  underline: true,
                                ),
                                OtherButtons(codeview: true),
                                ListButtons(),
                                StyleButtons(),
                                ColorButtons(),
                                InsertButtons(
                                    picture: false,
                                    audio: false,
                                    hr: false,
                                    otherFile: false,
                                    table: false,
                                    video: false,
                                    link: false)
                              ],
                              // toolbarItemHeight: 31,
                              toolbarType: ToolbarType.nativeGrid,
                            ),
                            otherOptions: OtherOptions(
                                height:
                                    MediaQuery.of(context).size.height * 0.65),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      child: Container(
                          alignment: Alignment.center,
                          color: kliteblue,
                          height: 50,
                          child: Text(
                            'Save',
                            style: TextStyle(color: kwhite, fontSize: 19),
                          )),
                      onPressed: () async {
                        String data = await controller1.getText();
                        print(data);
                        if (data.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "type your notes",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          print('gggggggggggg');
                        } else {
                          // openTitleBox = true;
                          controller.clear();
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi) {
                            setState(() {
                              getToken();
                              generateRandomString(15);

                              savefiledialog();
                            });
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  // randomnum() {
  //   // var rndnumber = '';
  //   var rnd = Random();
  //   for (var i = 0; i < 16; i++) {
  //     rndnumber = rndnumber + rnd.nextInt(9).toString();
  //   }
  //   setState(() {
  //     rndnumber;
  //   });
  //   print(rndnumber.toString());
  // }

  sqldatanotes() async {
    List<Map> responsea =
        await sqlDb.readData("SELECT * FROM  'spacialnotes' ");
    print(responsea);
  }

  Future<void> savefiledialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            child: AlertDialog(
              // backgroundColor: kdarkblue,
              // title: const Text('AlertDialog Title'),
              actionsAlignment: MainAxisAlignment.spaceBetween,

              content: SizedBox(
                height: 600,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          updatenotes = false;
                          print('false');
                          // widget.loadNotes();
                        });
                      },
                    ),
                    Container(
                      height: 500,
                      color: kwhite,
                      width: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Title',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w500),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  hintText: "Type hear",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Code",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 19),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: updatenotes
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                            width: 300,
                                            child: TextField(
                                                controller: newRandomControler,
                                                maxLength: 15,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "Type hear",
                                                ))),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                            width: 200,
                                            child: Text(
                                              rndnumber,
                                              style: TextStyle(
                                                  color: kblack, fontSize: 17),
                                            )),
                                        TextButton(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: kliteblue,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              alignment: Alignment.center,
                                              height: 40,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'edit',
                                                  style: TextStyle(
                                                      color: kwhite,
                                                      fontSize: 17),
                                                ),
                                              )),
                                          onPressed: () {
                                            setState(() {
                                              updatenotes = true;
                                              print('update');
                                              getToken();
                                              // widget.loadNotes();
                                            });
                                          },
                                        )
                                      ],
                                    ),
                            ),
                          ),
                          updatenotes
                              ? const SizedBox(
                                  height: 50,
                                )
                              : Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('pin',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 19)),
                                      Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: pincontroller,
                                            maxLength: 4,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              hintText: "Type hear",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: kliteblue,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  "save note",
                                  style: TextStyle(color: kwhite, fontSize: 19),
                                ),
                              ),
                              onPressed: () async {
                                print(pincontroller.text.toString());
                                // String newpath = widget.path;
                                // print(newpath);
                                String data = await controller1.getText();
                                var connectivityResult =
                                    await (Connectivity().checkConnectivity());

                                if (connectivityResult ==
                                        ConnectivityResult.mobile ||
                                    connectivityResult ==
                                        ConnectivityResult.wifi) {
                                  if (controller.text.isNotEmpty) {
                                    if (controller.text.length < 30) {
                                      if (pincontroller.text.isNotEmpty) {
                                        if (pincontroller.text.length == 4) {
                                          String myrandomcode = updatenotes
                                              ? newRandomControler.text
                                              : rndnumber;
                                          DateTime now = DateTime.now();
                                          String formattedDate = DateFormat(
                                                  'kk:mm:ss  EEE d MMM y')
                                              .format(now);
                                          var response = await sqlDb.insertData(
                                              "INSERT INTO spacialnotes ('pin','notes','notes_name','bit_code','dtime') VALUES('${widget.pin}','$data','${controller.text}','$myrandomcode','$formattedDate')");

                                          List<Map> responsea =
                                              await sqlDb.readData(
                                                  "SELECT * FROM  'spacialnotes' ");
                                          print(responsea);

                                          setState(() {
                                            spNotes(data);
                                            // widget.loadNotes();
                                          });
                                          Fluttertoast.showToast(
                                              msg: "  File Saved",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  Colors.lightGreen,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          Navigator.pop(context);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "required 4 characters",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.redAccent,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      } else {
                                        String myrandomcode = updatenotes
                                            ? newRandomControler.text
                                            : rndnumber;
                                        DateTime now = DateTime.now();
                                        String formattedDate =
                                            DateFormat('kk:mm:ss  EEE d MMM y')
                                                .format(now);
                                        var response = await sqlDb.insertData(
                                            "INSERT INTO spacialnotes ('pin','notes','notes_name','bit_code','dtime') VALUES('${widget.pin}','$data','${controller.text}','$myrandomcode','$formattedDate')");

                                        List<Map> responsea =
                                            await sqlDb.readData(
                                                "SELECT * FROM  'spacialnotes' ");
                                        print(responsea);

                                        setState(() {
                                          spNotes(data);
                                          // widget.loadNotes();
                                        });
                                        Fluttertoast.showToast(
                                            msg: "  File Saved",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.lightGreen,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        Navigator.pop(context);
                                        print(
                                            'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              " Required less than 30 characters",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Title Required",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "No internet connection",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.lightGreen,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                                controller1.clear();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  String generateRandomString(int len) {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    setState(() {
      rndnumber =
          List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
    });

    print(rndnumber);
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }
}
