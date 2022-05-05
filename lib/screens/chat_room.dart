import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/screens/conversation.dart';
import 'package:chat_app/screens/profile.dart';
import 'package:chat_app/screens/search_delegate.dart';
import 'package:chat_app/services.dart/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class ChatRoomPage extends StatefulWidget {
  ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  CollectionReference chats = FirebaseFirestore.instance.collection('ChatRoom');
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    String uid = _auth.currentUser!.uid;
    UserProvider userProvider = Provider.of(context);
    userProvider.getUserData();

    var userData = userProvider.currentUserData;
    var chatId;
    var lastMessageDate;

    String truncate(String text, {length: 26, omission: '...'}) {
      if (length >= text.length) {
        return text;
      }
      return text.replaceRange(length, text.length, omission);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('CHAT'),
        elevation: 0,
        actions: [
          // IconButton(onPressed: () {}, icon: Icon(Icons.search)),
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
        child: userData!.name == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: chats
                    .orderBy('lastMessageTS', descending: true)
                    // .where('usersID.$uid', isNull: true)
                    // .where('userID', arrayContains: uid, isNull: true)
                    .where('usersIDList', arrayContains: uid)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        Map<String, dynamic> name = ds['users'];
                        name.remove(uid);
                        String myName = userData.name!;

                        chatId = ds.id;

                        List<String> temp = List.from(ds['usersIDList']);

                        for (var i = 0; i < temp.length; i++) {
                          if (temp[i] == "$uid") {
                            int index = i;
                          }
                        }
                        temp.removeAt(index);

                        lastMessageDate = DateFormat.jm()
                            .format(ds['lastMessageTS'].toDate());

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConversationScreen(
                                    userName: name.values.first,
                                    chatRoomID: chatId,
                                    friendID: temp[0],
                                  ),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${toBeginningOfSentenceCase(name.values.first)}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 46.h),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Row(
                                            children: [
                                              ds['lastMessageUID'] == uid
                                                  ? Container()
                                                  : Icon(
                                                      Icons.check_rounded,
                                                      size: 50.r,
                                                    ),
                                              Expanded(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  truncate(ds['lastMessage']),
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                ),
                                              )),
                                              Text(
                                                lastMessageDate,
                                                style:
                                                    TextStyle(fontSize: 40.h),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Icon(Icons.arrow_forward_ios),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text('No Data'),
                    );
                  }
                },
              ),
      ),
    );
  }
}
