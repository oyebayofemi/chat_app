import 'package:chat_app/screens/authentication/signin.dart';
import 'package:chat_app/screens/authentication/signup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  //changing the showSignIn to false
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn
        ? SigninPage(toggleView: toggleView)
        : SignUpPage(toggleView: toggleView);
  }
}
