import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/news_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/register_page.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 25.0, 0, 50.0),
            child: Icon(
              Icons.login_outlined,
              size: 100,
              color: Colors.lightBlue,
            ),
          ),
          Card(
            elevation: 5.0,
            margin: EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: Text(
                    "E-mail ile giriş",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: new EdgeInsets.symmetric(vertical: 15.0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: _emailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "E-mail",
                            ),
                            validator: (String mail) {
                              if (mail.isEmpty) {
                                return "Lütfen bir email adresi yazınız";
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: new EdgeInsets.symmetric(vertical: 15.0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: "Parola",
                              border: OutlineInputBorder(),
                            ),
                            validator: (String mail) {
                              if (mail.isEmpty) {
                                return "Lütfen bir parola giriniz";
                              }
                              return null;
                            },
                            obscureText: true,
                          ),
                        ),
                        RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 15.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) singIn();
                          },
                          child: Text(
                            "Giriş Yap",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Card(
            elevation: 5.0,
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 15.0),
            child: InkWell(
              onTap: () {
                signInWithGoogle();
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                      image: AssetImage('images/google.png'),
                      height: 40,
                    ),
                    Text(
                      "Google ile giriş yap",
                      style: TextStyle(fontSize: 21),
                    )
                  ],
                ),
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => RegisterPage(),
                  ));
            },
            child: Text(
              "Üye değil misin? Kayıt ol",
            ),
          ),
        ],
      )),
    );
  }

  void singIn() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      User user = userCredential.user;
      if (user != null) {
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (context) => NewsPage()));
      }
    } on FirebaseAuth catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    final User user = userCredential.user;
    if (user != null) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => NewsPage()));
    }
    print(user.displayName.toString());
  }
}
