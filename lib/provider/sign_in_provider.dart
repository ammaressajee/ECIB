import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider extends ChangeNotifier {
  //instance of firebase auth
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  SignInProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  Future signInWihGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // singing to firebase user instance
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        _name = userDetails.displayName;
        _email = userDetails.email;
        _uid = userDetails.uid;
        _imageUrl = userDetails.photoURL;
        _provider = "GOOGLE";
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You aleready have an account with the same email address";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _errorCode =
                "An unexpected error occurred while trying to sign in.";
            _hasError = true;
            break;

          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

// sign user out
  Future userSignOut() async {
    await firebaseAuth.signOut;
    await googleSignIn.signOut();

    _isSignedIn = false;
    notifyListeners();
    // clear saved data
    clearStoredData();
  }

  // clear saved data from shared preferense
  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
  }

  // get entries from firestore
  Future getUserDataFromFirestore(String? uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
              _uid = snapshot["uid"],
              _name = snapshot["name"],
              _email = snapshot["email"],
              _imageUrl = snapshot["imageUrl"],
              _provider = snapshot["provider"],
            });
  }

  // save data to firestore
  Future saveDataToFirestore() async {
    final DocumentReference r =
        FirebaseFirestore.instance.collection("users").doc(_uid);
    await r.set({
      "name": _name,
      "email": _email,
      "imageUrl": _imageUrl,
      "provider": _provider,
      "uid": _uid,
    });
    notifyListeners();
  }

  // save data to shared preferences
  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString('name', _name!);
    await s.setString('email', _email!);
    await s.setString('uid', _uid!);
    await s.setString('image_url', _imageUrl!);
    await s.setString('provider', _provider!);
    notifyListeners();
  }

  // get data from shared preferences
  Future getUserDataFromSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString("name");
    _email = s.getString("email");
    _uid = s.getString("uid");
    _imageUrl = s.getString("image_url");
    _provider = s.getString("provider");
    notifyListeners();
  }

  // check if user exists in cloud firestore
  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();

    if (snap.exists) {
      print("User already exists");
      return true;
    } else {
      print("New user");
      return false;
    }
  }
}
