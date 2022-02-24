import 'dart:html';

import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/views/login.dart';
import 'package:dashboard/views/tabs/dashboard.dart';
import 'package:dashboard/views/tabs/donations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: kMainPurple,
            title: const Text(
              'Kindful Dashboard',
              style: TextStyle(
                fontFamily: 'kindful',
              ),
            )),
        body: Container(
          color: Colors.grey,
          width: double.infinity,
          height: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: kMainGreen,
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 5),
                      const Divider(thickness: 2),
                      SizedBox(height: MediaQuery.of(context).size.height / 65),
                      buildTab(0, 'Dashboard'),
                      SizedBox(height: MediaQuery.of(context).size.height / 65),
                      const Divider(thickness: 2),
                      SizedBox(height: MediaQuery.of(context).size.height / 65),
                      buildTab(1, 'Donations'),
                      buildTab(2, 'Food Donations'),
                      SizedBox(height: MediaQuery.of(context).size.height / 65),
                      const Divider(thickness: 2),
                      SizedBox(height: MediaQuery.of(context).size.height / 65),
                      buildTab(3, 'Organizations'),
                      buildTab(4, 'Donators'),
                      buildTab(5, 'Food Donators'),
                      SizedBox(height: MediaQuery.of(context).size.height / 65),
                      const Divider(thickness: 2),
                      SizedBox(height: MediaQuery.of(context).size.height / 65),
                      buildSignOutButton(),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: _kTabs[_selectedTab],
              ),
            ],
          ),
        ),
      ),
    );
  }

  final _kTabs = <Widget>[
    Dashboard(),
    Donations(),
    Dashboard(),
    Donations(),
    Dashboard(),
    Donations(),
  ];

  MaterialButton buildTab(int value, String title) {
    return MaterialButton(
      onPressed: () {
        setState(() {
          _selectedTab = value;
        });
      },
      padding: EdgeInsets.zero,
      child: Container(
        color: _selectedTab == value ? kMainPurple : null,
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 15,
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'kindful',
              color: _selectedTab == value ? kMainGreen : kMainPurple,
            ),
          ),
        ),
      ),
    );
  }

  MaterialButton buildSignOutButton() {
    return MaterialButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text("Are you sure?",
                  style: TextStyle(color: Colors.red)),
              content: Text('Do you want to Log Out?'),
              actions: [
                TextButton(
                  child: const Text("NO", style: TextStyle(color: kMainPurple)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child:
                      const Text("YES", style: TextStyle(color: kMainPurple)),
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    });
                  },
                ),
              ],
            );
          },
        );
      },
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 15,
        child: const Center(
          child: Text(
            'Log Out',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'kindful',
              color: kMainPurple,
            ),
          ),
        ),
      ),
    );
  }
}
