import 'package:flutter/material.dart';
import 'package:kindful_organization/const.dart';

class Food extends StatefulWidget {
  const Food({Key? key}) : super(key: key);

  @override
  _FoodState createState() => _FoodState();
}

class _FoodState extends State<Food> {
  @override
  Widget build(BuildContext context) {
    // return SafeArea(child: ListView(children: [
    //   Container(height: 200,width: double.infinity,color: Colors.red,)
    // ],));
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0,
        backgroundColor: kMainGreen,
      ),
      body: ListView(children: [
          Container(height: 200,width: double.infinity,color: Colors.red,)
        ],),
    );
  }
}
