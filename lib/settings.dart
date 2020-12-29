import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/config.dart';
import 'package:news_app/login_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: () {
              Alert(
                context: context,
                type: AlertType.info,
                title: "Yazılımcı Hakkında",
                desc: "Yasin Reisoğlu",
                buttons: [
                  DialogButton(
                    child: Text(
                      "Tamam",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                    width: 120,
                  )
                ],
              ).show();
            },
            child: Text("Geliştirici Hakkında"),
          ),
          RaisedButton(
            onPressed: () {
              showLicensePage(context: context);
            },
            child: Text("Lisanslar"),
          ),
          RaisedButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (r) => false);
            },
            child: Text("Çıkış yap"),
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            child: Text("Version 1.0.0"),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          currentTheme.switchTheme();
        },
        label: Text("Tema değiştir"),
        icon: Icon(Icons.brightness_high),
      ),
    );
  }
}
