import 'package:chat_app/screens/chat_room.dart';
import 'package:chat_app/screens/people.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    ChatRoomPage(),
    PeoplePage(),
  ];

  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey.withOpacity(0.8),
          selectedFontSize: 0,
          unselectedFontSize: 0,
          elevation: 0,
          currentIndex: currentIndex,
          onTap: onTap,
          items: [
            BottomNavigationBarItem(
                label: 'Chats', icon: Icon(Icons.chat_rounded)),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'People'),
          ]),
    );
  }
}
