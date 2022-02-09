import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  bool isProssesing = false;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('food_donators')
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
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
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
                                  : status == 'get'
                                      ? Colors.lightBlue
                                      : Colors.green,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              status == 'pending'
                                  ? 'Pending'
                                  : status == 'get'
                                      ? 'Get'
                                      : 'Done',
                              style: TextStyle(fontFamily: 'kindful'),
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
                                        SnackBarClass.kShowSuccessSnackBar(
                                            context);
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
                          child: Center(child: Text('Delete')),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
