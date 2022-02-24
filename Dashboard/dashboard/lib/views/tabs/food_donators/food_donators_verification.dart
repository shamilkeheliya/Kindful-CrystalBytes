import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/utilities/cardTextStyles.dart';
import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/views/tabs/organiztions/organization_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FoodDonatorsVerification extends StatefulWidget {
  @override
  _FoodDonatorsVerificationState createState() =>
      _FoodDonatorsVerificationState();
}

class _FoodDonatorsVerificationState extends State<FoodDonatorsVerification> {
  final Stream<QuerySnapshot> _Stream = FirebaseFirestore.instance
      .collection('food_donators')
      .where('verify', isEqualTo: false)
      .where('requestVerify', isEqualTo: true)
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
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: kCardsInsidePadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(data['name'], style: kCardTitleTextStyle),
                          Card(
                            child: Padding(
                              padding: kCardsInsidePadding,
                              child: Text(
                                data['type'],
                                style: kCardQuantityTextStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Card(
                            child: Padding(
                              padding: kCardsInsidePadding,
                              child: Column(
                                children: [
                                  Text(
                                    'City',
                                    style: kCardDescriptionTextStyle,
                                  ),
                                  Text(
                                    data['city'],
                                    style: kCardQuantityTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
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
                        ],
                      ),
                      Padding(
                        padding: kCardsInsidePadding,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrganizationView(
                                        document.id, data['name'])));
                          },
                          child: const Text('View Profile'),
                          style: ElevatedButton.styleFrom(primary: kMainPurple),
                        ),
                      ),
                    ],
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
