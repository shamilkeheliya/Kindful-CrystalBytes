import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/utilities/cardTextStyles.dart';
import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/views/home.dart';
import 'package:dashboard/views/tabs/donators/donator_view.dart';
import 'package:dashboard/views/tabs/organiztions/organization_view.dart';
import 'package:flutter/material.dart';

class DonationView extends StatefulWidget {
  late String docId, title;
  DonationView(this.docId, this.title);
  @override
  _DonationViewState createState() => _DonationViewState();
}

class _DonationViewState extends State<DonationView> {
  String date = 'Date';
  String description = 'Description';
  String donator = '';
  String donatorName = 'Donator';
  String organization = '';
  String organizationName = 'Organization';
  String quantity = 'Quantity';
  String status = 'Status';
  String title = 'Title';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await FirebaseFirestore.instance
        .collection('donation')
        .doc(widget.docId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        title = documentSnapshot['title'];
        description = documentSnapshot['description'];
        date = documentSnapshot['date'];
        organization = documentSnapshot['organization'];
        quantity = documentSnapshot['quantity'];
        status = documentSnapshot['status'];
        donator = documentSnapshot['donator'];
      });
    });

    await FirebaseFirestore.instance
        .collection('organizations')
        .doc(organization)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        organizationName = documentSnapshot['name'];
      });
    });

    if (status != 'pending') {
      await FirebaseFirestore.instance
          .collection('donators')
          .doc(donator)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        setState(() {
          donatorName = documentSnapshot['name'];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kMainPurple,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              icon: const Icon(Icons.home)),
        ],
        title: Text(
          widget.title,
          style: const TextStyle(fontFamily: 'kindful'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 30,
          horizontal: MediaQuery.of(context).size.width / 30,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              mainDetailsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Center mainDetailsCard() {
    return Center(
      child: SizedBox(
        width: 500,
        child: Card(
          child: Padding(
            padding: kCardsInsidePadding,
            child: Column(
              children: [
                Text(
                  title,
                  style: kCardTitleTextStyle,
                ),
                ListTile(
                  tileColor: status == 'pending'
                      ? Colors.yellowAccent
                      : status == 'done'
                          ? Colors.green
                          : Colors.lightBlue,
                  title: Text(
                    status == 'pending'
                        ? 'Pending'
                        : status == 'added'
                            ? 'Added'
                            : status == 'accepted'
                                ? 'Accepted'
                                : 'Done',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: const Text('Status'),
                ),
                ListTile(
                  title: Text(quantity, style: kCardQuantityTextStyle),
                  subtitle: const Text('Quantity'),
                ),
                ListTile(
                  title: Text(date, style: kCardQuantityTextStyle),
                  subtitle: const Text('Date'),
                ),
                ListTile(
                  title: Text(description, style: kCardQuantityTextStyle),
                  subtitle: const Text('Donation Description'),
                ),
                ListTile(
                  title: Text(organizationName, style: kCardQuantityTextStyle),
                  subtitle: const Text('Organization'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrganizationView(
                                organization, organizationName)));
                  },
                ),
                Visibility(
                  visible: status != 'pending',
                  child: ListTile(
                    title: Text(donatorName, style: kCardQuantityTextStyle),
                    subtitle: const Text('Donator'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DonatorView(donator, donatorName)));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
