import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kindful_organization/utilities/cardTextStyles.dart';
import 'package:kindful_organization/utilities/const.dart';
import 'package:kindful_organization/utilities/navBar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddDonatorToDonation extends StatefulWidget {
  late String docID;
  AddDonatorToDonation(this.docID);
  @override
  _AddDonatorToDonationState createState() => _AddDonatorToDonationState();
}

class _AddDonatorToDonationState extends State<AddDonatorToDonation> {
  String searchKey = '';
  bool isLoading = false;

  Stream<QuerySnapshot> _donatorsStreamFilter =
      FirebaseFirestore.instance.collection('donators').snapshots();

  final Stream<QuerySnapshot> _donatorsStream =
      FirebaseFirestore.instance.collection('donators').snapshots();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kMainPurple),
          backgroundColor: kMainGreen,
          title: CupertinoTextField(
            onChanged: (value) {
              setState(() {
                searchKey = value;
                _donatorsStreamFilter = FirebaseFirestore.instance
                    .collection('donators')
                    .where('name', isGreaterThanOrEqualTo: value)
                    .where('name', isLessThan: value + 'z')
                    .snapshots();
              });
            },
            placeholder: 'Search Donators',
            autocorrect: false,
            textCapitalization: TextCapitalization.words,
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: searchKey == '' ? _donatorsStream : _donatorsStreamFilter,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SpinKitRing(
                color: kMainPurple,
                size: 50.0,
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return Padding(
                  padding: kCardsPadding,
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: const Text("Are you sure?"),
                            content: Text(
                                'Do you want to add ${data['name']} to your request?'),
                            actions: [
                              TextButton(
                                child: const Text("No",
                                    style: TextStyle(color: kMainPurple)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text("Yes",
                                    style: TextStyle(color: kMainPurple)),
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  FirebaseFirestore.instance
                                      .collection('donation')
                                      .doc(widget.docID)
                                      .update({
                                    'donator': document.id,
                                    'status': 'added',
                                  }).then((value) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NavBar(
                                                FirebaseAuth.instance
                                                    .currentUser?.uid)));
                                    setState(() {
                                      isLoading = false;
                                      SnackBarClass.kShowSuccessSnackBar(
                                          context);
                                    });
                                  }).catchError((e) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Adding Failed')),
                                    );
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: kCardsInsidePadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['name'], style: kCardTitleTextStyle),
                            const SizedBox(height: 10),
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
                                            data['district'],
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
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
