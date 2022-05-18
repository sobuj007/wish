import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

class Messaging {
  String keys =
      "AAAAQqrcf8Y:APA91bFV0_ezt5MKYEo7zwc0M55B_rpvh5mM1mE65oH8SknNGNYtuutaphMdn0OvsO14_VYDfNiAu7sPcF5JZfhD-ZiF5WZbsqjoXwK-BY3bZklOqgckjElAThe9xy9U7Cb-O7LeAN6l";
  var request =
      http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));

  sendtoAll(title, messagedata) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$keys'
    };
    request.body = json.encode({
      "to": "/topics/all",
      "priority": "high",
      "sound": "true",
      "notification": {
        "title": "$title",
        "body": "$messagedata",
        "text": "Text"
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  sendtoTopics(title, messagedata, topic) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$keys'
    };
    request.body = json.encode({
      "to": "/topics/$topic",
      "priority": "high",
      "sound": "true",
      "notification": {
        "title": "$title",
        "body": "$messagedata",
        "text": "Text"
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  sendtoSingel(title, messagedata, fcm) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAQqrcf8Y:APA91bFV0_ezt5MKYEo7zwc0M55B_rpvh5mM1mE65oH8SknNGNYtuutaphMdn0OvsO14_VYDfNiAu7sPcF5JZfhD-ZiF5WZbsqjoXwK-BY3bZklOqgckjElAThe9xy9U7Cb-O7LeAN6l'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to": "$fcm",
      "priority": "high",
      "sound": "true",
      "notification": {
        "title": "$title",
        "body": "$messagedata",
        "text": "Text"
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
