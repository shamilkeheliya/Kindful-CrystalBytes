import 'package:flutter/material.dart';
import 'package:kindful_food_donator/const.dart';
import 'package:kindful_food_donator/textField.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class Verify extends StatefulWidget {
  late String uid;

  // ignore: use_key_in_widget_constructors
  Verify(uid) {
    // ignore: prefer_initializing_formals
    this.uid = uid;
  }

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  TextFieldForm address = TextFieldForm();
  TextFieldForm regNumber = TextFieldForm();

  bool isProsessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar('Request Verify', true),
      body: ModalProgressHUD(
        inAsyncCall: isProsessing,
        child: ListView(
          children: [
            const SizedBox(height: 10),
            //
            // Address
            //
            Padding(
              padding: kTextFieldPadding,
              child: TextField(
                decoration: kTextInputDecoration('Address', address.isValidate),
                cursorColor: kMainPurple,
                maxLines: 5,
                textCapitalization: TextCapitalization.words,
                maxLength: 200,
                onChanged: (value) {
                  setState(() {
                    address.variableName = value;
                  });
                },
                controller: address.textEditingController,
              ),
            ),
            //
            // Reg Number
            //
            Padding(
              padding: kTextFieldPadding,
              child: TextField(
                decoration: kTextInputDecoration(
                    'Business Registration Number', regNumber.isValidate),
                cursorColor: kMainPurple,
                maxLength: 20,
                onChanged: (value) {
                  setState(() {
                    regNumber.variableName = value;
                  });
                },
                controller: regNumber.textEditingController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
