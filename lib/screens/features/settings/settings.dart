import 'package:flutter/material.dart';
import 'package:safe_encrypt/constants/colors.dart';
import 'package:safe_encrypt/screens/features/auth/components/pin_number/first_pin_number.dart';
import 'package:safe_encrypt/screens/features/gallery/help_and_support/help_and_support.dart';

import '../../../utils/widgets/iCard.dart';

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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  const Divider(),
                  const SizedBox(height: 20),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const FirstPinNumber()),
                        );
                      },
                      child: ICard(text: 'Secret Door', icon: Icons.vpn_key)),
                  const Divider(),
                  const SizedBox(height: 20),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HelpSupportPage()),
                        );
                      },
                      child: ICard(
                        text: 'Help & Support',
                        icon: Icons.help,
                      )),
                  const Divider(),
                  const SizedBox(height: 20),
                  InkWell(
                      onTap: () {},
                      child: ICard(text: 'About', icon: Icons.info))
                ]),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
