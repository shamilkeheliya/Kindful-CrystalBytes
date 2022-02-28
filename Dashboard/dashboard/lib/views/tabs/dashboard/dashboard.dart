import 'package:dashboard/views/tabs/dashboard/donationsCountRow.dart';
import 'package:dashboard/views/tabs/dashboard/pastDaysDonationsBarChart.dart';
import 'package:dashboard/views/tabs/dashboard/pieChartsRow.dart';
import 'package:dashboard/views/tabs/dashboard/userCountRow.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          PastDaysDonationsBarChart(),
          PieChartsRow(),
          UserCountRow(),
          DonationsCountRow(),
        ],
      ),
    );
  }
}
