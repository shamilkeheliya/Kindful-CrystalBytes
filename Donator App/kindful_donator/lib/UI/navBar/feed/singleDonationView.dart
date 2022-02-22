import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kindful_donator/utilities/cardTextStyles.dart';
import 'package:kindful_donator/utilities/const.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';

class SingleDonation extends StatefulWidget {
  late String docID;

  SingleDonation(String docID) {
    this.docID = docID;
  }

  @override
  _SingleDonationState createState() => _SingleDonationState();
}

class _SingleDonationState extends State<SingleDonation> {
  String title = 'Donation Title';
  String description = 'Description';
  String quantity = 'Quantity';
  String status = 'Status';
  String date = 'Date';
  String organization = '';

  String organizationName = 'Donator Name';
  String organizationCity = 'City';
  String organizationDistrict = 'District';
  String organizationAddress = 'Address';
  String organizationType = 'Business Type';
  String organizationPhone = 'Phone Number';
  late double organizationLatitude;
  late double organizationLongitude;
  String organizationGuardianName = 'Guardian Name';

  bool isProssesing = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await FirebaseFirestore.instance
        .collection('donation')
        .doc(widget.docID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        title = documentSnapshot['title'];
        description = documentSnapshot['description'];
        quantity = documentSnapshot['quantity'];
        status = documentSnapshot['status'];
        date = documentSnapshot['date'];
        organization = documentSnapshot['organization'];
      });
    });

    await FirebaseFirestore.instance
        .collection('organizations')
        .doc(organization)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        organizationName = documentSnapshot['name'];
        organizationCity = documentSnapshot['city'];
        organizationDistrict = documentSnapshot['district'];
        organizationAddress = documentSnapshot['address'];
        organizationType = documentSnapshot['type'];
        organizationPhone = documentSnapshot['phone'];
        organizationLatitude = documentSnapshot['location']['latitude'];
        organizationLongitude = documentSnapshot['location']['longitude'];
        organizationGuardianName = documentSnapshot['guardian']['guardianName'];
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
            Text(organizationName, style: kCardTitleTextStyle),
            ListTile(
              leading: const Icon(Icons.location_city_outlined),
              title: Text(organizationCity, style: kCardQuantityTextStyle),
              subtitle: const Text('City'),
            ),
            ListTile(
              leading: const Icon(Icons.map_outlined),
              title: Text(organizationDistrict, style: kCardQuantityTextStyle),
              subtitle: const Text('District'),
            ),
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text(organizationAddress, style: kCardQuantityTextStyle),
              subtitle: const Text('Address'),
            ),
            ListTile(
              leading: const Icon(Icons.phone_outlined),
              title: Text(organizationPhone, style: kCardQuantityTextStyle),
              subtitle: const Text('Phone Number'),
              onTap: () => launch('tel:$organizationPhone'),
            ),
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: Text(organizationType, style: kCardQuantityTextStyle),
              subtitle: const Text('Business Type'),
            ),
            ListTile(
              leading: const Icon(Icons.supervisor_account),
              title:
                  Text(organizationGuardianName, style: kCardQuantityTextStyle),
              subtitle: const Text('Guardian Name'),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () => launch('tel:$organizationPhone'),
              child: kButtonBody('Call $organizationPhone'),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () {
                MapsLauncher.launchCoordinates(
                    organizationLatitude, organizationLongitude);
              },
              child: kButtonBody('See Location'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
