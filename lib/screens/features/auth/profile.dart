import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_encrypt/constants/colors.dart';

import 'components/pin_number/first_pin_number.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

FirebaseAuth auth = FirebaseAuth.instance;
final user = auth.currentUser;

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kdarkblue,
      body: SafeArea(
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
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Welcome !',
                  style: TextStyle(fontSize: 25, color: kwhite, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 40,
                ),
                CircleAvatar(backgroundImage: NetworkImage(user!.photoURL!, scale: 300)),
                const SizedBox(
                  height: 20,
                ),
                Text(user!.email!, style: const TextStyle(fontSize: 17, color: Colors.white60, fontWeight: FontWeight.w500)),
                const SizedBox(
                  height: 20,
                ),
                Text(user!.email!, style: const TextStyle(fontSize: 17, color: Colors.white60, fontWeight: FontWeight.w500)),
                const SizedBox(
                  height: 60,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FirstPinNumber()),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: kblue,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 17, color: kwhite, fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
