import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

Future<void> onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  // display a dialog with the notification details, tap ok to go to another page
}

//private variable to check if Notification is already Selected;
bool _isNotificationSelected = false;

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {

  final prefs = await SharedPreferences.getInstance();
  var companyId = prefs.getString('companyId');
  if (message.data != null) {
    print("on message ${message.data.toString()}");
    if(message.data['companyId'] == companyId.toUpperCase()){
      displayNotification(message.data);
    }
  }
}

Future onSelectNotification(String payload) async {
  if (!_isNotificationSelected) {
    _isNotificationSelected = true;
  } else {
    _isNotificationSelected = false;
  }
  return Future<void>.value();
}

Future displayNotification(Map<String, dynamic> message) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'user_dispatch_default_channel', 'flutterfcm', 'description',
      icon: 'mipmap/ic_launcher',
      playSound: true,
      importance: Importance.high,
      priority: Priority.high);

  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    message['title'],
    message['body'],
    platformChannelSpecifics,
    payload: 'item x',
  );
}

class PushNotificationService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void setUpFirebase() async {
    _firebaseMessaging.subscribeToTopic("TOPIC_USER");
    _firebaseMessaging.subscribeToTopic("TOPIC_ADMIN");
    firebaseCloudMessaging_Listeners();
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = await _firebaseMessaging.getToken();
    prefs.setString('fcmToken', token);
    return token;
  }

  Future<void> firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    // getToken().then((token) {
    //   print("Push Messaging token: $token");
    // });
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        final prefs = await SharedPreferences.getInstance();
        var companyId = prefs.getString('companyId');
        if (message.data != null) {
          // print("on message ${message.data.toString()}");
          if(message.data['companyId'] == companyId.toUpperCase()){
            displayNotification(message.data);
          }
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print("on message ${message.data.toString()}");
      });

      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    } catch (e, s) {
      print(s);
    }
  }

  void iOS_Permission() async {
    final bool result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    // FirebaseMessaging.instance.requestPermission(
    //     IosNotificationSettings(sound: true, badge: true, alert: true));
    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
  }
}
