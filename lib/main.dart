import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat_flutter/screens/chat_screen.dart';
import 'package:flash_chat_flutter/screens/login_screen.dart';
import 'package:flash_chat_flutter/screens/registration_screen.dart';
import 'package:flash_chat_flutter/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  // to use firebase, need to initialize.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}
class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark().copyWith(
      //   // copyWith : 기존 테마를 커스터마이징함.
      //   textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black54)),
      // ),
      // home: WelcomeScreen(), : due to initalRoutes, no need 'home'.

      // routes
      initialRoute: WelcomeScreen.id, // initial start
      routes: {
        // id를 static로 선언해서, WelcomeScreen.id로 객체생성 없이 클래스 이름에 바로 접근이 가능하다.
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
