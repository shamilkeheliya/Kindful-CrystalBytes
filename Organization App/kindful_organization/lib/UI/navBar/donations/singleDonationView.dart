import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kindful_organization/UI/navBar/donations/addDonator.dart';
import 'package:kindful_organization/UI/navBar/donations/viewDonator.dart';
import 'package:kindful_organization/utilities/cardTextStyles.dart';
import 'package:kindful_organization/utilities/const.dart';
import 'package:kindful_organization/utilities/navBar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
  String donator = '';

  String donatorName = 'Donator Name';
  String donatorCity = 'City';
  String donatorDistrict = 'District';

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
        donator = documentSnapshot['donator'];
      });
    });

    if (donator != '') {
      FirebaseFirestore.instance
          .collection('donators')
          .doc(donator)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        setState(() {
          donatorName = documentSnapshot['name'];
          //donatorCity = documentSnapshot['city'];
          donatorDistrict = documentSnapshot['district'];
        });
      });
    }
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
                  Container(
                    decoration: BoxDecoration(
                        color: status == 'pending'
                            ? Colors.amber
                            : status == 'done'
                                ? Colors.green
                                : Colors.lightBlue,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        status == 'pending'
                            ? 'Pending'
                            : status == 'added'
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
                visible: status == 'pending' || status == 'accepted',
                child: const SizedBox(height: 15),
              ),
              Visibility(
                visible: status == 'pending',
                child: buttonForPending(),
              ),
              Visibility(
                visible: status == 'accepted',
                child: buttonForAccepted(),
              )
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
              status == 'pending'
                  ? MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddDonatorToDonation(widget.docID)));
                      },
                      child: kButtonBody('Add Donator'),
                    )
                  : MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ViewDonator(donator, donatorName)));
                      },
                      child: donatorDetailsCard(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton buttonForPending() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text("Warning", style: TextStyle(color: Colors.red)),
              content: const Text('Do you want to delete Food Donation?'),
              actions: [
                TextButton(
                  child: const Text("Cancel",
                      style: TextStyle(color: kMainPurple)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child:
                      const Text("Delete", style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    setState(() {
                      isProssesing = true;
                    });
                    Navigator.pop(context);
                    FirebaseFirestore.instance
                        .collection('food_donation')
                        .doc(widget.docID)
                        .delete()
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (contex) => NavBar(
                                  FirebaseAuth.instance.currentUser?.uid)));
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
      style: ElevatedButton.styleFrom(primary: Colors.red),
      child: const SizedBox(
        width: double.infinity,
        child: Center(child: Text('Delete Food Donation')),
      ),
    );
  }

  ElevatedButton buttonForAccepted() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title:
                  const Text("Confirm", style: TextStyle(color: Colors.green)),
              content: const Text('Is this donation done?'),
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
                        .update({'status': 'done'}).then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (contex) => NavBar(
                                  FirebaseAuth.instance.currentUser?.uid)));
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
        child: Center(child: Text('Donation Done')),
      ),
    );
  }

  SizedBox donatorDetailsCard() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: kCardsInsidePadding,
          child: Column(
            children: [
              Text(donatorName, style: kCardTitleTextStyle),
              Row(
                children: [
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
                              donatorDistrict,
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
