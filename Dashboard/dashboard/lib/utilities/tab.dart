import 'package:dashboard/utilities/const.dart';
import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  late String title;
  CustomTab(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kMainGreen,
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: kMainPurple, fontFamily: 'kindful'),
          ),
        ),
      ),
    );
  }
}
