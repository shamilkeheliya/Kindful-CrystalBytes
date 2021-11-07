import 'package:flutter/material.dart';
import 'package:kindful_donator/UI/loadingScreen.dart';

class FoodNavBar extends StatefulWidget {
  const FoodNavBar({Key? key}) : super(key: key);

  @override
  _FoodNavBarState createState() => _FoodNavBarState();
}

class _FoodNavBarState extends State<FoodNavBar> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      Center(child: LoadingScreen()),
      Center(child: LoadingScreen()),
      Center(child: LoadingScreen()),
      Center(child: LoadingScreen()),
      Center(child: LoadingScreen()),
    ];

    final _kBottmonNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.archive_outlined),
        label: 'Requests',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.fastfood_outlined),
        label: 'Foods',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.all_inclusive_outlined),
        label: 'Donations',
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
      showSelectedLabels: true,
      showUnselectedLabels: true,
      //selectedItemColor: mainColor,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
    return Scaffold(
      body: _kTabPages[_currentTabIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}
