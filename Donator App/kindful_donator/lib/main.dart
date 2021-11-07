import 'package:flutter/material.dart';
import 'package:kindful_donator/UI/loadingScreen.dart';
import 'package:kindful_donator/const.dart';
import 'package:kindful_donator/foodNavBar.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FoodNavBar(),
    );
  }
}
