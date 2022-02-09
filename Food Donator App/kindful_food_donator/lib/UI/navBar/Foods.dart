import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kindful_food_donator/addFoodDonation.dart';
import '../../utilities/const.dart';
import 'package:kindful_food_donator/firebase/foodsFirebase.dart';

class Foods extends StatefulWidget {
  late User user;

  Foods(user) {
    this.user = user;
  }

  @override
  _FoodsState createState() => _FoodsState();
}

class _FoodsState extends State<Foods> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kMainGreen, toolbarHeight: 0),
      body: FoodDetails(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddFoodDonation(widget.user.uid)));
        },
        shape: kFABShape,
        backgroundColor: kMainGreen,
        child: kFABIcon,
      ),
    );
  }
}
