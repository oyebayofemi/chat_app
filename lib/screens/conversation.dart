import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/services.dart/database.dart';
import 'package:chat_app/shared/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ConversationScreen extends StatefulWidget {
  String userName;
  String friendID;
  String chatRoomID;
  ConversationScreen(
      {required this.userName,
      required this.chatRoomID,
      required this.friendID});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController message = TextEditingController();
  CollectionReference chats = FirebaseFirestore.instance.collection('ChatRoom');
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Widget ChatMessageList() {}

  sendMessage(String messageText) {
    var messageTimeStamp = FieldValue.serverTimestamp();
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

  bool isSender(String friendID) {
    return friendID == _auth.currentUser!.uid;
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
              var dateNow = DateFormat.jm().format(DateTime.now());
              var date;

              return Container(
                child: Stack(
                  children: [
                    Container(
                      child: ListView(
                        reverse: true,
                        padding: EdgeInsets.only(bottom: 70, top: 16),
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot documentSnapshot) {
                          data = documentSnapshot.data()!;
                          if (data['messageDate'] != null) {
                            date = DateFormat.jm()
                                .format(data['messageDate'].toDate());
                          }
                          return data['messageDate'] == null
                              ? Center(
                                  child: Container(
                                      height: 20.h,
                                      width: 20.w,
                                      child: CircularProgressIndicator()),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      isSender(data['uid'].toString())
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color:
                                              isSender(data['uid'].toString())
                                                  ? Colors.green[100]
                                                  : Colors.grey[100],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50.r),
                                            topRight: Radius.circular(50.r),
                                            bottomRight:
                                                isSender(data['uid'].toString())
                                                    ? Radius.circular(0.r)
                                                    : Radius.circular(50.r),
                                            bottomLeft:
                                                isSender(data['uid'].toString())
                                                    ? Radius.circular(50.r)
                                                    : Radius.circular(0.r),
                                          )),
                                      padding: EdgeInsets.all(16),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 22.h, vertical: 10.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            isSender(data['uid'].toString())
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    84),
                                            child: Text(
                                              data['message'],
                                              //overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                          Container(
                                            // color: Colors.red,
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              date,
                                              style: conversationDateText(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
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
