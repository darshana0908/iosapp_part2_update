import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:safe_encrypt/constants/colors.dart';
import 'package:safe_encrypt/screens/features/gallery/nots/spacial_nots/spacial_notes_create_new.dart';
import 'package:safe_encrypt/screens/features/gallery/nots/spacial_nots/spacial_notes_read.dart';
import 'package:safe_encrypt/screens/features/gallery/nots/spacial_nots/spacial_nots_view.dart';

class SpacialNotesMain extends StatefulWidget {
  const SpacialNotesMain({Key? key, required this.pin, required this.getbool}) : super(key: key);
  final String pin;
  final Function getbool;
  @override
  State<SpacialNotesMain> createState() => _SpacialNotesMainState();
}

class _SpacialNotesMainState extends State<SpacialNotesMain> {
  List mybitnumber = [];
  int index = 0;
  List<Map> spacialNotsList = [];
  List<String> strs = [];
  List<String> y = [];
  HtmlEditorController controller1 = HtmlEditorController(processInputHtml: true);
  var i;
  @override
  void initState() {
    internet();
    // TODO: implement initState
    super.initState();
  }

  internet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
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
  }

// Initial Selected Value
  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: kdarkblue,
        appBar: AppBar(
          backgroundColor: kdarkblue,
          title: const Text('My spacial notes'),
          bottom: TabBar(tabs: [
            Container(
              alignment: Alignment.center,
              height: 50,
              child: Text(
                'read',
                style: TextStyle(color: kbg, fontSize: 19),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              child: Text(
                'new',
                style: TextStyle(color: kbg, fontSize: 19),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              child: Text(
                'view',
                style: TextStyle(color: kbg, fontSize: 19),
              ),
            ),
          ]),
        ),
        body: TabBarView(children: [
          const Center(child: SpacialNotesRead()),
          Center(
              child: CreateSpacialNotes(
            getbool: widget.getbool,
            pin: widget.pin,
          )),
          Center(
            child: SpacialNots(pin: widget.pin),
          )
        ]),
      ),
    );
  }
}
