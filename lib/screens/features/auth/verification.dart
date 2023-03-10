import 'package:flutter/material.dart';
import 'package:safe_encrypt/constants/colors.dart';

import '../gallery/gallery_home.dart';

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kdarkblue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
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
                  //testing
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(children: [
                      const SizedBox(
                        height: 50,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Check your for an access code',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white60,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            hintText: 'Access Code',
                            hintStyle: const TextStyle(color: Colors.white30),
                            fillColor: kwhite),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          color: kgray,
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'LOG IN',
                            style: TextStyle(
                                fontSize: 17,
                                color: kwhite,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        child: const Text(
                          "RESEND",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {},
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
