import 'package:dashboard/utilities/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserCountRow extends StatefulWidget {
  @override
  _UserCountRowState createState() => _UserCountRowState();
}

class _UserCountRowState extends State<UserCountRow> {
  String organizationsCount = '500';
  String donatorsCount = '434';
  String food_donatorsCount = '232';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildUserCountCard('Organizations'),
            buildUserCountCard('Donators'),
            buildUserCountCard('Food Donators'),
          ],
        ),
      ),
    );
  }

  Padding buildUserCountCard(String title) {
    return Padding(
      padding: kCardsPadding,
      child: Container(
        width: MediaQuery.of(context).size.width / 4.3,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: kCardsInsidePadding,
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'kindful',
                    fontWeight: FontWeight.bold,
                    color: kMainPurple,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title == 'Organization'
                      ? organizationsCount
                      : title == 'Donators'
                          ? donatorsCount
                          : food_donatorsCount,
                  style: const TextStyle(
                    fontFamily: 'kindful',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: kMainPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
