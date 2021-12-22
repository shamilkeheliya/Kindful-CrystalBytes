import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kindful_organization/UI/signup.dart';
import 'package:kindful_organization/const.dart';
import 'package:kindful_organization/firebase/userClass.dart';
import 'package:kindful_organization/navBar.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  bool isLoading = true;
  Users users = Users();

  @override
  void initState() {
    super.initState();
    validateUser();
  }

  validateUser(){
    String userID = users.signInUser();
    if(userID != ''){
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => NavBar(userID),
        ),
      );
    }
    else{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: CircleBorder(),
              elevation: 18,
              child: Image.asset('images/logo.png'),
            ),
          ),
          isLoading ? SpinKitRing(
            color: kMainPurple,
            size: 50.0,
          ) : Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
            child: ElevatedButton(
              onPressed: (){
                // TODO: Sign Up
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => SignUp(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Image.asset('images/google.png',height: 25),
                  ),
                  Text('Continue with Google'),
                ],
              ),
              style: ElevatedButton.styleFrom(primary: kMainPurple),
            ),
          ),
        ],
      ),
    );
  }
}



class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('test').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['test']),
              subtitle: Text(document.reference.id),
            );
          }).toList(),
        );
      },
    );
  }
}
