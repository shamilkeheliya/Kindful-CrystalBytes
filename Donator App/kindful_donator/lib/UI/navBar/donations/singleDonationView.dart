import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kindful_donator/utilities/NavBar.dart';
import 'package:kindful_donator/utilities/cardTextStyles.dart';
import 'package:kindful_donator/utilities/const.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:kindful_donator/UI/navBar/search/viewOrganization.dart';

class SingleDonationView extends StatefulWidget {
  late String docID;

  SingleDonationView(String docID) {
    this.docID = docID;
  }
  @override
  _SingleDonationViewState createState() => _SingleDonationViewState();
}

class _SingleDonationViewState extends State<SingleDonationView> {
  String title = 'Donation Title';
  String description = 'Description';
  String quantity = 'Quantity';
  String status = 'Status';
  String date = 'Date';
  String organization = '';

  String organizationName = 'Donator Name';
  String organizationCity = 'City';
  String organizationDistrict = 'District';

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

    FirebaseFirestore.instance
        .collection('food_donators')
        .doc(organization)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        organizationName = documentSnapshot['name'];
        organizationCity = documentSnapshot['city'];
        organizationDistrict = documentSnapshot['district'];
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
            organizationCard(),
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
                  Container(
                    decoration: BoxDecoration(
                        color: status == 'added'
                            ? Colors.amber
                            : status == 'accepted'
                                ? Colors.lightBlue
                                : Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        status == 'added'
                            ? 'Added'
                            : status == 'accepted'
                                ? 'Accepted'
                                : 'Done',
                        style: const TextStyle(fontFamily: 'kindful'),
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
              Visibility(
                visible: status == 'added',
                child: const SizedBox(height: 15),
              ),
              Visibility(
                visible: status == 'added',
                child: buttonForAdded(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buttonForAdded() {
    return Row(
      children: [
        Flexible(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: const Text("Confirm",
                        style: TextStyle(color: Colors.green)),
                    content: const Text('Do you want to accept this donation?'),
                    actions: [
                      TextButton(
                        child: const Text("Cancel",
                            style: TextStyle(color: kMainPurple)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text("Confirm",
                            style: TextStyle(color: Colors.green)),
                        onPressed: () {
                          setState(() {
                            isProssesing = true;
                          });
                          Navigator.pop(context);
                          FirebaseFirestore.instance
                              .collection('donation')
                              .doc(widget.docID)
                              .update({'status': 'accepted'}).then((value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (contex) => NavBar(FirebaseAuth
                                        .instance.currentUser?.uid)));
                            setState(() {
                              isProssesing = false;
                            });
                            SnackBarClass.kShowSuccessSnackBar(context);
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child: const SizedBox(
              width: double.infinity,
              child: Center(child: Text('Accept')),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: const Text("Warning",
                        style: TextStyle(color: Colors.red)),
                    content: const Text('Do you want to Reject Food Donation?'),
                    actions: [
                      TextButton(
                        child: const Text("Cancel",
                            style: TextStyle(color: kMainPurple)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text("Reject",
                            style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          setState(() {
                            isProssesing = true;
                          });
                          Navigator.pop(context);
                          FirebaseFirestore.instance
                              .collection('donation')
                              .doc(widget.docID)
                              .update({
                            'status': 'pending',
                            'donator': '',
                          }).then((value) {
                            setState(() {
                              isProssesing = false;
                            });
                            SnackBarClass.kShowSuccessSnackBar(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (contex) => NavBar(FirebaseAuth
                                        .instance.currentUser?.uid)));
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: const SizedBox(
              width: double.infinity,
              child: Center(child: Text('Reject')),
            ),
          ),
        ),
      ],
    );
  }

  Padding organizationCard() {
    return Padding(
      padding: kCardsPadding,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: kCardsInsidePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Organization', style: kCardTitleTextStyle),
              const SizedBox(height: 10),
              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewOrganization(
                              organization, organizationName)));
                },
                child: organizationDetailsCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox organizationDetailsCard() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: kCardsInsidePadding,
          child: Column(
            children: [
              Text(organizationName, style: kCardTitleTextStyle),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: kCardsInsidePadding,
                        child: Column(
                          children: [
                            Text(
                              'City',
                              style: kCardDescriptionTextStyle,
                            ),
                            Text(
                              organizationCity,
                              style: kCardQuantityTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: kCardsInsidePadding,
                        child: Column(
                          children: [
                            Text(
                              'District',
                              style: kCardDescriptionTextStyle,
                            ),
                            Text(
                              organizationDistrict,
                              style: kCardQuantityTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
