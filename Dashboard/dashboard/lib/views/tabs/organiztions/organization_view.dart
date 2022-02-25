import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/utilities/cardTextStyles.dart';
import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/views/home.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';

class OrganizationView extends StatefulWidget {
  late String organizationID, organizationName;
  OrganizationView(this.organizationID, this.organizationName);
  @override
  _OrganizationViewState createState() => _OrganizationViewState();
}

class _OrganizationViewState extends State<OrganizationView> {
  String type = 'Organization Type';
  String city = 'City';
  String email = 'Email';
  String district = 'District';
  String phone = 'Phone Number';
  String address = 'Address';
  String regImage = '';
  String regNumber = '';
  late double latitude;
  late double longitude;
  String guardianName = 'Guardian Name';
  String guardianNIC = 'NIC';
  String guardianNICF = '';
  String guardianNICB = '';
  bool requestVerify = false;
  bool verify = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await FirebaseFirestore.instance
        .collection('organizations')
        .doc(widget.organizationID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        type = documentSnapshot['type'];
        city = documentSnapshot['city'];
        email = documentSnapshot['email'];
        district = documentSnapshot['district'];
        phone = documentSnapshot['phone'];
        address = documentSnapshot['address'];
        verify = documentSnapshot['verify'];
        requestVerify = documentSnapshot['requestVerify'];
      });
    });

    if (requestVerify) {
      await FirebaseFirestore.instance
          .collection('organizations')
          .doc(widget.organizationID)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        setState(() {
          regImage = documentSnapshot['regImage'];
          regNumber = documentSnapshot['regNumber'];
          latitude = documentSnapshot['location']['latitude'];
          longitude = documentSnapshot['location']['longitude'];
          guardianName = documentSnapshot['guardian']['guardianName'];
          guardianNIC = documentSnapshot['guardian']['guardianNIC'];
          guardianNICF = documentSnapshot['guardian']['nicFront'];
          guardianNICB = documentSnapshot['guardian']['nicBack'];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kMainPurple,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                icon: Icon(Icons.home)),
          ],
          title: Text(
            widget.organizationName,
            style: const TextStyle(fontFamily: 'kindful'),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 30,
            horizontal: MediaQuery.of(context).size.width / 30,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                mainDetailsCard(),
                bottomCard(),
                verifyButtonCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center mainDetailsCard() {
    return Center(
      child: SizedBox(
        width: 500,
        child: Card(
          child: Padding(
            padding: kCardsInsidePadding,
            child: Column(
              children: [
                Text(
                  widget.organizationName,
                  style: kCardTitleTextStyle,
                ),
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
                ),
                ListTile(
                  leading: const Icon(Icons.alternate_email),
                  title: Text(email, style: kCardQuantityTextStyle),
                  subtitle: const Text('Email'),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(address, style: kCardQuantityTextStyle),
                  subtitle: const Text('Address'),
                  onTap: () {
                    launch(
                        'http://maps.google.com/maps?q=$latitude,$longitude');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.verified_outlined),
                  title: Text(verify ? 'Verified' : 'Not Verified',
                      style: kCardQuantityTextStyle),
                  subtitle: const Text('Verify'),
                  onTap: verify
                      ? () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Are you sure?",
                                    style: TextStyle(color: Colors.red)),
                                content: const Text(
                                    'Do you want to remove verification?'),
                                actions: [
                                  TextButton(
                                    child: const Text("NO",
                                        style: TextStyle(color: kMainPurple)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("YES",
                                        style: TextStyle(color: kMainPurple)),
                                    onPressed: () {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      FirebaseFirestore.instance
                                          .collection('organizations')
                                          .doc(widget.organizationID)
                                          .update({
                                        'verify': false,
                                      }).then((value) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OrganizationView(
                                                        widget.organizationID,
                                                        widget
                                                            .organizationName)));
                                        setState(() {
                                          isLoading = false;
                                        });
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Visibility bottomCard() {
    return Visibility(
      visible: requestVerify,
      child: Center(
        child: SizedBox(
          width: 500,
          child: Card(
            child: Padding(
              padding: kCardsInsidePadding,
              child: Column(
                children: [
                  ListTile(
                    title: Text(regNumber, style: kCardQuantityTextStyle),
                    subtitle: const Text('Registration Number'),
                  ),
                  ListTile(
                    title: const Text('Registration Certificate'),
                    subtitle: const Text('Tap to View'),
                    onTap: () {
                      launch(regImage);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(guardianName, style: kCardQuantityTextStyle),
                    subtitle: const Text('Guardian Name'),
                  ),
                  ListTile(
                    title: Text(guardianNIC, style: kCardQuantityTextStyle),
                    subtitle: const Text('Guardian NIC Number'),
                  ),
                  ListTile(
                    title: const Text('Guardian NIC Front'),
                    subtitle: const Text('Tap to View'),
                    onTap: () {
                      launch(guardianNICF);
                    },
                  ),
                  ListTile(
                    title: const Text('Guardian NIC Back'),
                    subtitle: const Text('Tap to View'),
                    onTap: () {
                      launch(guardianNICB);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Visibility verifyButtonCard() {
    return Visibility(
      visible: requestVerify && !verify,
      child: Center(
        child: SizedBox(
          width: 500,
          child: Card(
            child: Padding(
              padding: kCardsInsidePadding,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Are you sure?",
                            style: TextStyle(color: Colors.red)),
                        content: const Text(
                            'Do you want to verify this organization?'),
                        actions: [
                          TextButton(
                            child: const Text("NO",
                                style: TextStyle(color: kMainPurple)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("YES",
                                style: TextStyle(color: kMainPurple)),
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              FirebaseFirestore.instance
                                  .collection('organizations')
                                  .doc(widget.organizationID)
                                  .update({
                                'verify': true,
                              }).then((value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrganizationView(
                                            widget.organizationID,
                                            widget.organizationName)));
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Verify'),
                style: ElevatedButton.styleFrom(primary: kMainGreen),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
