import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  bool showSpinner = false;

  String email;
  String password;

  void tryRegister() async {
    setState(() {
      showSpinner = true;
    });
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      if (newUser != null) {
        try {
          _firestore.collection(kUsersCollection).doc(email.trim()).set({
            'name': email.trim(),
            'timestamp': DateTime.now().millisecondsSinceEpoch
          });
          _firestore
              .collection(kFriendslistsCollection)
              .doc(email.trim())
              .set({'user': email.trim(), 'friends': []});
        } catch (e) {
          print(e);
        }
        Navigator.pushNamed(context, MainScreen.id);
      }
      setState(() {
        showSpinner = false;
      });
    } on FirebaseAuthException catch (e) {
      //print(e.toString());
      setState(() {
        showSpinner = false;
      });
      showRegisterError(e.message);
    }
  }

  Future<void> showRegisterError(error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration failed'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kInputTextFieldDecoration.copyWith(
                      hintText: 'Enter your email')),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kInputTextFieldDecoration.copyWith(
                      hintText: 'Enter your password')),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                text: 'Register',
                onPressed: tryRegister,
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
