import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/utilities/tab.dart';
import 'package:dashboard/views/tabs/food_donators/all_food_donators.dart';
import 'package:dashboard/views/tabs/food_donators/food_donator_reports.dart';
import 'package:dashboard/views/tabs/food_donators/food_donators_verification.dart';
import 'package:flutter/material.dart';

class FoodDonators extends StatefulWidget {
  @override
  _FoodDonatorsState createState() => _FoodDonatorsState();
}

class _FoodDonatorsState extends State<FoodDonators> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TabBar(
          labelColor: kMainGreen,
          unselectedLabelColor: Colors.white,
          indicatorColor: kMainPurple,
          tabs: [
            CustomTab('Food Donators'),
            CustomTab('Verifications'),
            CustomTab('Reports'),
          ],
        ),
        body: TabBarView(
          children: [
            AllFoodDonators(),
            FoodDonatorsVerification(),
            FoodDonatorReports(),
          ],
        ),
      ),
    );
  }
}
