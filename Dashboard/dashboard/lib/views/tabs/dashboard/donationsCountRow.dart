import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/utilities/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DonationsCountRow extends StatefulWidget {
  @override
  _DonationsCountRowState createState() => _DonationsCountRowState();
}

class _DonationsCountRowState extends State<DonationsCountRow> {
  String donationsCount = '';
  String food_donationsCount = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await FirebaseFirestore.instance
        .collection('donation')
        .get()
        .then((snapshot) {
      setState(() {
        donationsCount = snapshot.size.toString();
      });
    });
    await FirebaseFirestore.instance
        .collection('food_donation')
        .get()
        .then((snapshot) {
      setState(() {
        food_donationsCount = snapshot.size.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildUserCountCard('All Donations'),
          buildUserCountCard('All Food Donations'),
        ],
      ),
    );
  }

  Expanded buildUserCountCard(String title) {
    String count =
        title == 'All Donations' ? donationsCount : food_donationsCount;

    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 90,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: kCardsInsidePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'kindful',
                    fontWeight: FontWeight.bold,
                    color: kMainPurple,
                  ),
                ),
                count != ''
                    ? Text(
                        count,
                        style: const TextStyle(
                          fontFamily: 'kindful',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: kMainPurple,
                        ),
                      )
                    : const SpinKitCircle(color: kMainPurple, size: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
