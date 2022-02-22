import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kindful_organization/utilities/cardTextStyles.dart';
import 'package:kindful_organization/utilities/const.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleFoodDonation extends StatefulWidget {
  late String docID;

  SingleFoodDonation(String docID) {
    this.docID = docID;
  }

  @override
  _SingleFoodDonationState createState() => _SingleFoodDonationState();
}

class _SingleFoodDonationState extends State<SingleFoodDonation> {
  String title = 'Food Title';
  String description = 'Description';
  String quantity = 'Quantity';
  String status = 'Status';
  String expireTime = 'Time';
  String date = 'Date';
  String donator = '';

  String donatorName = 'Donator Name';
  String donatorCity = 'City';
  String donatorDistrict = 'District';
  String donatorType = 'Business Type';
  String donatorPhone = 'Phone Number';

  bool isProssesing = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await FirebaseFirestore.instance
        .collection('food_donation')
        .doc(widget.docID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        title = documentSnapshot['title'];
        description = documentSnapshot['description'];
        quantity = documentSnapshot['quantity'];
        status = documentSnapshot['status'];
        expireTime = documentSnapshot['expireTime'];
        date = documentSnapshot['date'];
        donator = documentSnapshot['donator'];
      });
    });

    await FirebaseFirestore.instance
        .collection('food_donators')
        .doc(donator)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        donatorName = documentSnapshot['name'];
        donatorCity = documentSnapshot['city'];
        donatorDistrict = documentSnapshot['district'];
        donatorType = documentSnapshot['type'];
        donatorPhone = documentSnapshot['phone'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(title, true),
      body: ModalProgressHUD(
        inAsyncCall: isProssesing,
        child: ListView(
          children: [
            mainCard(),
            donatorCard(),
          ],
        ),
      ),
    );
  }

  Padding mainCard() {
    return Padding(
      padding: kCardsPadding,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: kCardsInsidePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: kCardTitleTextStyle,
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: kCardDescriptionTextStyle,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    child: Padding(
                      padding: kCardsInsidePadding,
                      child: Column(
                        children: [
                          Text(
                            'Expire Time',
                            style: kCardDateTextStyle,
                          ),
                          Text(
                            expireTime,
                            style: kCardQuantityTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        date.toString(),
                        style: kCardDateTextStyle,
                      ),
                      Text(
                        'Quantity: $quantity',
                        style: kCardQuantityTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding donatorCard() {
    return Padding(
      padding: kCardsPadding,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: kCardsInsidePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Donator', style: kCardTitleTextStyle),
              const SizedBox(height: 10),
              donatorDetailsCard(),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox donatorDetailsCard() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.location_city_outlined),
              title: Text(donatorCity, style: kCardQuantityTextStyle),
              subtitle: const Text('City'),
            ),
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text(donatorDistrict, style: kCardQuantityTextStyle),
              subtitle: const Text('District'),
            ),
            ListTile(
              leading: const Icon(Icons.phone_outlined),
              title: Text(donatorPhone, style: kCardQuantityTextStyle),
              subtitle: const Text('Phone Number'),
              onTap: () => launch('tel:$donatorPhone'),
            ),
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: Text(donatorType, style: kCardQuantityTextStyle),
              subtitle: const Text('Business Type'),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () => launch('tel:$donatorPhone'),
              child: kButtonBody('Call $donatorPhone'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
