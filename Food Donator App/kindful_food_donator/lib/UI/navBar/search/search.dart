import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kindful_food_donator/UI/navBar/search/viewOrganization.dart';
import 'package:kindful_food_donator/utilities/const.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchKey = '';
  bool isLoading = false;

  Stream<QuerySnapshot> _organizationsStreamFilter =
      FirebaseFirestore.instance.collection('organizations').snapshots();

  final Stream<QuerySnapshot> _organizationsStream = FirebaseFirestore.instance
      .collection('organizations')
      .where('verify', isEqualTo: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kMainPurple),
          backgroundColor: kMainGreen,
          automaticallyImplyLeading: false,
          title: CupertinoTextField(
            onChanged: (value) {
              setState(() {
                searchKey = value;
                _organizationsStreamFilter = FirebaseFirestore.instance
                    .collection('organizations')
                    .where('name', isGreaterThanOrEqualTo: value)
                    .where('name', isLessThan: value + 'z')
                    .where('verify', isEqualTo: true)
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
                      setState(() {
                        isLoading = true;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewOrganization(
                                    document.id, data['name'])));
                        isLoading = false;
                      });
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(data['name']),
                        subtitle:
                            Text('➥${data['city']}  ➥${data['district']}'),
                      ),
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
