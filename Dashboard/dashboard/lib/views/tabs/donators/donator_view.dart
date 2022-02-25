import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/utilities/cardTextStyles.dart';
import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/views/home.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class DonatorView extends StatefulWidget {
  late String organizationID, organizationName;
  DonatorView(this.organizationID, this.organizationName);
  @override
  _DonatorViewState createState() => _DonatorViewState();
}

class _DonatorViewState extends State<DonatorView> {
  String email = 'Email';
  String district = 'District';
  String phone = 'Phone Number';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await FirebaseFirestore.instance
        .collection('donators')
        .doc(widget.organizationID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        email = documentSnapshot['email'];
        district = documentSnapshot['district'];
        phone = documentSnapshot['phone'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kMainPurple,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                icon: Icon(Icons.home)),
          ],
          title: Text(
            widget.organizationName,
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
                  widget.organizationName,
                  style: kCardTitleTextStyle,
                ),
                ListTile(
                  leading: const Icon(Icons.location_city_outlined),
                  title: Text(district, style: kCardQuantityTextStyle),
                  subtitle: const Text('District'),
                ),
                ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: Text(phone, style: kCardQuantityTextStyle),
                  subtitle: const Text('Phone Number'),
                ),
                ListTile(
                  leading: const Icon(Icons.alternate_email),
                  title: Text(email, style: kCardQuantityTextStyle),
                  subtitle: const Text('Email'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
