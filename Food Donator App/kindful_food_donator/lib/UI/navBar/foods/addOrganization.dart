import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kindful_food_donator/utilities/cardTextStyles.dart';
import 'package:kindful_food_donator/utilities/const.dart';
import 'package:kindful_food_donator/utilities/navBar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddOrganizationToDonation extends StatefulWidget {
  late String docID;
  AddOrganizationToDonation(this.docID);
  @override
  _AddOrganizationToDonationState createState() =>
      _AddOrganizationToDonationState();
}

class _AddOrganizationToDonationState extends State<AddOrganizationToDonation> {
  String searchKey = '';
  bool isLoading = false;

  Stream<QuerySnapshot> _organizationsStreamFilter =
      FirebaseFirestore.instance.collection('organizations').snapshots();

  final Stream<QuerySnapshot> _organizationsStream =
      FirebaseFirestore.instance.collection('organizations').snapshots();

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
                _organizationsStreamFilter = FirebaseFirestore.instance
                    .collection('organizations')
                    .where('name', isGreaterThanOrEqualTo: value)
                    .where('name', isLessThan: value + 'z')
                    .snapshots();
              });
            },
            placeholder: 'Search Organizations',
            autocorrect: false,
            textCapitalization: TextCapitalization.words,
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: searchKey == ''
              ? _organizationsStream
              : _organizationsStreamFilter,
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
                                'Do you want to add ${data['name']} to your donation?'),
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
                                      .collection('food_donation')
                                      .doc(widget.docID)
                                      .update({
                                    'organization': document.id,
                                    'status': 'get',
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
                    child: ListTile(
                      title: Text(data['name']),
                      subtitle: Text('➥${data['city']}  ➥${data['district']}'),
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
