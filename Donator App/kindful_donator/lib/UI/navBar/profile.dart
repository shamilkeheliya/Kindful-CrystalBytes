import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kindful_donator/const.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  late User user;

  // ignore: use_key_in_widget_constructors
  Profile(user) {
    // ignore: prefer_initializing_formals
    this.user = user;
  }

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String photoURL = kDefaltIcon;
  String name = 'Name';
  String district = 'District';
  String phone = 'Phone Number';
  String email = 'Email';

  @override
  void initState() {
    super.initState();

    setState(() {
      photoURL = widget.user.photoURL!;
    });

    FirebaseFirestore.instance
        .collection('donators')
        .doc(widget.user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        name = documentSnapshot['name'];
        district = documentSnapshot['district'];
        phone = documentSnapshot['phone'];
        email = documentSnapshot['email'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(name, false),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: NetworkImage(photoURL),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          kProfileListTile(Icons.add_business_outlined, name, 'Business Name'),
          kProfileListTile(Icons.map_outlined, district, 'District'),
          kProfileListTile(Icons.phone_outlined, phone, 'Phone Number'),
          kProfileListTile(Icons.alternate_email_outlined, email, 'Email'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
