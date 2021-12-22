import 'package:flutter/material.dart';
import 'package:kindful_organization/UI/loadingScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kindful_organization/UI/signup.dart';
import 'package:kindful_organization/const.dart';
import 'package:kindful_organization/navBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: kMainGreen,
      ),
      home: Scaffold(
        body: LoadingScreen(),
      ),
    );
  }
}
