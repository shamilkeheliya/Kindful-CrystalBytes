import 'package:cloud_firestore/cloud_firestore.dart';
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
  _FoodsDonationsListState createState() => _FoodsDonationsListState(userID);
}

class _FoodsDonationsListState extends State<FoodsDonationsList> {
  String userID = '';

  _FoodsDonationsListState(userID) {
    this.userID = userID;
  }

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('food_donation')
      // TODO: add where to filter user id
      //.where('donator', isEqualTo: userID)
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
