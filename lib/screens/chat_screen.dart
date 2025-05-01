import 'package:flash_chat_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen'; // routes typo 예방

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance; // 텍스트 DB에 저장하기 위함
  final _auth= FirebaseAuth.instance;
  late User loggedInUser;
  String? messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser(); // State 시작할 때, 유저 받는다.
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser.email); // 로그인 된 유저의 이메일 정보를 print한다.
      }
    } catch(e) {
      print(e);
    }
  }
  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get(); // messages를 db에서 가져오는 함수
  //   //messages 데이터의 value를 확인
  //   for (var message in messages.docs){
  //     print(message.data());
  //   }
  // }

  // 데이터를 1번만 가져오는 일반요청인 get과 다르게 stream으로 실시간 데이터 처리함.
  // getMessages()를 쓰지않고 Stream을 쓴다. because Stream을 쓰면 데이터가 변경될 때마다 자동으로 push됨, 내가 firestore에서 pull하지 않아도 됌.
  void messagesStream() async {
    await for( var snapshot in _firestore.collection('messages').snapshots()){
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                // _auth.signOut();
                // Navigator.pop(context);
                messagesStream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>( // StreamBuilder 부분 어려움
                stream: _firestore.collection('messages').snapshots(),
                builder: (context, snapshot){
                  // 스냅샷에 데이터가 없을 경우
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                    final messages = snapshot.data!.docs;
                    List<Text> messageWidgets = [];
                    for (var message in messages) {
                      final messageData = message.data() as Map<String, dynamic>;
                      final messageText = messageData['text'];
                      final messageSender = messageData['sender'];

                      final messageWidget = Text('$messageText from $messageSender');
                      messageWidgets.add(messageWidget);
                    }
                    return Column(
                      children: messageWidgets,
                    );

                  return Center(child: CircularProgressIndicator()); // 에러나서 추가했음 일단.

                },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) { // 입력창에 입력된 글자를 실시간으로 콜백하는 함수
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      _firestore.collection('messages').add({ // map 형태임
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
