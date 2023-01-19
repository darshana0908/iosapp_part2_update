import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_encrypt/constants/colors.dart';
import 'package:safe_encrypt/screens/features/auth/components/pin_number/re_enter_pin_number.dart';

import '../pin_key_pad.dart';

class FirstPinNumber extends StatefulWidget {
  const FirstPinNumber({Key? key}) : super(key: key);

  @override
  State<FirstPinNumber> createState() => _FirstPinNumberState();
}

class _FirstPinNumberState extends State<FirstPinNumber> {
  final TextEditingController controler_pin = TextEditingController();
  bool backspacecolorchange = true;
  var formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  bool textLength = false;
  int x = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controler_pin.addListener(textListener);
  }

  textListener() {
    if (controler_pin.text.length < 4) {
      setState(() {
        x = 3;
      });
      print("Current");
      print(x);
    }
    if (controler_pin.text.length > 7) {
      print("Currentff");
      setState(() {
        x = 4;
      });
    } else {
      setState(() {
        x = 5;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kdarkblue,
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
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
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Let's get you set up.\n First, choose a PIN",
                        style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 6 * 0.5),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: TextField(
                          maxLength: 7,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          textAlign: TextAlign.center,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: TextStyle(color: kwhite, fontSize: 60),
                          controller: controler_pin,
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (String value) {
                            var result = value;
                            print(result);
                          },
                          decoration: InputDecoration(
                            errorText: x == 1
                                ? ""
                                : x == 5
                                    ? "required a number between  4  and 7 "
                                    : 'required maximum 7 characters',
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.backspace_rounded,
                                color: backspacecolorchange ? Colors.white60 : kwhite,
                              ),
                              onPressed: () {
                                controler_pin.text = controler_pin.text.substring(0, controler_pin.text.length - 1);
                                setState(() {
                                  x = 1;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PinKeyPad(
                              keypad: '1',
                              click: () {
                                setState(() {
                                  backspacecolorchange = false;

                                  controler_pin.text = '${controler_pin.text}1';
                                });
                              }),
                          PinKeyPad(
                              keypad: '2',
                              click: () {
                                setState(() {
                                  backspacecolorchange = false;

                                  controler_pin.text = '${controler_pin.text}2';
                                });
                              }),
                          PinKeyPad(
                              keypad: '3',
                              click: () {
                                setState(() {
                                  backspacecolorchange = false;

                                  controler_pin.text = '${controler_pin.text}3';
                                });
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PinKeyPad(
                              keypad: '4',
                              click: () {
                                setState(() {
                                  backspacecolorchange = false;

                                  controler_pin.text = '${controler_pin.text}4';
                                });
                              }),
                          PinKeyPad(
                              keypad: '5',
                              click: () {
                                setState(() {
                                  backspacecolorchange = false;

                                  controler_pin.text = '${controler_pin.text}5';
                                });
                              }),
                          PinKeyPad(
                              keypad: '6',
                              click: () {
                                setState(() {
                                  backspacecolorchange = false;

                                  controler_pin.text = '${controler_pin.text}6';
                                });
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PinKeyPad(
                              keypad: '7',
                              click: () {
                                setState(() {
                                  backspacecolorchange = false;

                                  controler_pin.text = '${controler_pin.text}7';
                                });
                              }),
                          PinKeyPad(
                              keypad: '8',
                              click: () {
                                setState(() {
                                  backspacecolorchange = false;

                                  controler_pin.text = '${controler_pin.text}8';
                                });
                              }),
                          PinKeyPad(
                              keypad: '9',
                              click: () {
                                setState(() {
                                  backspacecolorchange = false;

                                  controler_pin.text = '${controler_pin.text}9';
                                });
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            '',
                            style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 20),
                          PinKeyPad(
                              keypad: '0',
                              click: () {
                                setState(() {
                                  backspacecolorchange = false;

                                  controler_pin.text = '${controler_pin.text}0';
                                });
                              }),
                          const SizedBox(
                            width: 65,
                          ),
                          IconButton(
                            onPressed: () {
                              if (controler_pin.text.length > 3 && controler_pin.text.length < 8) {
                                print(controler_pin.text.length);
                                if (controler_pin.text.isNotEmpty) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReEnterPin(controler_pin: controler_pin),
                                      ));
                                }
                              } else {
                                print('required between  4  and 7 numbers');
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Container(
                                      alignment: Alignment.center,
                                      height: 110,
                                      child: Column(
                                        children: [
                                          Text(
                                            'required a number \nbetween 4  and 7 !',
                                            style: TextStyle(
                                              color: kred,
                                              fontSize: 24,
                                            ),
                                          ),
                                          TextButton(
                                            child: const Text(
                                              'OK',
                                              style: TextStyle(fontSize: 25),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.white60,
                              size: 45,
                            ),
                          ),
                          const SizedBox(
                            width: 34,
                          )
                        ],
                      )
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
