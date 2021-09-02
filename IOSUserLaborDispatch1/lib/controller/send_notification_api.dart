import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configs/app_strings.dart';
import '../model/notification.dart';

class SendNotificationApi {
  var url = 'https://fcm.googleapis.com/fcm/send';

  Future<String> sendNotification(NotificationModel notification) async {

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=${AppConstants.cloudMessagingServerToken}',
    };

    // var fcmToken = prefs.getString('fcmToken');
    Map send = {
      'title': notification.title,
      'body': notification.body,
      'companyId': notification.companyId
    };

    Map data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'title': notification.title,
      'body': notification.body,
      'companyId': notification.companyId
    };

    Map body = {
      'to': AppConstants.TOPIC_ADMIN,
      'notification': send,
      'data': data,
      'priority': 'high'
    };

    try {
      final http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (exception) {
      print(exception.toString());
    }
    return null;
  }
}
