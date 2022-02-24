import 'package:dashboard/utilities/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserCountRow extends StatefulWidget {
  @override
  _UserCountRowState createState() => _UserCountRowState();
}

class _UserCountRowState extends State<UserCountRow> {
  String organizationsCount = '';
  String donatorsCount = '';
  String food_donatorsCount = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await FirebaseFirestore.instance
        .collection('organizations')
        .get()
        .then((snapshot) {
      setState(() {
        organizationsCount = snapshot.size.toString();
      });
    });
    await FirebaseFirestore.instance
        .collection('donators')
        .get()
        .then((snapshot) {
      setState(() {
        donatorsCount = snapshot.size.toString();
      });
    });
    await FirebaseFirestore.instance
        .collection('food_donators')
        .get()
        .then((snapshot) {
      setState(() {
        food_donatorsCount = snapshot.size.toString();
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
          buildUserCountCard('Organizations'),
          buildUserCountCard('Donators'),
          buildUserCountCard('Food Donators'),
        ],
      ),
    );
  }

  Expanded buildUserCountCard(String title) {
    String count = title == 'Organizations'
        ? organizationsCount
        : title == 'Donators'
            ? donatorsCount
            : food_donatorsCount;

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
