import 'package:flutter/material.dart';
import 'package:kindful_donator/NavBar.dart';
import 'package:kindful_donator/const.dart';
import 'package:kindful_donator/firebase/accountClass.dart';
import 'package:kindful_donator/textField.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class SignUp extends StatefulWidget {
  String userID = '';
  String email = '';

  // ignore: use_key_in_widget_constructors
  SignUp(userID, email) {
    // ignore: prefer_initializing_formals
    this.userID = userID;
    // ignore: prefer_initializing_formals
    this.email = email;
  }

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextFieldForm name = TextFieldForm();
  TextFieldForm phone = TextFieldForm();

  String selectedDistrict = kDistricts[0];

  bool isProsessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kMainGreen,
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontFamily: 'kindful',
            color: kMainPurple,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isProsessing,
        child: ListView(
          children: [
            const SizedBox(height: 10),
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
            //
            // Phone Number
            //
            Padding(
              padding: kTextFieldPadding,
              child: TextField(
                decoration:
                    kTextInputDecoration('Phone Number', phone.isValidate),
                cursorColor: kMainPurple,
                keyboardType: TextInputType.number,
                maxLength: 10,
                onChanged: (value) {
                  setState(() {
                    phone.variableName = value;
                  });
                },
                controller: phone.textEditingController,
              ),
            ),
            //
            // District
            //
            Padding(
              padding: kTextFieldPadding,
              child: kDropDownButtonDecoration(
                'District',
                DropdownButton(
                  underline: const SizedBox(),
                  value: selectedDistrict,
                  onChanged: (value) {
                    setState(() {
                      selectedDistrict = value.toString();
                    });
                  },
                  items: kDistricts.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                ),
              ),
            ),
            //
            // SizedBox
            //
            const SizedBox(height: 15),
            //
            // Terms & Privacy Policy
            //
            kTextTermsAndPrivacyPolicy(),
            //
            // Button
            //
            MaterialButton(
              onPressed: () {
                validateForm();
              },
              child: kButtonBody('Create Account'),
            ),
          ],
        ),
      ),
    );
  }

  validateForm() {
    setState(() {
      name.isValidate = name.textEditingController.text.isEmpty ? true : false;
      phone.isValidate =
          phone.textEditingController.text.isEmpty ? true : false;

      if (name.textEditingController.text.isEmpty ||
          phone.textEditingController.text.isEmpty) {
      } else {
        setState(() {
          isProsessing = true;
        });
        createAccount();
      }
    });
  }

  createAccount() async {
    Accounts accounts = Accounts();
    bool result = await accounts.createAccount(widget.userID, name.variableName,
        widget.email, phone.variableName, selectedDistrict);

    if (result) {
      SnackBarClass.kShowSuccessSnackBar(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavBar(widget.userID),
        ),
      );
    } else {
      setState(() {
        isProsessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cannot Create Account'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () => validateForm(),
          ),
        ),
      );
    }
  }
}
