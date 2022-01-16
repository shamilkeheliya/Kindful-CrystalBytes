import 'package:cloud_firestore/cloud_firestore.dart';

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
}
