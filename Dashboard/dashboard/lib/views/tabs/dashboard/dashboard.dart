import 'package:dashboard/views/tabs/dashboard/donationsCountRow.dart';
import 'package:dashboard/views/tabs/dashboard/indicator.dart';
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Indicator(
                color: const Color(0xff53fdd7),
                text: 'Donations',
                isSquare: true,
              ),
              SizedBox(width: 25),
              Indicator(
                color: const Color(0xffff5182),
                text: 'Food Donations',
                isSquare: true,
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Divider(thickness: 3),
          const SizedBox(height: 30),
          PieChartsRow(),
          const SizedBox(height: 30),
          const Divider(thickness: 3),
          const SizedBox(height: 30),
          UserCountRow(),
          DonationsCountRow(),
        ],
      ),
    );
  }
}
