// ignore: file_names
import 'package:flutter/material.dart';
import 'package:kindful_food_donator/const.dart';
import 'package:kindful_food_donator/firebase/accountClass.dart';
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
  TextFieldForm title = TextFieldForm();
  TextFieldForm quantity = TextFieldForm();
  TextFieldForm description = TextFieldForm();
  late TimeOfDay expireTime;
  String selectedTime = '00:00';

  bool isProsessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kMainGreen,
        title: const Text(
          'Add Foods',
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
            // Food Title
            //
            Padding(
              padding: kTextFieldPadding,
              child: TextField(
                decoration:
                    kTextInputDecoration('Food Titile', title.isValidate),
                cursorColor: kMainPurple,
                textCapitalization: TextCapitalization.words,
                maxLength: 30,
                onChanged: (value) {
                  setState(() {
                    title.variableName = value;
                  });
                },
                controller: title.textEditingController,
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
                maxLength: 150,
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    description.variableName = value;
                  });
                },
                controller: description.textEditingController,
              ),
            ),
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
                onChanged: (value) {
                  setState(() {
                    quantity.variableName = value;
                  });
                },
                controller: quantity.textEditingController,
              ),
            ),
            //
            // Time
            //
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    //selectedTime = getTime().toString();
                    //print(getTime().timeout(timeLimit));
                  });
                },
                padding: EdgeInsets.zero,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 5),
                          Icon(Icons.lock_clock),
                          SizedBox(width: 5),
                          Text('Expire Time'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(selectedTime),
                          SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //
            //Button
            //
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () {
                //validateForm();
              },
              child: kButtonBody('Add Food Donation'),
            ),
          ],
        ),
      ),
    );
  }

  Future<TimeOfDay?> getTime() {
    Future<TimeOfDay?> selectedTime = showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return selectedTime;
  }

  validateForm() {
    setState(() {
      title.isValidate =
          title.textEditingController.text.isEmpty ? true : false;
      quantity.isValidate =
          quantity.textEditingController.text.isEmpty ? true : false;
      description.isValidate =
          description.textEditingController.text.isEmpty ? true : false;

      if (quantity.textEditingController.text.isEmpty ||
          description.textEditingController.text.isEmpty) {
      } else {
        setState(() {
          isProsessing = true;
        });
        //addDonation();
      }
    });
  }
  /*addDonation() async {
    Accounts accounts = Accounts();
    // bool result = await accounts.createAccount(
    //     widget.UserID,
    //     quantity.variableName,
    //     widget.email,
    //     description.variableName,
    //     city.variableName,
    //     selectedStatus,
    //    );

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
    }*/
}
