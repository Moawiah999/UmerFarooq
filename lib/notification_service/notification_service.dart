//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class FirebaseService {
//   static FirebaseMessaging? _firebaseMessaging;
//   static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
//
//   static Future<void> initializeFirebase() async {
//     _firebaseMessaging = FirebaseMessaging.instance;
//     _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: true,
//     );
//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//
//     await _flutterLocalNotificationsPlugin?.initialize(
//       initializationSettings,
//       onSelectNotification: (String? payload) async {
//         // Handle notification when tapped
//         print('Notification tapped: $payload');
//       },
//     );
//
//     configureFirebaseMessaging();
//   }
//
//   static void configureFirebaseMessaging() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("Received message: ${message.notification?.body}");
//
//       if (message.notification != null) {
//         showLocalNotification(message.notification!);
//       }
//     });
//   }
//
//   static void showLocalNotification(RemoteNotification notification) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'your_channel_id', 'your_channel_name', 'your_channel_description',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//
//     await _flutterLocalNotificationsPlugin?.show(
//       0,
//       notification.title,
//       notification.body,
//       platformChannelSpecifics,
//       payload: 'Default_Sound',
//     );
//   }
//
//   static void handleBackgroundMessage(Map<String, dynamic> message) {
//     if (message.containsKey('data')) {
//       // Handle data message in the background
//       final dynamic data = message['data'];
//       print('Handling background data message: $data');
//     }
//
//     if (message.containsKey('notification')) {
//       // Handle notification message in the background
//       final dynamic notification = message['notification'];
//       print('Handling background notification message: $notification');
//       showLocalNotification(RemoteNotification.fromJson(notification));
//     }
//   }
//
//   static Future<void> subscribeToTopic(String topic) async {
//     await _firebaseMessaging?.subscribeToTopic(topic);
//   }
//
//   static Future<void> unsubscribeFromTopic(String topic) async {
//     await _firebaseMessaging?.unsubscribeFromTopic(topic);
//   }
//
//   static FirebaseMessaging? get firebaseMessaging => _firebaseMessaging;
// }
