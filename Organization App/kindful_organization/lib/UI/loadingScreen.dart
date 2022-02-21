import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kindful_organization/UI/signup.dart';
import '../utilities/const.dart';
import 'package:kindful_organization/firebase/userClass.dart';
import '../utilities/navBar.dart';

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
                            builder: (context) => SignUp(user.uid, user.email),
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
