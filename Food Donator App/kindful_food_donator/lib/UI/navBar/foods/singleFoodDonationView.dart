import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kindful_food_donator/UI/navBar/foods/addOrganization.dart';
import 'package:kindful_food_donator/UI/navBar/search/viewOrganization.dart';
import 'package:kindful_food_donator/utilities/cardTextStyles.dart';
import 'package:kindful_food_donator/utilities/const.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
  String organization = '';

  String organizationName = 'Organization Name';
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
        organization = documentSnapshot['organization'];
      });
    });

    if (organization != '') {
      FirebaseFirestore.instance
          .collection('organizations')
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
                                : status == 'get'
                                    ? 'Get'
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
                visible: status == 'pending',
                child: const SizedBox(height: 15),
              ),
              Visibility(
                visible: status == 'pending',
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: const Text("Warning",
                              style: TextStyle(color: Colors.red)),
                          content: const Text(
                              'Do you want to delete Food Donation?'),
                          actions: [
                            TextButton(
                              child: const Text("Cancel",
                                  style: TextStyle(color: kMainPurple)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text("Delete",
                                  style: TextStyle(color: Colors.red)),
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
                                  SnackBarClass.kShowSuccessSnackBar(context);
                                  setState(() {
                                    isProssesing = false;
                                  });
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
                ),
              ),
            ],
          ),
        ),
      ),
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
              status == 'pending'
                  ? MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddOrganizationToDonation(widget.docID)));
                      },
                      child: kButtonBody('Add Organization'),
                    )
                  : MaterialButton(
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
        elevation: 5,
        child: Padding(
          padding: kCardsInsidePadding,
          child: Column(
            children: [
              Text(organizationName, style: kCardTitleTextStyle),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'City : ',
                    style: kCardDescriptionTextStyle,
                  ),
                  Text(
                    organizationCity,
                    style: kCardQuantityTextStyle,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'District : ',
                    style: kCardDescriptionTextStyle,
                  ),
                  Text(
                    organizationDistrict,
                    style: kCardQuantityTextStyle,
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
