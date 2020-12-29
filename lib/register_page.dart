import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/news_page.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _password2Controller = TextEditingController();
  String firstPassword;
  String secondPassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Form(
            key: _formKey,
            child: ListView(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Image.asset("./images/edit.png"),
                      height: 150,
                    ),
                  ),
                  Container(
                    margin: new EdgeInsets.all(15.0),
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
                    margin: new EdgeInsets.all(15.0),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Parola",
                        border: OutlineInputBorder(),
                      ),
                      validator: (firstPassword) {
                        if (firstPassword.isEmpty) {
                          return "Lütfen bir parola giriniz";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                  ),
                  Container(
                    margin: new EdgeInsets.all(15.0),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      controller: _password2Controller,
                      decoration: const InputDecoration(
                        labelText: "Parolayı tekrar giriniz",
                        border: OutlineInputBorder(),
                      ),
                      validator: (secondPassword) {
                        if (_passwordController.text !=
                            _password2Controller.text) {
                          return "İki şifre aynı olmalıdır";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      print(_password2Controller.text);
                      if (_formKey.currentState.validate()) {
                        register();
                      }
                    },
                    child: Text("Kayıt Ol"),
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void register() async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      final User user = userCredential.user;
      if (user != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return NewsPage();
          },
        ));
      }
    } catch (e) {
      print(e);
    }
  }
}
