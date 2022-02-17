import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kindful_food_donator/utilities/cardTextStyles.dart';
import 'package:kindful_food_donator/utilities/const.dart';

class ViewOrganization extends StatefulWidget {
  late String organizationID, organizationName;
  ViewOrganization(this.organizationID, this.organizationName);
  @override
  _ViewOrganizationState createState() => _ViewOrganizationState();
}

class _ViewOrganizationState extends State<ViewOrganization> {
  String type = 'Organization Type';
  String city = 'City';
  String district = 'District';
  String phone = 'Phone Number';
  String address = 'Address';
  late double latitude;
  late double longitude;
  String guardianName = 'Guardian Name';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await FirebaseFirestore.instance
        .collection('organizations')
        .doc(widget.organizationID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        type = documentSnapshot['type'];
        city = documentSnapshot['city'];
        district = documentSnapshot['district'];
        phone = documentSnapshot['phone'];
        address = documentSnapshot['address'];
        latitude = documentSnapshot['location']['latitude'];
        longitude = documentSnapshot['location']['longitude'];
        guardianName = documentSnapshot['guardian']['guardianName'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(widget.organizationName, true),
      body: ListView(
        children: [
          Padding(
            padding: kCardsPadding,
            child: Card(
              child: Padding(
                padding: kCardsInsidePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.organizationName,
                      style: kCardTitleTextStyle,
                    ),
                    Text(
                      type,
                      style: kCardQuantityTextStyle,
                    ),
                    Text(
                      city,
                      style: kCardQuantityTextStyle,
                    ),
                    Text(
                      district,
                      style: kCardQuantityTextStyle,
                    ),
                    Text(
                      phone,
                      style: kCardQuantityTextStyle,
                    ),
                    Text(
                      address,
                      style: kCardQuantityTextStyle,
                    ),
                    Text(
                      guardianName,
                      style: kCardQuantityTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
