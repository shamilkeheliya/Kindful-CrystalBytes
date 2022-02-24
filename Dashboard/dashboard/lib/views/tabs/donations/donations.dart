import 'package:dashboard/views/tabs/donations/all_donations.dart';
import 'package:flutter/material.dart';

class Donations extends StatefulWidget {
  @override
  _DonationsState createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AllDonations(),
    );
  }
}
