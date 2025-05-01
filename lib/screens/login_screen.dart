import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_flutter/components/rounded_button.dart';
import 'package:flash_chat_flutter/constants.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen'; // routes typo 예방

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth = FirebaseAuth.instance; // _auth: 다른 클래스에서 접근 불가하게 private.

  // Use for Firebase.
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Hero Widget
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(height: 48.0),
            TextField(
              keyboardType: TextInputType.emailAddress, // email type keyboard로 기본 설정
              textAlign: TextAlign.center,
              onChanged: (value) { // TextField에 적힌 값을 사용할 수 있다.
                //Do something with the user input.
                email = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your Email',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                //Do something with the user input.
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(height: 24.0),
            RoundedButton(
              title: 'Log In',
              colour: Colors.redAccent,
              onPressed: () async {
                try {
                  final existingUser = await _auth.signInWithEmailAndPassword(email: email!, password: password!);
                  if (existingUser != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                }
                catch (e) {
                  print(e);
                }
                // print(email);
                // print(password);
              },
            ),
          ],
        ),
      ),
    );
  }
}
