import 'package:flutter/material.dart';
import 'package:kindful_food_donator/const.dart';
import 'package:kindful_food_donator/firebase/accountClass.dart';
import 'package:kindful_food_donator/navBar.dart';
import 'package:kindful_food_donator/textField.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddFoodDonation extends StatefulWidget {
  String userID = '';
  String email = '';

  // ignore: use_key_in_widget_constructors
  SignUp(userID, email) {
    // ignore: prefer_initializing_formals
    this.userID = userID;
    // ignore: prefer_initializing_formals
    this.email = email;
  }

  // ignore: use_key_in_widget_constructors


  @override
  _AddFoodDonationState createState() => _AddFoodDonationState();
}

class _AddFoodDonationState extends State<AddFoodDonation> {

  TextFieldForm quantity= TextFieldForm();
  TextFieldForm description = TextFieldForm();
  TextFieldForm timelimit = TextFieldForm();

  String selectedStatus = kStatus[0];
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
            // Quantity
            //
    Padding(
    padding: kTextFieldPadding,
    child: TextField(
    decoration:
    kTextInputDecoration('Quantity', quantity.isValidate),
    cursorColor: kMainPurple,
    keyboardType: TextInputType.number,
    maxLength: 5,
    onChanged: (value) {
    setState(() {
    quantity.variableName = value;
    });
    },
    controller: quantity.textEditingController,
    ),
    ),
    //
    // Description
    //
    Padding(
    padding: kTextFieldPadding,
    child: TextField(
    decoration:
    kTextInputDecoration('Description', description.isValidate),
    cursorColor: kMainPurple,
    textCapitalization: TextCapitalization.words,
    maxLength: 100,
    onChanged: (value) {
    setState(() {
    description.variableName = value;
    });
    },
    controller: description.textEditingController,
    ),
      //
      //status
      //
    ),
    Padding(
    padding: kTextFieldPadding,
    child: kDropDownButtonDecoration(
    'Status',
    DropdownButton(
    underline: const SizedBox(),
    value: selectedStatus,
    onChanged: (value) {
    setState(() {
    selectedStatus = value.toString();
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
    // Terms & Privacy Policy
    //
    kTextTermsAndPrivacyPolicy(),
                  //
                  //Button
                  //
                  MaterialButton(
                    onPressed: () {
                      validateForm();

                    },
                    child: kButtonBody('Add Donation'),
                  ),
                ],
            ),
        ),
    );
  }

  validateForm() {
    setState(() {

    quantity.isValidate =
    description.textEditingController.text.isEmpty ? true : false;


    if (quantity.textEditingController.text.isEmpty ||
    description.textEditingController.text.isEmpty ||)
   {
    } else {
    setState(() {
    isProsessing = true;
    });
    addDonation();
    }
    });
    }
 /* addDonation() async {
    Accounts accounts = Accounts();
    bool result = await accounts.createAccount(
        widget.UserID,
        quantity.variableName,
        widget.email,
        description.variableName,
        city.variableName,
        selectedStatus,
       );*/

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
          content: const Text('Cannot Add Donation'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () => validateForm(),
          ),
        ),
      );
    }
  }
