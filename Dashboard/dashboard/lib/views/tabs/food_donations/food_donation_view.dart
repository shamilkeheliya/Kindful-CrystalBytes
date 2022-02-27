import 'package:flutter/material.dart';

class FoodDonationView extends StatefulWidget {
  late String docId, title;
  FoodDonationView(this.docId, this.title);
  @override
  _FoodDonationViewState createState() => _FoodDonationViewState();
}

class _FoodDonationViewState extends State<FoodDonationView> {
  String date = 'Date';
  String time = 'Expire Time';
  String description = 'Description';
  String foodDonator = '';
  String foodDonatorName = 'Donator';
  String organization = '';
  String organizationName = 'Organization';
  String quantity = 'Quantity';
  String status = 'Status';
  String title = 'Title';

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
