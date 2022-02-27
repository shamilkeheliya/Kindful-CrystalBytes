import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/utilities/cardTextStyles.dart';
import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/views/tabs/users/createUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UsersView extends StatefulWidget {
  @override
  _UsersViewState createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final Stream<QuerySnapshot> _Stream =
      FirebaseFirestore.instance.collection('users').snapshots();

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
        return Scaffold(
          floatingActionButton: buildAddUserFloatingActionButton(),
          body: ListView(
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
                        Text(data['name'], style: kCardTitleTextStyle),
                        Card(
                          child: Padding(
                            padding: kCardsInsidePadding,
                            child: Text(
                              data['type'] == 'admin' ? 'Admin' : 'Manager',
                              style: kCardQuantityTextStyle,
                            ),
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

  FloatingActionButton buildAddUserFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: kMainGreen,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreateUser()));
      },
      child: const Icon(Icons.add),
      hoverElevation: 10,
      hoverColor: kMainPurple,
    );
  }
}
