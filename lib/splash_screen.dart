import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/config.dart';

import 'login_page.dart';
import 'news_page.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      print("change");
      setState(() {});
    });
    Future.delayed(const Duration(seconds: 3), () async {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => FirebaseAuth.instance.currentUser == null
                  ? LoginPage()
                  : NewsPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 200,
                height: 200,
                child: Image(image: AssetImage('images/reading.png'))),
            Container(
              margin: EdgeInsets.all(15.0),
              child: Text(
                "News App",
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
