import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kindful_food_donator/UI/navBar/Foods.dart';
import 'package:kindful_food_donator/UI/navBar/feed.dart';
import 'package:kindful_food_donator/UI/navBar/profile.dart';
import 'package:kindful_food_donator/UI/navBar/search.dart';
import 'package:kindful_food_donator/const.dart';

class NavBar extends StatefulWidget {
  String userID = '';

  NavBar(userID) {
    this.userID = userID;
  }

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      Center(child: Feed()),
      Center(child: Foods()),
      Center(child: Search()),
      Center(child: Profile(FirebaseAuth.instance.currentUser)),
    ];

    final _kBottmonNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.backup_table_outlined),
        label: 'Feed',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.fastfood_outlined),
        label: 'Foods',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.search_outlined),
        label: 'Search',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.account_circle_outlined),
        label: 'Profile',
      ),
    ];

    assert(_kTabPages.length == _kBottmonNavBarItems.length);
    final bottomNavBar = BottomNavigationBar(
      items: _kBottmonNavBarItems,
      currentIndex: _currentTabIndex,
      selectedLabelStyle: TextStyle(fontFamily: 'kindful'),
      unselectedLabelStyle: TextStyle(fontFamily: 'kindful'),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      //unselectedItemColor: kMainPurple,
      selectedItemColor: kMainPurple,
      //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: kMainGreen,
      type: BottomNavigationBarType.fixed,
      unselectedIconTheme: IconThemeData(size: 30.0),
      selectedIconTheme: IconThemeData(size: 35.0),
      selectedFontSize: 15.0,
      onTap: (int index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
    );
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: _kTabPages[_currentTabIndex],
        bottomNavigationBar: bottomNavBar,
      ),
    );
  }
}
