import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kindful_organization/UI/navBar/donations/addDonation.dart';
import 'package:kindful_organization/UI/navBar/donations/donationsList.dart';
import '../../../utilities/const.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddDonation(widget.user.uid)));
        },
        backgroundColor: kMainGreen,
        child: kFABIcon,
        shape: kFABShape,
      ),
    );
  }
}
