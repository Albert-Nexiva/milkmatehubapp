import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:milkmatehub/firebase/firestore_db.dart';
import 'package:milkmatehub/models/notification_model.dart';
import 'package:milkmatehub/notification_helper.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await checkNotification(message.notification!.title.toString(),
      message.notification!.body.toString());

  // NotificationModel model = NotificationModel(
  //     title: message.notification!.title.toString(),
  //     description: message.notification!.body.toString());
  // // Navigation.push(AdminNotificationScreen());
  // final user = await CacheStorageService().getAuthUser();

  // await sendNotificationToDb(user!.uid, model);
}

class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission(
        sound: true,
        badge: true,
        alert: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // final fCMToken = await firebaseMessaging.getToken();
    // print('fcm token : $fCMToken');

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.notification != null) {
        // print("Background Notification tapped");
        if (message.notification!.title != "") {
          await checkNotification(message.notification!.title.toString(),
              message.notification!.body.toString());
        }
        // NotificationModel model = NotificationModel(
        //     title: message.notification!.title.toString(),
        //     description: message.notification!.body.toString());
        // final user = await CacheStorageService().getAuthUser();
        // await sendNotificationToDb(user!.uid, model);
      }
    });
    // FirebaseMessaging.
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // print('Received foreground message: ${message.notification!.title}');

      await checkNotification(message.notification!.title.toString(),
          message.notification!.body.toString());

      // NotificationModel model = NotificationModel(
      //     title: message.notification!.title.toString(),
      //     description: message.notification!.body.toString());
      // final user = await CacheStorageService().getAuthUser();

      // Navigation.push(AdminNotificationScreen());
      // await sendNotificationToDb(user!.uid, model);
      // Handle the received message here
    });
  }
}

Future<void> checkNotification(String title, String body) async {
  NotificationHelper.showNotification(title.toString(), body.toString());
}

Future<void> sendNotificationToDb(String uId, NotificationModel data) async {
  try {
    FirestoreDB()
        .storeNotifications(uId, data)
        .then((value) => print("Stored notification on db"));
  } catch (e) {
    print("error while uploading");
  }
}

Future<void> sendNotificationToUser(
    String uid, String title, String body, bool flag) async {
  final user = await FirestoreDB().getUser(uid, flag);
  String? userToken = user?['fcm'] ?? "";
  const String serverKey =
      'AAAAlerv9s0:APA91bHmGnDFTlwZC3D6_pVgpy0-6NjD3niDIc-VQa0VB5HJ7lhZLSznP6Ezv2PXpPz0AOl9Q05Y-gFAIE1TDWvTp718q7zuMPbuA5BDIZhgunMSeX-Gky0n7dFxEV_5AT414P-6PNJu';
  const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  final Map<String, dynamic> notification = {
    'title': title,
    'body': body,
    "sound": "custom_sound.mp3",
    "click_action": "FLUTTER_NOTIFICATION_CLICK",
    "icon": "app_icon"
  };
  final Map<String, dynamic> android = {
    "notification": {"channel_id": "important_notifications"}
  };
  final Map<String, dynamic> data = {
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    // You can add additional data to be sent along with the notification
    // 'key': 'value',
  };

  final Map<String, dynamic> requestBody = {
    'notification': notification,
    'data': data,
    'android': android,
    'to': userToken,
    "content_available": true,
    "priority": "high"
  };
  if (userToken != "") {
    try {
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        NotificationModel model = NotificationModel(
            title: title.toString(), description: body.toString());
        // final user = await CacheStorageService().getAuthUser();
        await sendNotificationToDb(uid, model);
        print('Notification sent successfully to $userToken');
      } else {
        print(
            'Failed to send notification. Error code: ${response.statusCode} Token: $userToken');
      }
    } catch (error) {
      // print('Error sending notification: $error');
    }
  } else {
    NotificationModel model = NotificationModel(
        title: title.toString(), description: body.toString());
    // final user = await CacheStorageService().getAuthUser();
    await sendNotificationToDb(uid, model);
    print('Notification sent successfully to $userToken');
  }
}
