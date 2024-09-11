// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initialize() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings();
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> showNotification(RemoteMessage message) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'safewalk_channel',
//       'SafeWalk Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title ?? 'New Notification',
//       message.notification?.body ?? '',
//       platformChannelSpecifics,
//       payload: message.data['payload'],
//     );
//   }
// }
//part2
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class NotificationService {
//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   void initialize() {
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//       iOS: DarwinInitializationSettings(),
//     );

//     _notificationsPlugin.initialize(
//       initializationSettings,
//     );
//   }

//   void showNotification(RemoteMessage message) {
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: AndroidNotificationDetails(
//         'default_notification_channel_id', // Channel ID
//         'Default', // Channel Name
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//       iOS: DarwinNotificationDetails(),
//     );

//     _notificationsPlugin.show(
//       0, // Notification ID
//       message.notification?.title,
//       message.notification?.body,
//       notificationDetails,
//     );
//   }
// }

//part3
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class NotificationService {
//   final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initialize() async {
//     // Initialize local notifications
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//       iOS: DarwinInitializationSettings(),
//     );

//     await _notificationsPlugin.initialize(initializationSettings);

//     // Initialize FCM
//     await _firebaseMessaging.requestPermission();

//     // Get the token each time the application loads
//     String? token = await _firebaseMessaging.getToken();
//     print("FCM Token: $token");

//     // Any time the token refreshes, store this in your database too.
//     _firebaseMessaging.onTokenRefresh.listen(saveTokenToDatabase);

//     // Handle incoming messages when the app is in the foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("Got a message whilst in the foreground!");
//       print("Message data: ${message.data}");

//       if (message.notification != null) {
//         print("Message also contained a notification: ${message.notification}");
//         showNotification(message);
//       }
//     });
//   }

//   void saveTokenToDatabase(String token) {
//     // TODO: Implement this method to save the token to your backend database
//     print("FCM token: $token");
//   }

//   void showNotification(RemoteMessage message) {
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: AndroidNotificationDetails(
//         'default_notification_channel_id', // Channel ID
//         'Default', // Channel Name
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//       iOS: DarwinNotificationDetails(),
//     );

//     _notificationsPlugin.show(
//       0, // Notification ID
//       message.notification?.title,
//       message.notification?.body,
//       notificationDetails,
//     );
//   }

//   Future<void> sendPushMessage(String token, String title, String body) async {
//     try {
//       final response = await http.post(
//         Uri.parse(_fcmUrl),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $_serverKey',
//         },
//         body: jsonEncode(
//           <String, dynamic>{
//             'message': <String, dynamic>{
//               'token': token,
//               'notification': <String, dynamic>{
//                 'title': title,
//                 'body': body,
//               },
//               'android': <String, dynamic>{
//                 'notification': <String, dynamic>{
//                   'click_action': 'FLUTTER_NOTIFICATION_CLICK'
//                 }
//               },
//               'apns': <String, dynamic>{
//                 'payload': <String, dynamic>{
//                   'aps': <String, dynamic>{
//                     'category': 'NEW_MESSAGE_CATEGORY'
//                   }
//                 }
//               },
//             },
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         print('FCM request sent successfully. Response: ${response.body}');
//       } else {
//         print('Failed to send FCM request. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//       }
//     } catch (e) {
//       print('Error sending FCM request: $e');
//     }
//   }
// }
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();
    
    await _initializeLocalNotifications();

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = 
        AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _localNotifications.initialize(initializationSettings);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      showNotification(message);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print('Message opened app from background: ${message.data}');
    // TODO: Handle navigation based on message data
  }

  void showNotification(RemoteMessage message) {
    _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  // This method is kept for backwards compatibility, but it should not be used to send push messages directly from the app
  Future<void> sendPushMessage(String token, String title, String body) async {
    print('WARNING: sendPushMessage should not be called directly from the app. Use a server to send push notifications.');
    // Implement the logic to send a request to your server to send the push notification
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // You can process the message here if needed
}