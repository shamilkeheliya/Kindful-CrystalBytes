import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';

  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        //appBar: AppBar(backgroundColor: kMainPurple),
        body: Center(
          child: SizedBox(
            width: 500,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: buildBody(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset('assets/images/fullLogo.png'),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: kTextFieldPadding,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              controller: emailTEC,
              keyboardType: TextInputType.emailAddress,
              decoration: kTextInputDecoration('Email', false),
            ),
          ),
          Padding(
            padding: kTextFieldPadding,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              controller: passwordTEC,
              obscureText: true,
              decoration: kTextInputDecoration('Password', false),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => validate(),
            child: const Text('LOGIN'),
            style: ElevatedButton.styleFrom(primary: kMainPurple),
          ),
        ],
      ),
    );
  }

  Future<void> validate() async {
    if (emailTEC.text.isEmpty || passwordTEC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Failed !'),
        ),
      );
    } else {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential != '') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Failed!'),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Failed!'),
            ),
          );
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Failed!'),
            ),
          );
        }
      }
    }
  }
}
