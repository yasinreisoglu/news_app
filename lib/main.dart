import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_app/config.dart';
import 'package:news_app/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      print('changes');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: currentTheme.currentTheme(),
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
      title: 'News App',
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
