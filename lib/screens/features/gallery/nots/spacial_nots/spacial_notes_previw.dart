import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../constants/colors.dart';
import 'package:http/http.dart' as http;

class SpacialNotesPreviw extends StatefulWidget {
  const SpacialNotesPreviw({Key? key, required this.code}) : super(key: key);
  final String code;

  @override
  State<SpacialNotesPreviw> createState() => _SpacialNotesReadState();
}

class _SpacialNotesReadState extends State<SpacialNotesPreviw> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool displaynotes = true;
  var token;
  String? notesValue;
  var data;
  List res = [];
  String? user_id;
  String my_user_id = ' ';
  var response;

  getToken() async {
    _isLoading = true;
    var url = Uri.http('207.244.230.39', '/mobileapp1/v1/generateaccesstoken');
    var response = await http.post(url, body: {"grant_type": "client_credentials", "client_id": "test", "client_secret": "test123"});
    var myToken = jsonDecode(response.body);
    token = myToken['access_token'];
    log(myToken['access_token']);

    getMySpNotes();
  }

  getMySpNotes() async {
    _isLoading = true;
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/x-www-form-urlencoded'};

    var fullUrl = Uri.parse('http://207.244.230.39/mobileapp1/v1/Fetching_results');
    response = await http.post(fullUrl, headers: headers, body: {'random_num': widget.code, '': ''});

    res = jsonDecode(response.body);
    // var pin = res[1].toString();

    print(res.join(", ").toString().replaceAll(",", ""));

    data = res.join(", ").toString().replaceAll(",", "");

    // print(data['']['pin'].toString());
    _isLoading = false;
    if (res.isNotEmpty) {
      for (int index in Iterable.generate(res.length)) {
        var pin = res[index]['pin'];
        if (pin.toString().isNotEmpty) {
          _isLoading = true;
          enterpin(res, pin);
        }
        if (pin.toString().isEmpty) {
          setState(() {
            res;
          });
          log('gggggggg');
        }
      }
    } else {
      log('ggggggg');
      Fluttertoast.showToast(
          msg: "Your code not valid",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    loadnotes();
    print(widget.code);
    internet();
    getuserId();
    // TODO: implement initState
    super.initState();
  }

  loadnotes() async {
    setState(() {
      _isLoading = true;
      res = [];
    });

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      await getToken();
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

  getuserId() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    user_id = sharedPreferences.getString('user_id');
    my_user_id = user_id.toString();
    setState(() {
      my_user_id = user_id.toString();
      log(my_user_id);
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Note Preview'),
          backgroundColor: kdarkblue,
        ),
        // backgroundColor: kdarkblue,
        body: displaynotes
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Code:',
                                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                widget.code,
                                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        _isLoading
                            ? Column(
                                children: [
                                  const SizedBox(
                                    height: 250,
                                  ),
                                  Center(
                                    child: CupertinoActivityIndicator(
                                      radius: 40.0,
                                      animating: true,
                                      color: kdarkblue,
                                    ),
                                  ),
                                ],
                              )
                            : SingleChildScrollView(
                                child: Container(
                                  //alignment: Alignment.center,
                                  // color: Colors.black45,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: <Widget>[
                                        for (int index in Iterable.generate(res.length))
                                          if (res[index]['user_fid'] == my_user_id)
                                            Container(
                                              constraints: const BoxConstraints(),
                                              decoration: BoxDecoration(
                                                  color: Colors.green[200],
                                                  borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(40),
                                                      bottomRight: Radius.circular(40),
                                                      bottomLeft: Radius.circular(40))),
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: SingleChildScrollView(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Text(
                                                              '${res[index]['notes_name']}',
                                                              style: const TextStyle(color: Color.fromARGB(255, 158, 49, 9)),
                                                            ),
                                                          ],
                                                        ),
                                                        Html(
                                                          data: """   ${res[index]['notes_value']}
                                                                        
                                                                        
                                                                        """,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          else
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: Color.fromARGB(255, 204, 215, 204),
                                                  borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(60),
                                                      bottomRight: Radius.circular(60),
                                                      bottomLeft: Radius.circular(70))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${res[index]['notes_name']}',
                                                          style: const TextStyle(color: Color.fromARGB(255, 158, 49, 9)),
                                                        ),
                                                      ],
                                                    ),
                                                    Html(
                                                      data: """ ${res[index]['notes_value']}
                                                                   """,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        // Text(data)
                      ],
                    ),
                  ),
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                  Center(
                      child: Text(
                    'Ops ! somthing is wrong ',
                    style: TextStyle(color: kdarkblue, fontSize: 21),
                  )),
                ],
              ));
  }

  Future<void> enterpin(res, pin) async {
    setState(() {
      // _isLoading = false;
    });
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              // backgroundColor: kdarkblue,
              // title: const Text('AlertDialog Title'),
              content: SingleChildScrollView(
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
            IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>  SpacialNotesPreviw()), (Route<dynamic> route) => false);
                  setState(() {
                    displaynotes = false;
                    my_user_id = 'm';
                    // _searchController.clear();
                    // _isLoading = false;
                    res = [];
                    print(res);
                  });
                  Navigator.pop(context);
                }),
            Column(children: [
              const Text('Enter PassWord'),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: passwordController,
                maxLength: 4,
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 300,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kliteblue),
                    child: Text('confirm', style: TextStyle(color: kwhite, fontSize: 21, fontWeight: FontWeight.w500)),
                  ),
                  onPressed: () {
                    if (pin == passwordController.text) {
                      setState(() {
                        _isLoading = false;
                        res;
                      });
                      Navigator.pop(context);
                      passwordController.clear();
                    } else {
                      Fluttertoast.showToast(
                          msg: "wrong password",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  })
            ])
          ])));
        });
  }
}

class Autogenerated {
  String? notesValue;

  Autogenerated({this.notesValue});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    notesValue = json['notes_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notes_value'] = notesValue;
    return data;
  }
}
