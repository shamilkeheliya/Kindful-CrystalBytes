import 'package:flutter/material.dart';
import 'package:kindful_food_donator/addFoodDonation.dart';
import 'package:kindful_food_donator/const.dart';

class Foods extends StatefulWidget {
  @override
  _FoodsState createState() => _FoodsState();
}

class _FoodsState extends State<Foods> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddFoodDonation()));
        },
        shape: kFABShape,
        backgroundColor: kMainGreen,
        child: kFABIcon,
      ),
    );
  }
}
