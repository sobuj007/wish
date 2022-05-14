import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

class Messaging {
  static final Client client = Client();
  static const String serverKey =
      'AAAAWnfs3mQ:APA91bGTTnGhHnlrAZC-eXn4bJmJOKOXPQ7eXiAuSHeM4oOFbVCgBsWAqIqQ2hJDMD1E9uYPVjW5_TxeMkap3VDgG21lUgqEBeXEH2Osns0ANBJULNjmIvfXcYDdYvUKvFBFn596eMT-';

  static Future<Response> sendToAll({
    required String title,
    required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic(
          {required String title,
          required String body,
          required String topic}) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    required String title,
    required String body,
    required String fcmToken,
  }) =>
      client.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}
