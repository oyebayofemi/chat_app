import 'package:chat_app/screens/profile.dart';
import 'package:chat_app/screens/search_delegate.dart';
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
      appBar: AppBar(
        title: Text('CHAT'),
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          PopupMenuButton(
            color: Colors.white,
            onSelected: (value) {
              if (value == 1) {
                AuthService().signout();
              }
              if (value == 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ));
              }
            },
            icon: Icon(Icons.more_vert_rounded),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text('My Profile'),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text('Sign Out'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text('data'),
          ],
        ),
      ),
    );
  }
}
