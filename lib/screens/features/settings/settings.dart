import 'package:flutter/material.dart';
import 'package:safe_encrypt/constants/colors.dart';
import 'package:safe_encrypt/screens/features/auth/components/pin_number/first_pin_number.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kdarkblue,
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Advanced',
                        style: TextStyle(color: kliteblue, fontSize: 17),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(Icons.warning_outlined),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Text(
                              'Break-In alerts',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.vpn_key,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context, MaterialPageRoute(builder: (_) => const FirstPinNumber()), (Route<dynamic> route) => false);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              child: Text(
                                'Secret Door',
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(Icons.lock),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Text(
                              'Album Lock',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
                ),
                Card(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Info',
                        style: TextStyle(color: kliteblue, fontSize: 17),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.help,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Text(
                              'Help & support',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(Icons.info),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Text(
                              'Abouth',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
