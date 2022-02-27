import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/views/login.dart';
import 'package:dashboard/views/tabs/donators/donators.dart';
import 'package:dashboard/views/tabs/food_donations/food_donations.dart';
import 'package:dashboard/views/tabs/food_donators/food_donators.dart';
import 'package:dashboard/views/tabs/organiztions/organizations.dart';
import 'package:dashboard/views/tabs/users/users.dart';
import 'tabs/dashboard/dashboard.dart';
import 'tabs/donations/donations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userType = '';

  void initState() {
    super.initState();
    getType();
  }

  Future<void> getType() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        userType = documentSnapshot['type'];
      });
    });
  }

  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: kMainPurple,
          title: const Text(
            'DASHBOARD',
            style: TextStyle(
              fontFamily: 'kindful',
            ),
          ),
        ),
        body: Container(
          color: Colors.grey,
          width: double.infinity,
          height: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: buildTabColumn(),
              ),
              Expanded(
                flex: 4,
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
    UsersView(),
    Donations(),
    FoodDonations(),
    Organizations(),
    Donators(),
    FoodDonators(),
  ];

  Container buildTabColumn() {
    return Container(
      color: kMainGreen,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 65),
          const Divider(thickness: 2),
          SizedBox(height: MediaQuery.of(context).size.height / 65),
          buildTab(0, 'Dashboard'),
          Visibility(
            visible: userType == 'Admin',
            child: buildTab(1, 'Users'),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 65),
          const Divider(thickness: 2),
          SizedBox(height: MediaQuery.of(context).size.height / 65),
          buildTab(2, 'Donations'),
          buildTab(3, 'Food Donations'),
          SizedBox(height: MediaQuery.of(context).size.height / 65),
          const Divider(thickness: 2),
          SizedBox(height: MediaQuery.of(context).size.height / 65),
          buildTab(4, 'Organizations'),
          buildTab(5, 'Donators'),
          buildTab(6, 'Food Donators'),
          SizedBox(height: MediaQuery.of(context).size.height / 65),
          const Divider(thickness: 2),
          SizedBox(height: MediaQuery.of(context).size.height / 65),
          buildSignOutButton(),
          SizedBox(height: MediaQuery.of(context).size.height / 65),
          const Divider(thickness: 2),
        ],
      ),
    );
  }

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
            return AlertDialog(
              title: const Text("Are you sure?",
                  style: TextStyle(color: Colors.red)),
              content: const Text('Do you want to Log Out?'),
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
