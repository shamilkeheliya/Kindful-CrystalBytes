import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kindful_organization/firebase/userClass.dart';
import 'package:kindful_organization/main.dart';

class Accounts {
  Future<bool> createAccount(
      id, name, email, phone, city, district, address, type) async {
    bool result = false;

    await FirebaseFirestore.instance.collection('organizations').doc(id).set({
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'district': district,
      'address': address,
      'type': type,
      'verify': false,
      'requestVerify': false
    }).then((value) {
      result = true;
    }).catchError((error) {
      result = false;
      print(error.toString());
    });

    return result;
  }

  deleteAccount(context, uid) {
    //
    // 1st Alert Dialog
    //
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Warning", style: TextStyle(color: Colors.red)),
          content: Text(
              'If you delete the account, We will delete all your data and you will not be able to retrieve it in anyway.'),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child:
                  Text("Delete Account", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context);
                //
                // 2nd Alert Dialog
                //
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title:
                          Text("Warning", style: TextStyle(color: Colors.red)),
                      content:
                          Text('Do you really want to delete your account?'),
                      actions: [
                        TextButton(
                          child:
                              Text("Yes", style: TextStyle(color: Colors.red)),
                          onPressed: () {
                            //
                            // Delete Document
                            //
                            FirebaseFirestore.instance
                                .collection('organizations')
                                .doc(uid)
                                .delete()
                                .then((value) async {
                              Users user = Users();
                              await user.signOutFromGoogle();
                              RestartWidget.restartApp(context);
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Cannot Delete Account'),
                                ),
                              );
                            });
                          },
                        ),
                        TextButton(
                          child: Text("No"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
