import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/utilities/tab.dart';
import 'package:dashboard/views/tabs/donators/all_donators.dart';
import 'package:dashboard/views/tabs/donators/donator_reports.dart';
import 'package:flutter/material.dart';

class Donators extends StatefulWidget {
  @override
  _DonatorsState createState() => _DonatorsState();
}

class _DonatorsState extends State<Donators> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          labelColor: kMainGreen,
          unselectedLabelColor: Colors.white,
          indicatorColor: kMainPurple,
          tabs: [
            CustomTab('Donators'),
            CustomTab('Reports'),
          ],
        ),
        body: TabBarView(
          children: [
            AllDonators(),
            DonatorReports(),
          ],
        ),
      ),
    );
  }
}
