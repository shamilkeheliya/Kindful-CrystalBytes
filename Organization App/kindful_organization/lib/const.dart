import 'package:flutter/material.dart';

const kMainGreen = Color(0xFF59E287);
const kMainPurple = Color(0xFF4840B8);

const kDefaltIcon =
    'https://firebasestorage.googleapis.com/v0/b/kindful-6b6dd.appspot.com/o/Kindful%2Fic_launcher.png?alt=media&token=03b29c45-0310-484b-8f8a-755a80391547';

ListTile kProfileListTile(icon, title, tileName) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(tileName),
  );
}

AppBar kAppBar(String title, bool backButton) {
  return AppBar(
    centerTitle: true,
    automaticallyImplyLeading: backButton,
    backgroundColor: kMainGreen,
    title: Text(
      title,
      style: const TextStyle(
        fontFamily: 'kindful',
        color: kMainPurple,
      ),
    ),
  );
}

const kFABShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)));

const kFABIcon = Icon(Icons.add, color: kMainPurple, size: 40);

const kTextFieldPadding = EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0);

InputDecoration kTextInputDecoration(label, isValidate) {
  return InputDecoration(
    labelText: label,
    errorText: isValidate ? 'Field Cannot Be Empty' : null,
    border: const OutlineInputBorder(),
    floatingLabelStyle: const TextStyle(
      color: kMainPurple,
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: kMainPurple,
      ),
    ),
  );
}

InputDecorator kDropDownButtonDecoration(label, dropDown) {
  return InputDecorator(
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
    child: Container(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
          dropDown,
        ],
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
        const Text('By creating account, You agree to app'),
        TextButton(
          onPressed: () {},
          //onPressed: () => launch(''),
          child: const Text('Terms & Privacy Policy'),
        ),
      ],
    ),
  );
}

Container kButtonBody(lable) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: kMainPurple,
    ),
    height: 50,
    child: Center(
      child: Text(
        lable,
        style: const TextStyle(
          color: kMainGreen,
          fontFamily: 'kindful',
          fontSize: 18,
        ),
      ),
    ),
  );
}

class SnackBarClass {
  static kShowSuccessSnackBar(context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Success!'),
        action: SnackBarAction(
          label: 'OKAY',
          onPressed: () {},
        ),
      ),
    );
  }
}

const List<String> kDistricts = <String>[
  'Ampara',
  'Anuradhapura',
  'Badulla',
  'Batticaloa',
  'Colombo',
  'Galle',
  'Gampaha',
  'Hambantota',
  'Jaffna',
  'Kalutara',
  'Kandy',
  'Kegalle',
  'Kilinochchi',
  'Kurunegala',
  'Mannar',
  'Matale',
  'Matara',
  'Moneragala',
  'Mullaitivu',
  'Nuwara Eliya',
  'Polonnaruwa',
  'Puttalam',
  'Ratnapura',
  'Trincomalee',
  'Vavuniya'
];

const List<String> kTypes = <String>[
  'Children\'s Home',
  'Child Rehabilitation Center',
  'Elders Home',
  'Other Organisation',
];
