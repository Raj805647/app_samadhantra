import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:samadhantra/samadhantra_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

/*@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage msg) async{
  await Firebase.initializeApp();
  print("fgfd");
  print(msg.notification!.title.toString());
  print(msg.notification!.body.toString());
  print(msg.data.toString());
}*/
