import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background Message: ${message.messageId}");
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _initLocalNotification();
    await _requestPermission();
    await getToken();

    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    /// FOREGROUND
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground notification received");
      _showNotification(message);
    });

    /// CLICK WHEN BACKGROUND
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked");
    });

    /// CLICK WHEN TERMINATED
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("App opened from notification");
    }
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission();
  }

  Future<void> getToken() async {
    String? token = await _messaging.getToken();
    print("FCM TOKEN: $token");
  }

  Future<void> _initLocalNotification() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: android,
    );

    await flutterLocalNotificationsPlugin.initialize(settings:
      initSettings,
    );
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'default_channel_id',
      'Default Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: message.notification?.title ?? "Title",
      body: message.notification?.body ?? "Body",
      notificationDetails: details,
    );
  }
}