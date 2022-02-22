import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kindful_donator/UI/navBar/donations/donationsList.dart';
import 'package:kindful_donator/utilities/const.dart';

class Donations extends StatefulWidget {
  late User user;
  Donations(user) {
    this.user = user;
  }

  @override
  _DonationsState createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kMainGreen, toolbarHeight: 0),
      body: DonationsList(widget.user.uid),
    );
  }
}
