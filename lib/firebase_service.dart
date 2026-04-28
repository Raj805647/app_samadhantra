import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// ✅ Background handler (must be top-level)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("=== BACKGROUND MESSAGE ===");
  print("ID: ${message.messageId}");
  print("TITLE: ${message.notification?.title}");
  print("BODY: ${message.notification?.body}");
  print("DATA: ${message.data}");
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _initLocalNotification();
    await _requestPermission();
    await _createNotificationChannel();
    await getToken();

    /// ✅ Background handler
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    /// ✅ Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("=== FOREGROUND MESSAGE ===");
      print("ID: ${message.messageId}");
      print("TITLE: ${message.notification?.title}");
      print("BODY: ${message.notification?.body}");
      print("DATA: ${message.data}");

      _showNotification(message);
    });

    /// ✅ Click when app in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("=== CLICK (BACKGROUND) ===");
      print("ID: ${message.messageId}");
      print("DATA: ${message.data}");
    });

    /// ✅ Click when app terminated
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("=== CLICK (TERMINATED) ===");
      print("ID: ${initialMessage.messageId}");
      print("DATA: ${initialMessage.data}");
    }
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission();
  }

  Future<void> getToken() async {
    String? token = await _messaging.getToken();
    print("FCM TOKEN: $token");
  }

  /// ✅ Init local notification
  Future<void> _initLocalNotification() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await flutterLocalNotificationsPlugin.initialize(settings: settings);
  }

  /// ✅ Create channel (IMPORTANT for Android 8+)
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel_id',
      'Default Notifications',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// ✅ Show notification (foreground)
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
     id:  0,
     title:  message.notification?.title ?? message.data['title'] ?? "No Title",
     body:  message.notification?.body ?? message.data['body'] ?? "No Body",
     notificationDetails:  details,
    );
  }
}