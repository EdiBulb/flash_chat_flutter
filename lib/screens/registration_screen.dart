import 'package:flash_chat_flutter/components/rounded_button.dart';
import 'package:flash_chat_flutter/screens/chat_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 파이어베이스 auth
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart'; // 로딩 스피너 패키지


class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen'; // routes typo 예방

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance; // _auth: 다른 클래스에서 접근 불가하게 private.

  bool showSpinner = false; // 로딩 스피너 존재 여부
  // Use for Firebase.
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner, // showSpinner가 false 이므로 안보임.
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
              SizedBox(height: 48.0),
              TextField(
                keyboardType: TextInputType.emailAddress, // email type keyboard로 기본 설정
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  // copyWith: 커스터마이징
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
                title: 'Register',
                colour: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true; // 버튼을 누르면 spinner 시작
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(email: email!, password: password!);
                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      showSpinner = false; // 로그인 되면 spinner 사라짐
                    });
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
      ),
    );
  }
}
