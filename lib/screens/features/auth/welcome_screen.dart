import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:safe_encrypt/accsess_name/address.dart';
import 'package:safe_encrypt/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'components/pin_number/first_pin_number.dart';

class WelcomeScreen extends StatefulWidget {
  final String email;
  final String name;
  const WelcomeScreen({Key? key, required this.email, required this.name}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var getMyToken;

  @override
  void initState() {
    getmail();
    gettocken();
    super.initState();
  }

  String? getemail;

  getmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    getemail = sharedPreferences.getString('email');
  }

  var getEmail;
  var getName;
  gettocken() async {
    log('here');
    var url = Uri.http(token_ip, '$token_path/generateaccesstoken');
    log(token_ip);
    log('$token_path/generateaccesstoken');
    var response = await http.post(url, body: {"grant_type": "client_credentials", "client_id": "test", "client_secret": "test123"});
    var mytocken = jsonDecode(response.body);
    getMyToken = mytocken['access_token'];
    print(mytocken['access_token']);
  }

  getuserdata() async {
    // final sharedPreferences = await SharedPreferences.getInstance();
    // getEmail = sharedPreferences.getString('email');
    // getName = sharedPreferences.getString('name');
    // log(getEmail);
    // log(getName);
    // setState(() {
    //   datasend();
    // });
  }

  datasend() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    getEmail = sharedPreferences.getString('email');
    getName = sharedPreferences.getString('name');
    log(getEmail);
    log(getName);

    var request = http.Request('POST', Uri.parse('$data_address/resource'));
    var headers = {'Authorization': 'Bearer $getMyToken', 'Content-Type': 'application/x-www-form-urlencoded'};
    log('gggggggggggggggg');
    String uid = 'userid';
    const pinNumber = '222';

    request.headers.addAll(headers);
    var response = await http.post(Uri.parse('$data_address/resource'),
        headers: headers, body: {'name': '$getName ', 'email': '$getEmail', 'status': 'normal', 'uid': '$getEmail'});

    var res = jsonDecode(response.body.toString());
    log(response.toString());
    log(res['id'].toString());
    String userId = res['id'].toString();

    await sharedPreferences.setString('user_id', userId);
    log(userId);

    // if (response.statusCode == 200) {
    //   print(await response.stream.bytesToString());
    // } else {
    //   print(response.reasonPhrase);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kdarkblue,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: kwhite,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Text(
                    'Welcome back!',
                    style: TextStyle(fontSize: 25, color: kwhite, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Log in with your Keepsafe account email',
                      style: TextStyle(fontSize: 21, color: Colors.white60, fontWeight: FontWeight.w500)),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    getemail.toString(),
                    style: TextStyle(color: kwhite, fontSize: 19),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () async {
                      await datasend();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FirstPinNumber()),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: kblue,
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'NEXT',
                        style: TextStyle(fontSize: 17, color: kwhite, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
