import 'package:flutter/material.dart';
import 'package:kindful_food_donator/utilities/const.dart';

class NotVerifiedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '😢',
              style: TextStyle(fontSize: 45),
            ),
            SizedBox(height: 20),
            Text(
              'Looks like\nYou are not verified yet !',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, fontFamily: 'kindful', color: kMainPurple),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
