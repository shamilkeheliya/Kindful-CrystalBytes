import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kindful_organization/UI/navBar/foods/foodsList.dart';
import 'package:kindful_organization/utilities/const.dart';

class Food extends StatefulWidget {
  late User user;

  Food(user) {
    this.user = user;
  }

  @override
  _FoodState createState() => _FoodState();
}

class _FoodState extends State<Food> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kMainGreen, toolbarHeight: 0),
      body: FoodsList(widget.user.uid),
    );
  }
}
