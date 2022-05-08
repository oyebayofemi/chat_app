import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/screens/conversation.dart';
import 'package:chat_app/screens/profile.dart';
import 'package:chat_app/screens/search_delegate.dart';
import 'package:chat_app/services.dart/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PeoplePage extends StatefulWidget {
  PeoplePage({Key? key}) : super(key: key);

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  bool isloading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  CollectionReference chats = FirebaseFirestore.instance.collection('ChatRoom');
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference _tokensDB =
      FirebaseFirestore.instance.collection('Tokens');

  var chatID;

  createChatRoom(
    String userName,
    String myName,
    String friendID,
    String friendURL,
    String friendToken,
  ) async {
    String chatRoomID = getChatRoomID(userName, myName);
    String uid = _auth.currentUser!.uid;

    List<String> users = [userName, myName];
    List<String> usersIDList = [friendID, uid];

    Map<String, dynamic> chatRoomMap = {
      'users': users,
      'chatRoomID': chatRoomID,
    };

    await chats
        .where('usersID', isEqualTo: {friendID: null, uid: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot snapshot) {
            if (snapshot.docs.isNotEmpty) {
              chatID = snapshot.docs.single.id;
            } else {
              // chatID = chatRoomID;
              // DatabaseService().createChatRoom(chatRoomID, chatRoomMap);
              // chats.doc(chatRoomID).set({
              //   'usersID': {friendID, uid}
              // });

              chats.doc(chatRoomID).set({
                'usersID': {uid: null, friendID: null},
                'users': {uid: myName, friendID: userName},
                'usersIDList': usersIDList,
                'chatID': chatRoomID,
                'friendPhotoURL': friendURL,
                'token': friendToken,
              });
              chatID = chatRoomID;
              // chats.add({
              //   'usersID': {uid: null, friendID: null},
              //   'users': users,
              // }).then((value) => chatID = value);
            }
          },
        )
        .catchError((error) {});

    setState(() {
      isloading = false;
    });
    print(chatID);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationScreen(
            userName: userName,
            chatRoomID: chatID,
            friendID: friendID,
            friendtoken: friendToken,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of(context);
    userProvider.getUserData();

    var userData = userProvider.currentUserData;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 300.h,
        backgroundColor: Colors.transparent,
        title: Text(
          'People',
          // style: TextStyle(height: 20.h, color: Colors.black),
        ),
        titleTextStyle: TextStyle(
            fontSize: 100.sp, fontWeight: FontWeight.bold, color: Colors.black),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showSearch(context: context, delegate: searchDelegate());
          },
          child: Icon(Icons.search)),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionReference
            .where('id', isNotEqualTo: currentUser)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wromg'),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.docs.length == 0 ||
                snapshot.data!.docs.length == null) {
              return Container(
                child: Center(
                  child: Text('No people'),
                ),
              );
            } else {
              return isloading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot dsnapshot =
                              snapshot.data!.docs[index];
                          final String username = dsnapshot['name'];
                          final String email = dsnapshot['email'];
                          final String friendID = dsnapshot['id'];

                          final String url = dsnapshot['pictureModel'];

                          final String token = dsnapshot['token'];
                          // var data = getFriendToken(friendID);
                          // print(data);

                          // var data;

                          // _tokensDB
                          //     .where("userID", isEqualTo: friendID)
                          //     .get()
                          //     .then((QuerySnapshot querySnapshot) {
                          //   querySnapshot.docs.forEach((value) {
                          //     data = value.get('token');
                          //   });
                          // });

                          return url == null
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Card(
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                            backgroundImage: NetworkImage(url)),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 8, 0, 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('$username'),
                                                Text('$email')
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isloading = true;
                                            });
                                            createChatRoom(
                                              username,
                                              userData!.name!,
                                              friendID,
                                              url,
                                              token,
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.green[300],
                                              borderRadius:
                                                  BorderRadius.circular(50.r),
                                            ),
                                            // color: Colors.green,
                                            child: Text(
                                              'Message',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                        },
                      ),
                    );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

getChatRoomID(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return '$b\_$a';
  } else {
    return '$a\_$b';
  }
}
