import 'package:flutter/material.dart';
import 'package:kindful_donator/UI/navBar/feed/postList.dart';
import 'package:kindful_donator/utilities/const.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kMainGreen, toolbarHeight: 0),
      body: PostList(),
    );
  }
}
