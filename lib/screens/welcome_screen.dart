import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat_flutter/screens/login_screen.dart';
import 'package:flash_chat_flutter/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  // static: 객체를 만들지 않고 클래스 이름으로 바로 접근 가능(변하지 않는 값인 경우)
  // 객체를 만들지 않아도 되어서 더 효율적이다.
  static const String id = 'welcome_screen'; // routes typo 예방
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

// with SingleTickerProviderStateMixin 연장
class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  // 변하는 데이터는 State클래스에, 변하지 않는 데이터는 StatefulWidget 클래스에 선언함.
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    // controller
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    // Tween animation.
    animation = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white,
    ).animate(controller);

    // CurvedAnimation
    // animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.forward();

    // 반복함
    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });

    // addListener()가 뭐야?
    controller.addListener(() {
      setState(() {}); // 매순간 변화
    });
  }

  // dispose() ???
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold: 앱 화면의 기본 뼈대
      // backgroundColor: Colors.red.withOpacity(controller.value), // withOpacity: 투명도 조절
      // backgroundColor: Colors.white, // withOpacity: 투명도 조절
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                // Hero Widget: smooth screen transitiion .
                Hero(
                  tag: 'logo', // need to give same 'tag'
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    // height: animation.value *100,
                    height: 60.0,
                  ),
                ),
                // '${controller.value.toInt()}%', // 애니메이션 value를 이렇게 써먹을 수도 있다.
                DefaultTextStyle(
                  // 패키지에서 가져옴
                  style: const TextStyle(
                    fontSize: 45.0,
                    color: Colors.black,
                    fontFamily: 'Agne',
                    fontWeight: FontWeight.w900,
                  ),
                  child: AnimatedTextKit(
                    // doc에 사용법이 안나와있어도, Ctrl Q로 읽어봐라.
                    totalRepeatCount: 1, // 반복 횟수
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Flash Chat',
                        speed: Duration(milliseconds: 200), // speed.
                      ),
                    ],
                  ),
                ),

                // TypewriterAnimatedTextKit( // Flutter package: animated_text_kit, 패키지를 잘 써먹자.
                //   text: ['Flash Chat'],
                //   textStyle: TextStyle(
                //     fontSize: 45.0,
                //     fontWeight: FontWeight.w900,
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 48.0),
            // Padding 을 refactoring 함.
            RoundedButton(
              title: 'Log In',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: 'Sign Up',
              colour: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

