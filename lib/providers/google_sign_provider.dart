import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;
  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    // print(_user!.email);
    // print(_user!.displayName);

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    notifyListeners();
  }

  String profileImage = '';
  String get getProfileImageFront => profileImage;

  void setProfileFront(String val) {
    profileImage = val;
    notifyListeners();
  }

  Future<String> getProfileImage(String pin) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    String? newPath = prefs.getString(pin);
    // print("------------------------------------");
    // print(pin);
    // print("------------------------------------");

    setProfileFront(newPath!);

    return newPath;
  }

  Future<void> setProfileImage(String pin, String imagePath) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(pin, imagePath);
    print("------------------------------------");
    print(pin);
    print(imagePath);
    print("------------------------------------");
    setProfileFront(imagePath);
  }
}
