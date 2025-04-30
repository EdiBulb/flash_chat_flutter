import 'package:flutter/material.dart';

// Refactoring: 코드양 줄이고 더 효율적으로 쓰기 위해서. // 컴포넌트를 만들어놓으면 편하구나!(버튼 같은 거)
// 리팩토링은 필수다!!

class RoundedButton extends StatelessWidget {
  RoundedButton({this.title, this.colour, required this.onPressed});

  final Color? colour;
  final String? title;
  final VoidCallback?
  onPressed; // 가능하면 Function 보다는 정확한 타입인 VoidCallback을 쓰는 게 좋다.

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        // 버튼 대신 Material로 버튼을 그릴 수 있나봄.
        elevation: 5.0,
        color: colour, // colour로 대체
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          //Go to login screen.
          // Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
          // Navigator.pushNamed(
          //   context,
          //   LoginScreen.id,
          // ); // pushNamed: 미리 등록한 경로 이름만 사용.
          minWidth: 200.0,
          height: 42.0,
          child: Text(title!, style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}