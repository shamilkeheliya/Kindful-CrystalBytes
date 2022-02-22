import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kindful_organization/UI/navBar/foods/singleFoodDonationView.dart';
import 'package:kindful_organization/utilities/cardTextStyles.dart';
import 'package:kindful_organization/utilities/const.dart';

class FoodsList extends StatefulWidget {
  late String userID;

  FoodsList(userID) {
    this.userID = userID;
  }

  @override
  _FoodsListState createState() => _FoodsListState();
}

class _FoodsListState extends State<FoodsList> {
  final Stream<QuerySnapshot> _Stream = FirebaseFirestore.instance
      .collection('food_donation')
      .where('organization', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('date', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _Stream,
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
                              SingleFoodDonationView(document.id)));
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
                                  color: data['status'] == 'added'
                                      ? Colors.amber
                                      : data['status'] == 'accepted'
                                          ? Colors.lightBlue
                                          : Colors.green,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  data['status'] == 'added'
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
