import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;

import 'dart:io';

abstract class IFCMNotificationService {
  Future<void> sendNotificationToUser(
      {required String fcmToken, required String title, required String body});
}

class FCMNotificationService extends IFCMNotificationService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final String _endpoint = 'https://fcm.googleapis.com/fcm/send';
  final String _contentType = 'application/json';
  final String _authorization =
      'key=AAAALhHlfdc:APA91bGbk4z0-S0CQxvU73wdeNRCG5H0v1Hzv_Dcm3bMAqwPNtJABpTa4sjGXCbcE9kzIEBeYGXe9Jc7ZmwTzULnCbW2E1eN2ZpmqC4RX63BdfcsCp00b4wUSc3_RPIxyjbXJS3-3AVi';

  Future<http.Response> _sendNotification(
      String to, String title, String body) async {
    try {
      dynamic data = json.encode(
        {
          'to': to,
          'priority': 'high',
          'notification': {
            'title': title,
            'body': body,
          },
          'content_available': true,
        },
      );
      http.Response response = await http.post(
        Uri.parse(_endpoint),
        body: data,
        headers: {
          'Content-Type': _contentType,
          'Authorization': _authorization
        },
      );

      return response;
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<void> sendNotificationToUser({
    required String fcmToken,
    required String title,
    required String body,
  }) {
    return _sendNotification(
      fcmToken,
      title,
      body,
    );
  }
}

// class PushNotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;

//   void initialize() {
//     if (Platform.isIOS) {
//       // _fcm.requestNotificationPermissions(IosNotificationSettings());
//       _fcm.requestPermission();
//     }
//     _fcm.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         // _showItemDialog(message);
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         // _navigateToItemDetail(message);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//         // _navigateToItemDetail(message);
//       },
//     );
//   }
// }
