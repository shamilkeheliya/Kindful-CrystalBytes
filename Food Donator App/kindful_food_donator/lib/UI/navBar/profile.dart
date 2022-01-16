import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kindful_food_donator/UI/verify.dart';
import 'package:kindful_food_donator/const.dart';

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
  String name = 'Business Name';
  String city = 'City';
  String district = 'District';
  String type = 'Business Type';
  String phone = 'Phone Number';
  String email = 'Email';
  bool verify = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      photoURL = widget.user.photoURL!;
    });

    FirebaseFirestore.instance
        .collection('food_donators')
        .doc(widget.user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        name = documentSnapshot['name'];
        city = documentSnapshot['city'];
        district = documentSnapshot['district'];
        verify = documentSnapshot['verify'];
        phone = documentSnapshot['phone'];
        email = documentSnapshot['email'];
        type = documentSnapshot['type'];
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
          kProfileListTile(Icons.location_city_outlined, city, 'City'),
          kProfileListTile(Icons.map_outlined, district, 'District'),
          kProfileListTile(Icons.star_outline, type, 'Business Type'),
          kProfileListTile(Icons.phone_outlined, phone, 'Phone Number'),
          kProfileListTile(Icons.alternate_email_outlined, email, 'Email'),
          verify
              ? kProfileListTile(Icons.verified_outlined, 'Verified ✔', '')
              : MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Verify(widget.user.uid),
                      ),
                    );
                  },
                  child: kButtonBody('Request Verify'),
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
