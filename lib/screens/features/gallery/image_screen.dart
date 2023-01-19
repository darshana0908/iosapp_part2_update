import 'dart:developer';
import 'dart:io';

import 'package:file_cryptor/file_cryptor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:safe_encrypt/constants/images.dart';
import 'package:safe_encrypt/db/sqldb.dart';
import 'package:safe_encrypt/screens/features/gallery/nots/my_nots.dart';

import '../../../services/image_service.dart';
import '../../../constants/colors.dart';
import '../../../services/text_writing_page.dart';

class ImageScreen extends StatefulWidget {
  final String path;
  final String title;
  final Function getbool;
  final String pin;
  const ImageScreen(
      {Key? key,
      required this.pin,
      required this.path,
      required this.title,
      required this.getbool})
      : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen>
    with TickerProviderStateMixin {
  SqlDb sqlDb = SqlDb();
  String imageName = '';
  String fileType = '';
  bool _isLoading = false;
  String imgPath = '';
  bool exitapp = true;
  bool hideminimyzeicon = true;
  bool tabbarcolor = false;

  int x = 1;
  int y = 1;

  int size = 5;
  final ImagePicker _picker = ImagePicker();
  List<String> decryptedImages = [];
  final int _countOfReload = 0;
  bool imgload = false;
  List<Map>? response;
  List remainder = [];
  int currentTabIndex = 0;
  // final TabController _tabController = TabController(length: 2, vsync: );

  @override
  void initState() {
    setState(() {
      textremainder();
      _isLoading = false;
    });

    decryptImages();
    loadPhotos();
    super.initState();
  }

  loadings() {
    setState(() {
      loadings();
      decryptImages();
    });
  }

  loadpage() {
    setState(() {
      currentTabIndex = 0;
    });

    log('fffffff');
  }

  textremainder() async {
    // remainder = await sqlDb.readData("SELECT * FROM  'notes'WHERE path = '${widget.path}'  ");
    var remainders = await sqlDb
        .readData("SELECT * FROM notes WHERE path = '${widget.path}'");

    // log(myfolderlist[1]['folder-id'].toString());
    setState(() {
      // log(remainders);
      remainders;
    });
    // List<Map<String, dynamic>>.generate(remainder.length, (index) {
    //   log(remainder[index]['dtime'].toString());
    //   return Map<String, dynamic>.from(remainder[index]);
    // }, growable: true);
    // var text = remainder[1]['text'];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabController controller = TabController(
      vsync: this,
      length: 2,
      initialIndex: 1,
    );
    controller.animateTo(currentTabIndex);
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async {
          deleteDecryptedImages(decryptedImages);
          _isLoading = false;
          return true;
        },
        child: SafeArea(
          child: Builder(builder: (context) {
            return Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(280.0),
                  child: AppBar(
                      leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          icon: const Icon(Icons.arrow_back)),
                      // toolbarHeight: 300,
                      foregroundColor: kwhite,
                      actions: [
                        hideminimyzeicon
                            ? IconButton(
                                icon: Icon(x == 1
                                    ? Icons.view_list
                                    : x == 2
                                        ? Icons.view_module
                                        : Icons.view_comfortable),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  setState(() {
                                    if (x == 1) {
                                      x = 2;
                                    } else if (x == 2) {
                                      x = 3;
                                    } else {
                                      x = 1;
                                    }
                                  });
                                },
                              )
                            : Container(),
                      ],
                      flexibleSpace: SizedBox(
                        height: 600,
                        child: FlexibleSpaceBar(
                          centerTitle: true,
                          collapseMode: CollapseMode.parallax,
                          expandedTitleScale: 50,
                          background: SizedBox(
                            height: 500,
                            child: imgload
                                ? SizedBox(
                                    height: 600,
                                    child: Column(
                                      children: [
                                        (decryptedImages.last
                                                    .toLowerCase()
                                                    .endsWith('jpg') ||
                                                decryptedImages.last
                                                    .toLowerCase()
                                                    .endsWith('jpeg'))
                                            ? SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.26,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Image.file(
                                                  File(decryptedImages.last),
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : (decryptedImages.last
                                                        .toLowerCase()
                                                        .endsWith('mp4') ||
                                                    decryptedImages.last
                                                        .toLowerCase()
                                                        .endsWith('mp3') ||
                                                    decryptedImages.last
                                                        .toLowerCase()
                                                        .endsWith('avi') ||
                                                    decryptedImages.last
                                                        .toLowerCase()
                                                        .endsWith('mpeg'))
                                                ? SizedBox(
                                                    height:
                                                        MediaQuery.of(context).size.height *
                                                            0.3,
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Image.asset(videoIcon,
                                                        fit: BoxFit.scaleDown))
                                                : (decryptedImages.last
                                                        .toLowerCase()
                                                        .endsWith('pdf'))
                                                    ? SizedBox(
                                                        height: MediaQuery.of(context).size.height * 0.3,
                                                        width: MediaQuery.of(context).size.width,
                                                        child: Image.asset(pdfIcon, fit: BoxFit.scaleDown))
                                                    : (decryptedImages.last.toLowerCase().endsWith('docx') || decryptedImages.last.toLowerCase().endsWith('ppt'))
                                                        ? SizedBox(height: MediaQuery.of(context).size.height * 0.3, width: MediaQuery.of(context).size.width, child: Image.asset(docsIcon, fit: BoxFit.scaleDown))
                                                        : (decryptedImages.last.toLowerCase().endsWith('txt') || decryptedImages.last.toLowerCase().endsWith('txt'))
                                                            ? SizedBox(height: MediaQuery.of(context).size.height * 0.3, width: MediaQuery.of(context).size.width, child: Image.asset('assets/text.png', fit: BoxFit.scaleDown))
                                                            : remainder.last
                                                                ? SizedBox(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.3,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/ic.JPG',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  )
                                                                : SizedBox(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.3,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/ic.JPG',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                      ],
                                    ),
                                  )
                                : Image.asset(
                                    'assets/ic.JPG',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      title: SizedBox(
                        width: 300,
                        height: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.title),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () => setState(() => y = 2),
                                  child: Text(
                                    '(${decryptedImages.length})   All Files',
                                    style:
                                        TextStyle(color: kgray, fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: kwhite,
                      bottom: TabBar(
                          indicatorPadding: EdgeInsets.all(1),
                          indicatorWeight: 5,
                          indicatorColor: kred,
                          indicatorSize: TabBarIndicatorSize.label,
                          padding: EdgeInsets.all(1),
                          labelColor: kgray,
                          controller: controller,
                          tabs: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  // tabbarcolor = true;
                                  currentTabIndex = 0;
                                  hideminimyzeicon = true;
                                });
                              },
                              child: Container(
                                color: tabbarcolor
                                    ? Color.fromARGB(255, 34, 152, 173)
                                    : kblue,
                                alignment: Alignment.center,
                                height: 50,
                                child: Text(
                                  'Gallery',
                                  style: TextStyle(color: kbg, fontSize: 19),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  // tabbarcolor = true;
                                  hideminimyzeicon = false;
                                  currentTabIndex = 1;
                                });
                              },
                              child: Container(
                                color: kblue,
                                alignment: Alignment.center,
                                height: 50,
                                child: Text(
                                  'Notes',
                                  style: TextStyle(color: kbg, fontSize: 19),
                                ),
                              ),
                            ),
                          ])),
                ),
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
                        labelWidget: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text('Notes',
                                style: TextStyle(
                                    color: kwhite,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500))),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TxtWritingPage(
                                      pageload: loadpage,
                                      title: widget.title,
                                      pin: widget.pin,
                                      loading: textremainder,
                                      path: widget.path,
                                    )),
                          );
                        },
                        elevation: 150,
                        backgroundColor: Colors.black38,
                        child:
                            Icon(Icons.note_add_sharp, color: kwhite, size: 30),
                        labelBackgroundColor: const Color(0xff00aeed),
                      ),
                      SpeedDialChild(
                        labelWidget: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text('Take photo',
                                style: TextStyle(
                                    color: kwhite,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500))),
                        onTap: () async {
                          takePhoto();
                          setState(() {
                            widget.getbool();
                          });
                        },
                        elevation: 150,
                        backgroundColor: Colors.black38,
                        child: Icon(Icons.camera_alt, color: kwhite, size: 30),
                        labelBackgroundColor: const Color(0xff00aeed),
                      ),
                      SpeedDialChild(
                          child: Icon(Icons.photo, color: kwhite, size: 30),
                          labelWidget: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text('Import files',
                                  style: TextStyle(
                                      color: kwhite,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500))),
                          onTap: () async {
                            importFiles();
                            setState(() {
                              widget.getbool();
                              print(widget.getbool());
                            });
                          },
                          backgroundColor: Colors.black38),
                    ],
                  ),
                ),
                backgroundColor: kwhite,
                body: TabBarView(
                  controller: controller,
                  children: [
                    Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: _isLoading
                            ? const Center(
                                child: SizedBox(
                                height: 100,
                                width: 100,
                                child: CupertinoActivityIndicator(radius: 20),
                              ))
                            : loadPhotos(),
                      ),
                    ),
                    Center(
                      child: MyNots(
                          path: widget.path,
                          pin: widget.pin,
                          getbool: textremainder,
                          imgpath: imgPath,
                          title: widget.title),
                    ),
                  ],
                )

                //  CustomScrollView(
                //   physics: const PageScrollPhysics(),
                //   scrollBehavior: const ScrollBehavior(),
                //   slivers: [
                //     SliverAppBar(
                //       backgroundColor: kdarkblue,
                //       bottom:
                //           TabBar(indicatorSize: TabBarIndicatorSize.tab, padding: const EdgeInsets.all(2.0), indicatorColor: Colors.redAccent, tabs: [
                //         Padding(
                //           padding: const EdgeInsets.all(2.0),
                //           child: Container(
                //             alignment: Alignment.center,
                //             height: 30,
                //             child: Text(
                //               'Gallery',
                //               style: TextStyle(color: kbg, fontSize: 19),
                //             ),
                //           ),
                //         ),
                //         Container(
                //           alignment: Alignment.center,
                //           height: 50,
                //           child: Text(
                //             'Notes',
                //             style: TextStyle(color: kbg, fontSize: 19),
                //           ),
                //         ),
                //       ]),
                //       actions: [
                //         IconButton(
                //           icon: const Icon(Icons.open_in_new),
                //           onPressed: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (_) =>
                //                     MyNots(path: widget.path, pin: widget.pin, getbool: widget.getbool, imgpath: imgPath, title: widget.title),
                //               ),
                //             );
                //           },
                //         ),
                //         IconButton(
                //           icon: Icon(x == 1
                //               ? Icons.view_list
                //               : x == 2
                //                   ? Icons.view_module
                //                   : Icons.view_comfortable),
                //           padding: EdgeInsets.zero,
                //           onPressed: () {
                //             setState(() {
                //               if (x == 1) {
                //                 x = 2;
                //               } else if (x == 2) {
                //                 x = 3;
                //               } else {
                //                 x = 1;
                //               }
                //             });
                //           },
                //         ),
                //         IconButton(
                //           icon: const Icon(Icons.more_vert),
                //           onPressed: () {},
                //         ),
                //       ],
                //       flexibleSpace: FlexibleSpaceBar(
                //         background: imgload
                //             ? SizedBox(
                //                 height: 100,
                //                 child: Column(
                //                   children: [
                //                     (decryptedImages.last.toLowerCase().endsWith('jpg') || decryptedImages.last.toLowerCase().endsWith('jpeg'))
                //                         ? SizedBox(
                //                             height: MediaQuery.of(context).size.height * 0.3,
                //                             width: MediaQuery.of(context).size.width,
                //                             child: Image.file(
                //                               File(decryptedImages.last),
                //                               fit: BoxFit.cover,
                //                             ),
                //                           )
                //                         : (decryptedImages.last.toLowerCase().endsWith('mp4') ||
                //                                 decryptedImages.last.toLowerCase().endsWith('mp3') ||
                //                                 decryptedImages.last.toLowerCase().endsWith('avi') ||
                //                                 decryptedImages.last.toLowerCase().endsWith('mpeg'))
                //                             ? SizedBox(
                //                                 height: MediaQuery.of(context).size.height * 0.3,
                //                                 width: MediaQuery.of(context).size.width,
                //                                 child: Image.asset(videoIcon, fit: BoxFit.scaleDown))
                //                             : (decryptedImages.last.toLowerCase().endsWith('pdf'))
                //                                 ? SizedBox(
                //                                     height: MediaQuery.of(context).size.height * 0.3,
                //                                     width: MediaQuery.of(context).size.width,
                //                                     child: Image.asset(pdfIcon, fit: BoxFit.scaleDown))
                //                                 : (decryptedImages.last.toLowerCase().endsWith('docx') ||
                //                                         decryptedImages.last.toLowerCase().endsWith('ppt'))
                //                                     ? SizedBox(
                //                                         height: MediaQuery.of(context).size.height * 0.3,
                //                                         width: MediaQuery.of(context).size.width,
                //                                         child: Image.asset(docsIcon, fit: BoxFit.scaleDown))
                //                                     : (decryptedImages.last.toLowerCase().endsWith('txt') ||
                //                                             decryptedImages.last.toLowerCase().endsWith('txt'))
                //                                         ? SizedBox(
                //                                             height: MediaQuery.of(context).size.height * 0.3,
                //                                             width: MediaQuery.of(context).size.width,
                //                                             child: Image.asset('assets/text.png', fit: BoxFit.scaleDown))
                //                                         : remainder.last
                //                                             ? SizedBox(
                //                                                 height: MediaQuery.of(context).size.height * 0.3,
                //                                                 width: MediaQuery.of(context).size.width,
                //                                                 child: Image.asset(
                //                                                   'assets/ic.JPG',
                //                                                   fit: BoxFit.cover,
                //                                                 ),
                //                                               )
                //                                             : SizedBox(
                //                                                 height: MediaQuery.of(context).size.height * 0.3,
                //                                                 width: MediaQuery.of(context).size.width,
                //                                                 child: Image.asset(
                //                                                   'assets/ic.JPG',
                //                                                   fit: BoxFit.cover,
                //                                                 ),
                //                                               ),
                //                   ],
                //                 ),
                //               )
                //             : Image.asset(
                //                 'assets/ic.JPG',
                //                 fit: BoxFit.cover,
                //               ),
                //         title: SizedBox(
                //           width: 300,
                //           height: 150,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.end,
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(widget.title),
                //               Row(
                //                 children: [
                //                   TextButton(
                //                     onPressed: () => setState(() => y = 2),
                //                     child: Text(
                //                       '(${decryptedImages.length})   All Files',
                //                       style: TextStyle(color: kgray, fontSize: 11),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //       floating: false,
                //       pinned: true,
                //       expandedHeight: MediaQuery.of(context).size.height * 0.3,
                //     ),
                //     SliverList(
                //         delegate: SliverChildListDelegate([
                //       Center(
                //         child: SizedBox(
                //           height: MediaQuery.of(context).size.height * 0.7,
                //           child: _isLoading
                //               ? const Center(
                //                   child: SizedBox(
                //                   height: 100,
                //                   width: 100,
                //                   child: CupertinoActivityIndicator(radius: 20),
                //                 ))
                //               : loadPhotos(),
                //         ),
                //       ),
                //       Center(child: MyNots(path: widget.path, pin: widget.pin, getbool: widget.getbool, imgpath: imgPath, title: widget.title)),
                //     ]))
                //   ],
                // ),

                );
          }),
        ),
      ),
    );
  }

  // loading all photos in the folder
  loadPhotos() {
    if (decryptedImages.isNotEmpty) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: x == 1
                ? 1
                : x == 2
                    ? 1
                    : 4,
            crossAxisCount: x == 1
                ? 2
                : x == 2
                    ? 4
                    : 1),
        padding: const EdgeInsets.all(0.8),
        itemCount: decryptedImages.length,
        itemBuilder: (context, index) {
          String imgPath = decryptedImages[index];
          String extention = '';
          String newimg = '';
          String imgname = imgPath.split('/').last.replaceAll("'", '');
          extention = imgPath.split('.').last.replaceAll("'", '');
          // print(imgPath);

          return GestureDetector(
              onDoubleTap: () async {
                delete(imgPath);
                log(imgPath);
                var deletepath = await sqlDb
                    .deleteData('DELETE FROM notes WHERE text ="$imgPath"');
                log(deletepath.toString());
              },
              onTap: () async {
                // if (checkFileType(imgPath) == 1) {
                //   bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ImageDetails(path: imgPath)));
                //   if (result) decryptImages();
                // } else {
                OpenFile.open(imgPath);
                setState(() {
                  widget.getbool();
                  print(widget.getbool());
                });
                // }
              },
              child: x == 1
                  ? Column(
                      children: [
                        checkFileType(imgPath) == 1
                            ? Card(
                                elevation: 8,
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 16,
                                    height: 200,
                                    child: Image.file(File(imgPath),
                                        fit: BoxFit.cover)))
                            : checkFileType(imgPath) == 2
                                ? Card(
                                    elevation: 8,
                                    child: SizedBox(
                                        width: MediaQuery.of(context).size.width -
                                            16,
                                        height: 200,
                                        child: Image.asset(videoIcon,
                                            fit: BoxFit.scaleDown, scale: 2)))
                                : checkFileType(imgPath) == 3
                                    ? Card(
                                        elevation: 8,
                                        child: SizedBox(
                                            width: MediaQuery.of(context).size.width -
                                                16,
                                            height: 200,
                                            child: Image.asset(pdfIcon,
                                                fit: BoxFit.scaleDown,
                                                scale: 2)))
                                    : checkFileType(imgPath) == 4
                                        ? Card(
                                            elevation: 8,
                                            child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    16,
                                                height: 200,
                                                child: Image.asset('assets/text.png',
                                                    fit: BoxFit.scaleDown,
                                                    scale: 2)))
                                        : Card(elevation: 8, child: SizedBox(width: MediaQuery.of(context).size.width - 16, height: 200, child: Image.asset(docsIcon, fit: BoxFit.scaleDown, scale: 2)))
                      ],
                    )
                  : x == 2
                      ? Column(
                          children: [
                            checkFileType(imgPath) == 1
                                ? Card(
                                    elevation: 8,
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                48,
                                        height: 100,
                                        child: Image.file(File(imgPath),
                                            fit: BoxFit.cover)),
                                  )
                                : checkFileType(imgPath) == 2
                                    ? Card(
                                        elevation: 8,
                                        child: SizedBox(
                                            width: MediaQuery.of(context).size.width -
                                                48,
                                            height: 100,
                                            child: Image.asset(videoIcon,
                                                fit: BoxFit.scaleDown)))
                                    : checkFileType(imgPath) == 3
                                        ? Card(
                                            elevation: 8,
                                            child: SizedBox(
                                                width: MediaQuery.of(context).size.width -
                                                    48,
                                                height: 100,
                                                child: Image.asset(pdfIcon,
                                                    fit: BoxFit.scaleDown)))
                                        : checkFileType(imgPath) == 4
                                            ? Card(
                                                elevation: 8,
                                                child: SizedBox(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        48,
                                                    height: 100,
                                                    child: Image.asset(
                                                        'assets/text.png',
                                                        fit: BoxFit.scaleDown)))
                                            : Card(
                                                elevation: 8,
                                                child: SizedBox(width: MediaQuery.of(context).size.width - 48, height: 100, child: Image.asset(docsIcon, fit: BoxFit.scaleDown)))
                          ],
                        )
                      : Column(
                          children: [
                            checkFileType(imgPath) == 1
                                ? SizedBox(
                                    height: 100,
                                    child: Card(
                                      elevation: 08,
                                      child: Hero(
                                          tag: imgPath,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 80,
                                                    height: 200,
                                                    child: Image.file(
                                                      File(imgPath),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Text(imgname)
                                              ],
                                            ),
                                          )),
                                    ),
                                  )
                                : checkFileType(imgPath) == 2
                                    ? SizedBox(
                                        height: 100,
                                        child: Card(
                                          child: Hero(
                                              tag: imgPath,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                        width: 100,
                                                        height: 200,
                                                        child: Image.asset(
                                                          'assets/pdf-94-256.png',
                                                          fit: BoxFit.scaleDown,
                                                        )),
                                                    Text(imgname)
                                                  ],
                                                ),
                                              )),
                                        ),
                                      )
                                    : checkFileType(imgPath) == 3
                                        ? SizedBox(
                                            height: 100,
                                            child: Card(
                                              child: Hero(
                                                  tag: imgPath,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                            width: 100,
                                                            height: 200,
                                                            child: Image.asset(
                                                              'assets/mp4-1-1-256.png',
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                            )),
                                                        Text(imgname)
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          )
                                        : checkFileType(imgPath) == 4
                                            ? SizedBox(
                                                height: 100,
                                                child: Card(
                                                  child: Hero(
                                                      tag: imgPath,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                                width: 100,
                                                                height: 200,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/text.png',
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                )),
                                                            Text(imgname)
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                              )
                                            : SizedBox(
                                                height: 100,
                                                child: Card(
                                                  child: Hero(
                                                      tag: imgPath,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                                width: 100,
                                                                height: 200,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/docx-8-256.png',
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                )),
                                                            Text(imgname)
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                              ),
                          ],
                        ));
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 150),
        child: Center(
          child: Column(
            children: [
              Center(
                  child: Icon(Icons.photo_library_rounded,
                      size: 50, color: Colors.grey[400])),
              const SizedBox(height: 50),
              Text("This album is empty.",
                  style: TextStyle(fontSize: 18.0, color: Colors.grey[500])),
            ],
          ),
        ),
      );
    }
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  void importFiles() async {
    setState(() {
      _isLoading = true;
    });

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();

      for (File image in files) {
        fileType = path.extension(image.path);
        imageName = path.basename(image.path);

        File fileToSave = File(image.path);
        fileToSave.copy('${widget.path}/$imageName');
        String key = '';
        ImageService(pinNumber: key)
            .encryptFiles(imageName, '$imageName.aes', widget.path);

        setState(
          () {
            decryptedImages.add('${widget.path}/$imageName');
            loadPhotos();
            Future.delayed(const Duration(seconds: 1));
            _isLoading = false;
            decryptedImages.last;
          },
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // User canceled the picker
    }
  }

  // import photos inside the folder
  importPhotos() async {
    log(widget.path);
    print(imageName);
    setState(() => _isLoading = true);
    final List<XFile>? imageList = await _picker.pickMultiImage();

    if (imageList != null) {
      for (XFile image in imageList) {
        fileType = path.extension(image.path);
        imageName =
            '''IMG-${DateTime.now().microsecondsSinceEpoch.toString()}$fileType\nCreated-${DateTime.now().toString()}''';

        File fileToSave = File(image.path);
        fileToSave.copy('${widget.path}/$imageName');
        String key = '';
        ImageService(pinNumber: key)
            .encryptFiles(imageName, '$imageName.aes', widget.path);

        setState(
          () {
            decryptedImages.add('${widget.path}/$imageName');
          },
        );
        Visibility(
            visible: _isLoading, child: const CircularProgressIndicator());
      }
    }
  }

  // take photos inside the folder
  takePhoto() async {
    setState(() {
      _isLoading = true;
    });
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    print(imageName);
    if (image != null) {
      fileType = path.extension(image.path);
      imageName =
          "Cam-IMG ${DateTime.now().microsecondsSinceEpoch.toString()}$fileType";

      File fileToSave = File(image.path);
      fileToSave.copy('${widget.path}/$imageName');
      String key = '';
      ImageService(pinNumber: key)
          .encryptFiles(imageName, '$imageName.aes', widget.path);

      setState(() {
        decryptedImages.add('${widget.path}/$imageName');
        decryptedImages.last;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // decrypt images when opening folder
  void decryptImages() async {
    setState(() => _isLoading = true);

    FileCryptor fileCryptor = FileCryptor(
        key: 'Your 32 bit key.................', iv: 16, dir: widget.path);
    String currentDirectory = fileCryptor.getCurrentDir();
    String imageName;
    String outputName;

    Directory openedFolder = Directory(widget.path);
    List<String> encryptedImages = openedFolder
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".aes"))
        .toList(growable: true);

    if (encryptedImages.isNotEmpty) {
      for (var image in encryptedImages) {
        imageName = image.replaceAll('$currentDirectory/', '');
        outputName = imageName.replaceAll('.aes', '');
        File decryptedFile = await fileCryptor.decrypt(
            inputFile: imageName, outputFile: outputName);
        decryptedImages.add(decryptedFile.path);
      }

      setState(() {
        imgload = true;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  // delete decrypted images when closing folder (going back)
  void deleteDecryptedImages(List<String> decryptedFiles) async {
    if (decryptedFiles.isNotEmpty) {
      for (var image in decryptedFiles) {
        final dir = Directory(image);
        dir.deleteSync(recursive: true);
      }
    }
  }

  // delete single file (both decrypted and encrypted versions)
  void delete(String path) {
    final decryptedDir = Directory(path);
    final encryptedDir = Directory('$path.aes');
    setState(() {
      decryptedImages.remove(path);
      decryptedDir.deleteSync(recursive: true);
      encryptedDir.deleteSync(recursive: true);
    });
  }

  int checkFileType(String imgPath) {
    if (imgPath.endsWith('jpg') ||
        imgPath.endsWith('jpeg') ||
        imgPath.endsWith('png')) {
      return 1;
    } else if (imgPath.endsWith('mp4') ||
        imgPath.endsWith('mp3') ||
        imgPath.endsWith('avi') ||
        imgPath.endsWith('mkv') ||
        imgPath.endsWith('mpeg')) {
      return 2;
    } else if (imgPath.endsWith('pdf')) {
      return 3;
    } else if (imgPath.endsWith('txt')) {
      return 4;
    } else {
      return 5;
    }
  }
}

class imgload extends ChangeNotifier {
  String decryptedImages = '';
  String get getecryptedImages => decryptedImages;
  img() {
    Image.file(
      File(decryptedImages.length.toString()),
      fit: BoxFit.fill,
    );
  }
}
