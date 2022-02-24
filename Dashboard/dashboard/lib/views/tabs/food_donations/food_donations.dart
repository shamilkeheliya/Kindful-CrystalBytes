import 'package:dashboard/views/tabs/food_donations/all_food_donations.dart';
import 'package:flutter/material.dart';

class FoodDonations extends StatefulWidget {
  @override
  _FoodDonationsState createState() => _FoodDonationsState();
}

class _FoodDonationsState extends State<FoodDonations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AllFoodDonations(),
    );
  }
}
