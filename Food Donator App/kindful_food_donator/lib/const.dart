import 'package:flutter/material.dart';

const kMainGreen = Color(0xFF59E287);
const kMainPurple = Color(0xFF4840B8);

const kFABShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)));

const kFABIcon = Icon(Icons.add, color: kMainPurple, size: 40);

const kTextFieldPadding = EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0);

InputDecoration kTextInputDecoration(label, isValidate) {
  return InputDecoration(
    labelText: label,
    errorText: isValidate ? 'Field Cannot Be Empty' : null,
    border: OutlineInputBorder(),
    floatingLabelStyle: TextStyle(
      color: kMainPurple,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: kMainPurple,
      ),
    ),
  );
}

Padding kTextTermsAndPrivacyPolicy() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('By creating profile, you agree to app'),
        TextButton(
          onPressed: () {},
          //onPressed: () => launch(''),
          child: Text('Terms & Privacy Policy'),
        ),
      ],
    ),
  );
}

const List<String> kDistricts = <String>[
  'Ampara',
  'Anuradhapura',
  'Badulla',
  'Colombo',
  'Kandy',
];
