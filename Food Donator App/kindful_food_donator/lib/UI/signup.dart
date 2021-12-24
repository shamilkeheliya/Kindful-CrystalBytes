import 'package:flutter/material.dart';
import 'package:kindful_food_donator/const.dart';
import 'package:kindful_food_donator/textField.dart';

// ignore: must_be_immutable
class SignUp extends StatefulWidget {
  String userID = '';

  SignUp(userID) {
    this.userID = userID;
  }

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextFieldForm name = new TextFieldForm();
  TextFieldForm city = new TextFieldForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kMainGreen,
        title: Text(
          'Create Account',
          style: TextStyle(
            fontFamily: 'kindful',
            color: kMainPurple,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),
          //
          // Name
          //
          Padding(
            padding: kTextFieldPadding,
            child: TextField(
              decoration: kTextInputDecoration('Name', name.isValidate),
              cursorColor: kMainPurple,
              textCapitalization: TextCapitalization.words,
              maxLength: 50,
              onChanged: (value) {
                setState(() {
                  name.variableName = value;
                });
              },
              controller: name.textEditingController,
            ),
          ),
          Padding(
            padding: kTextFieldPadding,
            child: TextField(
              decoration: kTextInputDecoration('City', city.isValidate),
              maxLength: 50,
              onChanged: (value) {
                setState(() {
                  city.variableName = value;
                });
              },
              controller: city.textEditingController,
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         'District',
          //         textAlign: TextAlign.left,
          //         style: TextStyle(color: Colors.grey),
          //       ),
          //       Autocomplete<String>(
          //         optionsBuilder: (TextEditingValue textEditingValue) {
          //           if (textEditingValue.text == '') {
          //             setState(() {
          //               district = '';
          //             });
          //             return kDistricts;
          //           }
          //           return kDistricts.where((String option) {
          //             return option
          //                 .contains(textEditingValue.text.toLowerCase());
          //           });
          //         },
          //         onSelected: (String selection) {
          //           setState(() {
          //             district = selection;
          //           });
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(height: 25),
          // Button
          MaterialButton(
            onPressed: () {
              validateForm();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: kMainPurple,
              ),
              height: 50,
              child: Center(
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    color: kMainGreen,
                    fontFamily: 'kindful',
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  validateForm() {
    setState(() {
      name.isValidate = name.textEditingController.text.isEmpty ? true : false;
      city.isValidate = city.textEditingController.text.isEmpty ? true : false;
    });
  }
}
