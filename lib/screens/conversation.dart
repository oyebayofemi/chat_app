import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/services.dart/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {
  String userName;
  String chatRoomID;
  ConversationScreen({required this.userName, required this.chatRoomID});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController message = TextEditingController();
  CollectionReference chats = FirebaseFirestore.instance.collection('ChatRoom');
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Widget ChatMessageList() {}

  sendMessage(String messageText) {
    var messageTimeStamp = DateTime.now().microsecondsSinceEpoch;
    if (message.text != '') {
      DatabaseService()
          .addMessage(widget.chatRoomID, messageText, _auth.currentUser!.uid,
              messageTimeStamp)
          .then((value) {
        DatabaseService().updateLastMessage(widget.chatRoomID, messageText,
            _auth.currentUser!.uid, messageTimeStamp);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.userName),
      ),
      body: StreamBuilder<QuerySnapshot?>(
          stream: chats
              .doc(widget.chatRoomID)
              .collection('messages')
              .orderBy('messageDate', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong'),
              );
            }
            if (snapshot.hasData) {
              var data;

              return Container(
                child: Stack(
                  children: [
                    Container(
                      child: ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot documentSnapshot) {
                          data = documentSnapshot.data()!;
                          return data == null
                              ? Center(
                                  child: Text('Enter a message'),
                                )
                              : Container(
                                  child: Text(data['message']),
                                );
                        }).toList(),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.green[50],
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: message,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      hintText: 'Type a message',
                                      //hintMaxLines: 300,
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                sendMessage(
                                  message.text,
                                );
                                message.clear();
                              },
                              child: Container(
                                child: Icon(
                                  Icons.send,
                                  color: Colors.green,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
