import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'util/theme.dart';
import 'firebase_options.dart';
import 'page/splash_page/splash_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkTheme,
      home: const SplashPage(),
    );
  }
}