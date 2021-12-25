import 'package:flutter/material.dart';
import 'package:kindful_food_donator/const.dart';
import 'package:kindful_food_donator/textField.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class SignUp extends StatefulWidget {
  String userID = '';

  // ignore: use_key_in_widget_constructors
  SignUp(userID) {
    this.userID = userID;
  }

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextFieldForm name = TextFieldForm();
  TextFieldForm city = TextFieldForm();
  TextFieldForm district = TextFieldForm();
  TextFieldForm type = TextFieldForm();
  TextFieldForm phone = TextFieldForm();

  String selectedDistrict = kDistricts[0];
  String selectedType = kTypes[0];

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
                decoration: kTextInputDecoration('Phone Number', phone.isValidate),
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
            // City
            //
            Padding(
              padding: kTextFieldPadding,
              child: TextField(
                decoration: kTextInputDecoration('City', city.isValidate),
                textCapitalization: TextCapitalization.words,
                maxLength: 50,
                onChanged: (value) {
                  setState(() {
                    city.variableName = value;
                  });
                },
                controller: city.textEditingController,
              ),
            ),//
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
                  onChanged: (value){
                    setState(() {
                      selectedDistrict = value.toString();
                      district.variableName = selectedDistrict;
                    });
                  },
                  items: kDistricts.map((valueItem){
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
            // Type
            //
            Padding(
              padding: kTextFieldPadding,
              child: kDropDownButtonDecoration(
                'Type',
                DropdownButton(
                  underline: const SizedBox(),
                  value: selectedType,
                  onChanged: (value){
                    setState(() {
                      selectedType = value.toString();
                      type.variableName = selectedType;
                    });
                  },
                  items: kTypes.map((valueItem){
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                ),
              ),
            ),
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
      phone.isValidate = phone.textEditingController.text.isEmpty ? true : false;
      city.isValidate = city.textEditingController.text.isEmpty ? true : false;

      if(name.textEditingController.text.isEmpty || phone.textEditingController.text.isEmpty || city.textEditingController.text.isEmpty){
      }else{
        setState(() {
          isProsessing = true;
        });
      }
    });
  }

  createAccount(){
    try{

    }
    catch(error){
      setState(() {
        isProsessing = false;
      });
    }
  }
}
