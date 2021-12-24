import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kindful_food_donator/UI/signup.dart';
import 'package:kindful_food_donator/const.dart';
import 'package:kindful_food_donator/firebase/userClass.dart';
import 'package:kindful_food_donator/navBar.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isLoading = false;
  Users users = Users();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => currentUser());
  }

  currentUser() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavBar(user.uid),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Image.asset('images/logo.png'),
          ),
          isLoading
              ? SpinKitRing(
                  color: kMainPurple,
                  size: 50.0,
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () async {
                      await users.signInwithGoogle();
                      // ignore: await_only_futures
                      User? user = await FirebaseAuth.instance.currentUser;
                      bool isReg = await users.isRegister(user!.uid);

                      if (isReg == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavBar(user.uid),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(user.uid),
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.asset('images/google.png', height: 25),
                        ),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontFamily: 'kindful',
                            fontSize: 16,
                            color: kMainGreen,
                          ),
                        ),
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

// class UserInformation extends StatefulWidget {
//   @override
//   _UserInformationState createState() => _UserInformationState();
// }
//
// class _UserInformationState extends State<UserInformation> {
//   final Stream<QuerySnapshot> _usersStream =
//       FirebaseFirestore.instance.collection('test').snapshots();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _usersStream,
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Something went wrong');
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Text("Loading");
//           }
//
//           return ListView(
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               Map<String, dynamic> data =
//                   document.data()! as Map<String, dynamic>;
//               return ListTile(
//                 title: Text(data['test']),
//                 subtitle: Text(document.reference.id),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }
