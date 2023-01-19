// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:safe_encrypt/constants/myvar.dart';
import 'package:safe_encrypt/screens/features/gallery/nots/spacial_nots/spacial_notes_create_new.dart';
import 'package:safe_encrypt/screens/features/gallery/nots/spacial_nots/spacial_notes_previw.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../constants/colors.dart';

class SpacialNots extends StatefulWidget {
  const SpacialNots({
    Key? key,
    // required this.title,
    required this.pin,

    //   required this.path
  }) : super(key: key);
  // final String path;
  final String pin;

  // final String title;

  @override
  State<SpacialNots> createState() => _SpacialNotsState();
}

String hhh = 'ffff';

var not;

class _SpacialNotsState extends State<SpacialNots> {
  final HtmlEditorController _controller = HtmlEditorController();

  final FocusNode _focusNode = FocusNode();
  List<Map> spacialNotsList = [];
  String getNotes = '';
  bool hideIcon = false;
  bool loading = false;
  @override
  void initState() {
    textremainder();

    // TODO: implement initState
    super.initState();
  }

  textremainder() async {
    spacialNotsList = await sqlDb.readData("SELECT * FROM spacialnotes WHERE pin = '${widget.pin}' ");
    print(spacialNotsList.toString());
    setState(() {
      spacialNotsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kdarkblue,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              // itemCount: myfolderlist.length,
              itemCount: spacialNotsList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 4 / 1, crossAxisSpacing: 3.0),
              padding: EdgeInsets.only(left: 20),
              itemBuilder: (BuildContext context, index) {
                String notePath = spacialNotsList[index]['notes_name'];
                getNotes = spacialNotsList[index]['notes'];
                HtmlEditorController controller1 = HtmlEditorController();
                print(notePath);

                print(getNotes.toString());
                return InkWell(
                  onTap: () async {
                    // print(spacialNotsList[index]['notes'].toString());
                    // print(spacialNotsList[index]['path']);
                    print(notePath);

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SpacialNotesPreviw(
                          code: spacialNotsList[index]['bit_code'].toString(),
                        ),
                      ),
                    );

                    inserttext() {
                      setState(() {
                        controller1.insertHtml(getNotes);
                      });
                    }
                  },
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Container(
                        height: 100,
                        color: kgray,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 80,
                                    child: Icon(
                                      Icons.note_alt_outlined,
                                      size: 50,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        spacialNotsList[index]['notes_name'].toString(),
                                        style: TextStyle(color: kblack, fontWeight: FontWeight.w500, fontSize: 17),
                                      ),
                                    ),
                                    Text(spacialNotsList[index]['dtime'].toString(),
                                        style: TextStyle(color: kblack, fontWeight: FontWeight.w500, fontSize: 17)),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(spacialNotsList[index]['bit_code'].toString(),
                                          style: TextStyle(color: kblack, fontWeight: FontWeight.w500, fontSize: 19)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.share),
                                    onPressed: () {
                                      Share.share(
                                        "$privetWeb :  ${spacialNotsList[index]['bit_code']}",
                                      );
                                    }),
                                IconButton(
                                  icon: Icon(Icons.copy),
                                  onPressed: () async {
                                    Clipboard.setData(ClipboardData(text: spacialNotsList[index]['bit_code'].toString())).then((_) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("code copied to clipboard")));
                                    });
                                    // copied successfully
                                    // Fluttertoast.showToast(
                                    //   msg: "No internet connection",
                                    //   toastLength: Toast.LENGTH_SHORT,
                                    //   gravity: ToastGravity.BOTTOM,
                                    //   timeInSecForIosWeb: 1,
                                    //   backgroundColor: Colors.lightGreen,
                                    //   textColor: Colors.white,
                                    //   fontSize: 16.0);
                                  },
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      var deletepath =
                                          await sqlDb.deleteData('DELETE FROM spacialnotes WHERE id ="${spacialNotsList[index]['id'].toString()}"');

                                      setState(() {
                                        textremainder();

                                        // itemtlist();
                                      });
                                    }),
                                // PopupMenuButton(
                                //   shape: const RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.all(
                                //       Radius.circular(20.0),
                                //     ),
                                //   ),
                                //   color: Colors.black87,
                                //   onSelected: (value) {
                                //     // your logic
                                //   },
                                //   itemBuilder: (BuildContext bc) {
                                //     return [
                                //       PopupMenuItem(
                                //           child: Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           TextButton(
                                //             child: Row(
                                //               children: [
                                //                 Icon(
                                //                   Icons.add,
                                //                   color: kwhite,
                                //                 ),
                                //                 const SizedBox(
                                //                   width: 17,
                                //                 ),
                                //                 Text(
                                //                   'Add remainder',
                                //                   style: TextStyle(color: kwhite),
                                //                 ),
                                //               ],
                                //             ),
                                //             onPressed: () async {},
                                //           ),
                                //           TextButton(
                                //             child: Row(
                                //               children: [
                                //                 Icon(
                                //                   Icons.delete,
                                //                   color: kwhite,
                                //                 ),
                                //                 const SizedBox(
                                //                   width: 17,
                                //                 ),
                                //                 Text(
                                //                   'Delete',
                                //                   style: TextStyle(color: kwhite),
                                //                 ),
                                //               ],
                                //             ),
                                //             onPressed: () async {
                                //               print(spacialNotsList[index]['id']);
                                //               var deletepath = await sqlDb.deleteData(
                                //                   'DELETE FROM spacialnotes WHERE id ="${spacialNotsList[index]['id'].toString()}"');

                                //               setState(() {
                                //                 textremainder();

                                //                 // itemtlist();
                                //               });

                                //               Navigator.pop(context);
                                //             },
                                //           ),
                                //           TextButton(
                                //             child: Row(
                                //               children: [
                                //                 Icon(
                                //                   Icons.share,
                                //                   color: kwhite,
                                //                 ),
                                //                 const SizedBox(
                                //                   width: 17,
                                //                 ),
                                //                 Text(
                                //                   'Share ',
                                //                   style: TextStyle(color: kwhite),
                                //                 ),
                                //               ],
                                //             ),
                                //             onPressed: () async {},
                                //           ),
                                //           TextButton(
                                //             child: Row(
                                //               children: [
                                //                 Icon(
                                //                   Icons.share,
                                //                   color: kwhite,
                                //                 ),
                                //                 const SizedBox(
                                //                   width: 17,
                                //                 ),
                                //                 Text(
                                //                   'Share as file',
                                //                   style: TextStyle(color: kwhite),
                                //                 ),
                                //               ],
                                //             ),
                                //             onPressed: () async {},
                                //           ),
                                //           const SizedBox(
                                //             height: 10,
                                //           ),
                                //         ],
                                //       )),
                                //     ];
                                //   },
                                // )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }

  loadNotes() {
    setState(() {
      textremainder();

      print("hhhhhhccccccccccccccccc");
    });
  }

  randomnum() {
    var rndnumber = '';
    var rnd = Random();
    for (var i = 0; i < 15; i++) {
      rndnumber = rndnumber + rnd.nextInt(9).toString();
    }
    print(rndnumber.toString());
  }
}
