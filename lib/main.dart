import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:samadhantra/samadhantra_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_service.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  /// ✅ Init notification service
  await NotificationService().init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}
