import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../utilities/const.dart';

// ignore: use_key_in_widget_constructors
class FoodDetails extends StatefulWidget {
  @override
  _FoodDetailsState createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('food_donation')
      .orderBy('date')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SpinKitRing(
            color: kMainPurple,
            size: 50.0,
          );
        }

        bool isProssesing = false;

        return ModalProgressHUD(
          inAsyncCall: isProssesing,
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return Padding(
                padding: kCardsPadding,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title'],
                          style: const TextStyle(
                            fontSize: 25,
                            fontFamily: 'kindful',
                            color: kMainPurple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['description'],
                          style: const TextStyle(
                            fontSize: 15,
                            color: kMainPurple,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: data['status'] == 'pending'
                                      ? Colors.amber
                                      : data['status'] == 'get'
                                          ? Colors.lightBlue
                                          : Colors.green,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  data['status'] == 'pending'
                                      ? 'Pending'
                                      : data['status'] == 'get'
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
                                  data['date'].toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: kMainPurple,
                                  ),
                                ),
                                Text(
                                  'Quantity: ${data['quantity']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: kMainPurple,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
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
                                            .doc(document.id)
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
                          child: Container(
                            width: double.infinity,
                            child: Center(child: Text('Delete')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
