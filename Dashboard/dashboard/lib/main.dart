import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/views/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyBwi8pKLqKXhIq3lzJEvL3uT57hu7mJI8Y",
  authDomain: "kindful-6b6dd.firebaseapp.com",
  projectId: "kindful-6b6dd",
  storageBucket: "kindful-6b6dd.appspot.com",
  messagingSenderId: "14056090943",
  appId: "1:14056090943:web:0bed67d2e7aedf5e5e778a",
  measurementId: "G-M9K621XQ4B",
);

Future<void> main() async {
  await Firebase.initializeApp(options: firebaseConfig);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Login(),
    );
  }
}
