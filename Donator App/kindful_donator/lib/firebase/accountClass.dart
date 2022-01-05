import 'package:cloud_firestore/cloud_firestore.dart';

class Accounts{
  Future<bool> createAccount(id,name,email,phone,district) async {

    bool result = false;

    await FirebaseFirestore.instance
        .collection('donators')
        .doc(id)
        .set({
          'name': name,
          'email': email,
          'phone': phone,
          'district': district,
          'verify': false,
          'requestVerify': false
        }).then((value){
          result = true;
        }).catchError((error) {
          result = false;
          print(error.toString());
        });

    return result;
  }
}