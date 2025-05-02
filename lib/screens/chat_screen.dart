import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_flutter/constants.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance; // 텍스트 DB에 저장하기 위함
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen'; // routes typo 예방

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController(); // 텍스트 순서 맞추기 위함
  final _firestore = FirebaseFirestore.instance; // 텍스트 DB에 저장하기 위함
  final _auth = FirebaseAuth.instance;
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
    } catch (e) {
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
  //
  // // 데이터를 1번만 가져오는 일반요청인 get과 다르게 stream으로 실시간 데이터 처리함.
  // // getMessages()를 쓰지않고 Stream을 쓴다. because Stream을 쓰면 데이터가 변경될 때마다 자동으로 push됨, 내가 firestore에서 pull하지 않아도 됌.
  // void messagesStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

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
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      // 이제 TextField를 컨트롤할 수 있다.
                      onChanged: (value) {
                        // 입력창에 입력된 글자를 실시간으로 콜백하는 함수
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear(); // 입력하면 기존 것 클리어됨
                      //Implement send functionality.
                      _firestore.collection('messages').add({
                        // map 형태임
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text('Send', style: kSendButtonTextStyle),
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

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // StreamBuilder 부분 어려움
      stream: _firestore.collection('messages').orderBy('timestamp').snapshots(), // 시간 순서로 정렬
      builder: (context, snapshot) {
        // 스냅샷에 데이터가 없을 경우
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed; // 메세지 밑에서부터 보이게 가져오기
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageData = message.data() as Map<String, dynamic>;
          final messageText = messageData['text'];
          final messageSender = messageData['sender'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            // ListView
            reverse: true, // 반대방향으로 추가
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );

        return Center(child: CircularProgressIndicator()); // 에러나서 추가했음 일단.
      },
    );
  }
}

// 메세지 디자인
class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String? sender;
  final String? text;
  final bool? isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        // 유저에 따흔 오른쪽 배치
        children: [
          Text(
            sender!,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            borderRadius: // 유저에 따른 메세지 박스 변화
                isMe!
                    ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    )
                    : BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
            elevation: 5.0,
            color: isMe! ? Colors.lightBlueAccent : Colors.white,
            // 유저 확인 후 색깔 변화
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text!,
                style: TextStyle(
                  color: isMe! ? Colors.white : Colors.black54,
                  // 유저 구별해서 색깔 변경
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
