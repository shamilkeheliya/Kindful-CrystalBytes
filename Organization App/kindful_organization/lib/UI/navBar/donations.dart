import 'package:flutter/material.dart';
import 'package:kindful_organization/const.dart';

class Donations extends StatefulWidget {
  const Donations({Key? key}) : super(key: key);

  @override
  _DonationsState createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: kMainGreen,
        child: kFABIcon,
        shape: kFABShape,
      ),
    );
  }
}
