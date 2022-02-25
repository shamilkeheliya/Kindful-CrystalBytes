import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/utilities/cardTextStyles.dart';
import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/views/tabs/donations/donation_view.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AllDonations extends StatefulWidget {
  @override
  _AllDonationsState createState() => _AllDonationsState();
}

class _AllDonationsState extends State<AllDonations> {
  final Stream<QuerySnapshot> _Stream = FirebaseFirestore.instance
      .collection('donation')
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
              child: Card(
                child: ExpandablePanel(
                  header: Padding(
                    padding: kCardsInsidePadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data['title']),
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
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DonationView(
                                        document.id, data['title'])));
                          },
                          child: const Text('View Donation'),
                          style: ElevatedButton.styleFrom(primary: kMainPurple),
                        ),
                      ],
                    ),
                  ),
                  collapsed: Container(),
                  expanded: Text(
                    data['description'],
                    softWrap: true,
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
