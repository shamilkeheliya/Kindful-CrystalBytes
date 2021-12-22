import 'package:flutter/material.dart';
import 'package:kindful_organization/const.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account',
          style: TextStyle(color: kMainGreen),
        ),
        centerTitle: true,
        backgroundColor: kMainPurple,
        iconTheme: IconThemeData(
          color: kMainGreen,
        ),
      ),
      body: ListView(
        children: [

        ],
      ),
    );
  }
}
