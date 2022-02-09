import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'utilities/const.dart';
import 'utilities/navBar.dart';
import 'utilities/textField.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddFoodDonation extends StatefulWidget {
  String userID = '';

  // ignore: use_key_in_widget_constructors
  AddFoodDonation(userID) {
    this.userID = userID;
  }

  // ignore: use_key_in_widget_constructors

  @override
  _AddFoodDonationState createState() => _AddFoodDonationState();
}

class _AddFoodDonationState extends State<AddFoodDonation> {
  TextFieldForm title = TextFieldForm();
  TextFieldForm quantity = TextFieldForm();
  TextFieldForm description = TextFieldForm();

  String hours = kHours[0];
  String min = kMins[0];

  bool isProsessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kMainGreen,
        title: const Text(
          'Add Food Donation',
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
                textCapitalization: TextCapitalization.sentences,
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
              padding: kTextFieldPadding,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Expire Time',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 10),
                      kDropDownButtonDecoration(
                        'Hours',
                        DropdownButton(
                          underline: const SizedBox(),
                          value: hours,
                          onChanged: (value) {
                            setState(() {
                              hours = value.toString();
                            });
                          },
                          items: kHours.map((valueItem) {
                            return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      kDropDownButtonDecoration(
                        'Minutes',
                        DropdownButton(
                          underline: const SizedBox(),
                          value: min,
                          onChanged: (value) {
                            setState(() {
                              min = value.toString();
                            });
                          },
                          items: kMins.map((valueItem) {
                            return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem),
                            );
                          }).toList(),
                        ),
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
                validateForm();
              },
              child: kButtonBody('Add Food Donation'),
            ),
          ],
        ),
      ),
    );
  }

  validateForm() {
    setState(() {
      title.isValidate =
          title.textEditingController.text.isEmpty ? true : false;
      quantity.isValidate =
          quantity.textEditingController.text.isEmpty ? true : false;
      description.isValidate =
          description.textEditingController.text.isEmpty ? true : false;

      if (title.textEditingController.text.isEmpty ||
          quantity.textEditingController.text.isEmpty ||
          description.textEditingController.text.isEmpty) {
      } else {
        setState(() {
          isProsessing = true;
        });
        addDonation();
      }
    });
  }

  addDonation() async {
    FirebaseFirestore.instance.collection('food_donation').add({
      'donator': widget.userID,
      'title': title.variableName,
      'description': description.variableName,
      'quantity': quantity.variableName,
      'expireTime': '$hours:$min',
      'status': 'pending',
      'date':
          '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
    }).then((value) {
      SnackBarClass.kShowSuccessSnackBar(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavBar(widget.userID),
        ),
      );
      setState(() {
        isProsessing = false;
      });
    }).catchError((error) {
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
    });
  }
}

List<String> kHours = [
  '00',
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
];

List<String> kMins = [
  '00',
  '15',
  '30',
  '45',
];
