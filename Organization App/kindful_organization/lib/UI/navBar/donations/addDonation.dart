import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kindful_organization/utilities/const.dart';
import 'package:kindful_organization/utilities/navBar.dart';
import 'package:kindful_organization/utilities/textField.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddDonation extends StatefulWidget {
  String userID = '';

  // ignore: use_key_in_widget_constructors
  AddDonation(userID) {
    this.userID = userID;
  }

  // ignore: use_key_in_widget_constructors

  @override
  _AddDonationState createState() => _AddDonationState();
}

class _AddDonationState extends State<AddDonation> {
  TextFieldForm title = TextFieldForm();
  TextFieldForm quantity = TextFieldForm();
  TextFieldForm description = TextFieldForm();

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
            // Title
            //
            Padding(
              padding: kTextFieldPadding,
              child: TextField(
                decoration:
                    kTextInputDecoration('Donation Title', title.isValidate),
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
            //Button
            //
            const SizedBox(height: 10),
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
    FirebaseFirestore.instance.collection('donation').add({
      'organization': widget.userID,
      'title': title.variableName,
      'description': description.variableName,
      'quantity': quantity.variableName,
      'status': 'pending',
      'donator': '',
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
