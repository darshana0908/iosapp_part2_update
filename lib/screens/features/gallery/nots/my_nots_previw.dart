import 'dart:developer';
import 'dart:io';
import 'package:file_cryptor/file_cryptor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_encrypt/constants/colors.dart';
import 'package:safe_encrypt/db/sqldb.dart';

class MyNotePrevew extends StatefulWidget {
  const MyNotePrevew({Key? key, required this.path, required this.textfilename, required this.loading, required this.textvalue, required this.text})
      : super(key: key);
  final String text;
  final String textvalue;
  final String textfilename;
  final Function loading;
  final String path;

  @override
  State<MyNotePrevew> createState() => _MyNotePrevewState();
}

class _MyNotePrevewState extends State<MyNotePrevew> {
  SqlDb sqlDb = SqlDb();
  bool editble = true;
  String textFileName = '';
  @override
  void initState() {
    widget.text;
    widget.loading;
    widget.textvalue;

    log(widget.textvalue);
    // TODO: implement initState
    super.initState();
  }

  mynotes() async {
    List<Map> responsea = await sqlDb.readData("SELECT textvalue FROM  'notes' WHERE imgname = '${widget.textfilename}' ");
    log(responsea.toString());
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controler = TextEditingController(text: widget.textvalue);
    return Scaffold(
      backgroundColor: kdarkblue,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              widget.loading();
            });
            Navigator.pop(context);
          },
        ),
        backgroundColor: kdarkblue,
        title: SizedBox(width: 180, child: SingleChildScrollView(scrollDirection: Axis.vertical, child: Text(widget.textfilename))),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                editble = false;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: () async {
              // Share.shareFiles(['${widget.path}/$textFileName'], text: 'Great picture');
              log('${widget.path}/$textFileName');
              var response = await sqlDb.updateData("UPDATE notes SET textvalue ='${controler.text}' WHERE text ='${widget.text}';");
              setState(() {
                widget.loading();

                // editble = true;
              });

              Navigator.pop(context, true);
              Fluttertoast.showToast(
                  msg: "  File updated",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.lightGreen,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.share),
          //   onPressed: () async {
          //     _write(controler.text);
          //     await Share.shareFiles(['${widget.path}/$textFileName'], text: 'Great picture');

          //     log(textFileName);
          //     delete('${widget.path}/$textFileName');
          //   },
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: kliteblue),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: kliteblue),
                  child: Card(
                    color: kliteblue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: const InputDecoration(),
                        readOnly: editble,
                        controller: controler,
                        maxLines: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  _write(String text) async {
    String filetype = '.txt';

    Directory? directory = Directory(widget.path);

    textFileName = "${widget.textfilename}$filetype";

    final File file = File('${directory.path}/$textFileName');
    await file.writeAsString(text);
    log(file.toString());
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

  Future<File> encryptFiles(String inputFileName, String outputFileName, String directory) async {
    FileCryptor fileCryptor = FileCryptor(
      key: 'Your 32 bit key.................',
      iv: 16,
      dir: directory,
    );

    return fileCryptor.encrypt(inputFile: inputFileName, outputFile: outputFileName);
  }

  void delete(String path) {
    final dir = Directory(path);
    dir.deleteSync(recursive: true);
  }
}
