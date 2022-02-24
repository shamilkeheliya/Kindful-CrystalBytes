import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/utilities/cardTextStyles.dart';
import 'package:dashboard/utilities/const.dart';
import '../../viewReport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OrganizationReports extends StatefulWidget {
  @override
  _OrganizationReportsState createState() => _OrganizationReportsState();
}

class _OrganizationReportsState extends State<OrganizationReports> {
  final Stream<QuerySnapshot> _Stream = FirebaseFirestore.instance
      .collection('reports')
      .where('read', isEqualTo: false)
      .where('reporteeType', isEqualTo: 'organization')
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
                      Card(
                        child: Padding(
                          padding: kCardsInsidePadding,
                          child: Column(
                            children: [
                              Text(
                                'Date',
                                style: kCardDescriptionTextStyle,
                              ),
                              Text(
                                data['date'],
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
                                'Reported By',
                                style: kCardDescriptionTextStyle,
                              ),
                              Text(
                                data['reporterType'] == 'donator'
                                    ? 'Donator'
                                    : 'Food Donator',
                                style: kCardQuantityTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: kCardsInsidePadding,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewReport(document.id)));
                          },
                          child: const Text('View Report'),
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
