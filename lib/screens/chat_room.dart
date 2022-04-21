import 'package:chat_app/services.dart/auth_service.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('data'),
            FlatButton(
                onPressed: () {
                  AuthService().signout();
                },
                child: Text('Logout'))
          ],
        ),
      ),
    );
  }
}
