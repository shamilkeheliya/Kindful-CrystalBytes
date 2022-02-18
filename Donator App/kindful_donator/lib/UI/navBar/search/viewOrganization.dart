import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kindful_donator/utilities/cardTextStyles.dart';
import 'package:kindful_donator/utilities/const.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: Padding(
        padding: kCardsPadding,
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: kCardsInsidePadding,
                child: Center(
                    child: Text(widget.organizationName,
                        style: kCardTitleTextStyle)),
              ),
            ),
            Card(
              child: Padding(
                padding: kCardsInsidePadding,
                child: Column(
                  children: [
                    // ListTile(
                    //   leading: const Icon(Icons.add_business_outlined),
                    //   title: Text(widget.organizationName,
                    //       style: kCardQuantityTextStyle),
                    //   subtitle: const Text('Organization Name'),
                    // ),
                    ListTile(
                      leading: const Icon(Icons.star_outline),
                      title: Text(type, style: kCardQuantityTextStyle),
                      subtitle: const Text('Organization Type'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.map_outlined),
                      title: Text(city, style: kCardQuantityTextStyle),
                      subtitle: const Text('City'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_city_outlined),
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
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(address, style: kCardQuantityTextStyle),
                      subtitle: const Text('Address'),
                      onTap: () =>
                          MapsLauncher.launchCoordinates(latitude, longitude),
                    ),
                    ListTile(
                      leading: const Icon(Icons.supervisor_account),
                      title: Text(guardianName, style: kCardQuantityTextStyle),
                      subtitle: const Text('Guardian Name'),
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
            MaterialButton(
              onPressed: () {
                MapsLauncher.launchCoordinates(latitude, longitude);
              },
              child: kButtonBody('See Location'),
            ),
          ],
        ),
      ),
    );
  }
}
