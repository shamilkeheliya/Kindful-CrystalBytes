import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kindful_food_donator/UI/navBar/foods/singleFoodDonationView.dart';
import 'package:kindful_food_donator/utilities/cardTextStyles.dart';
import 'package:kindful_food_donator/utilities/const.dart';

// ignore: use_key_in_widget_constructors
class FoodsDonationsList extends StatefulWidget {
  late String userID;

  FoodsDonationsList(userID) {
    this.userID = userID;
  }

  @override
  _FoodsDonationsListState createState() => _FoodsDonationsListState();
}

class _FoodsDonationsListState extends State<FoodsDonationsList> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('food_donation')
      .where('donator', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('date', descending: true)
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

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            return Padding(
              padding: kCardsPadding,
              child: MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SingleFoodDonation(document.id)));
                },
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title'],
                          style: kCardTitleTextStyle,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['description'],
                          style: kCardDescriptionTextStyle,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: data['status'] == 'pending'
                                      ? Colors.amber
                                      : data['status'] == 'done'
                                          ? Colors.green
                                          : Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  data['status'] == 'pending'
                                      ? 'Pending'
                                      : data['status'] == 'added'
                                          ? 'Added'
                                          : data['status'] == 'accepted'
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
                                  data['date'].toString(),
                                  style: kCardDateTextStyle,
                                ),
                                Text(
                                  'Quantity: ${data['quantity']}',
                                  style: kCardQuantityTextStyle,
                                ),
                              ],
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
    );
  }
}
