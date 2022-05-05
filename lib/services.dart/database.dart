import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference chats = FirebaseFirestore.instance.collection('ChatRoom');
  createChatRoom(String chatRoomID, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomID)
        .set(chatRoomMap);
  }

  Future addMessage(String chatRoomID, String messageText, String uid,
      var messageTimeStamp) async {
    chats.doc(chatRoomID).collection('messages').add({
      'messageDate': messageTimeStamp,
      'message': messageText,
      'uid': uid,
    });
  }

  updateLastMessage(
      String chatRoomID, String messageText, String uid, var messageTimeStamp) {
    chats.doc(chatRoomID).update({
      'lastMessageTS': messageTimeStamp,
      'lastMessage': messageText,
      'lastMessageUID': uid,
    });
  }
}
