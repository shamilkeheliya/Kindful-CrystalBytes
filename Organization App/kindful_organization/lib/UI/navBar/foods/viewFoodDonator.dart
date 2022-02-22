import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kindful_organization/UI/navBar/foods/repoertFoodDonator.dart';
import 'package:kindful_organization/utilities/cardTextStyles.dart';
import 'package:kindful_organization/utilities/const.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewFoodDonator extends StatefulWidget {
  late String donatorID, donatorName;

  ViewFoodDonator(this.donatorID, this.donatorName);
  @override
  _ViewFoodDonatorState createState() => _ViewFoodDonatorState();
}

class _ViewFoodDonatorState extends State<ViewFoodDonator> {
  String city = 'City';
  String district = 'District';
  String type = 'Business Type';
  String phone = 'Phone Number';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await FirebaseFirestore.instance
        .collection('food_donators')
        .doc(widget.donatorID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        city = documentSnapshot['city'];
        district = documentSnapshot['district'];
        type = documentSnapshot['type'];
        phone = documentSnapshot['phone'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(widget.donatorName, true),
      body: Padding(
        padding: kCardsPadding,
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: kCardsInsidePadding,
                child: Center(
                    child:
                        Text(widget.donatorName, style: kCardTitleTextStyle)),
              ),
            ),
            Card(
              child: Padding(
                padding: kCardsInsidePadding,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.location_city_outlined),
                      title: Text(city, style: kCardQuantityTextStyle),
                      subtitle: const Text('City'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.map_outlined),
                      title: Text(district, style: kCardQuantityTextStyle),
                      subtitle: const Text('District'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone_outlined),
                      title: Text(phone, style: kCardQuantityTextStyle),
                      subtitle: const Text('Phone Number'),
                      onTap: () => launch('tel:$phone'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.star_outline),
                      title: Text(type, style: kCardQuantityTextStyle),
                      subtitle: const Text('Business Type'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () => launch('tel:$phone'),
              child: kButtonBody('Call $phone'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReportFoodDonator(
                            FirebaseAuth.instance.currentUser!.uid,
                            widget.donatorID,
                            widget.donatorName)));
              },
              child: const Text('Report Organization'),
            ),
          ],
        ),
      ),
    );
  }
}
