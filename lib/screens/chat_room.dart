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
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: searchDelegate());
              },
              icon: Icon(Icons.search)),
          PopupMenuButton(
            color: Colors.white,
            onSelected: (value) {
              if (value == 0) {
                AuthService().signout();
              }
            },
            icon: Icon(Icons.more_vert_rounded),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
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
