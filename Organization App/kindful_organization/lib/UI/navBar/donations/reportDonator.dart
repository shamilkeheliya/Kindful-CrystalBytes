import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kindful_organization/utilities/const.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ReportUser extends StatefulWidget {
  late String userID, donatorID, donatorName;
  ReportUser(this.userID, this.donatorID, this.donatorName);
  @override
  _ReportUserState createState() => _ReportUserState();
}

class _ReportUserState extends State<ReportUser> {
  late String description;
  bool descriptionIsValidate = false;
  TextEditingController descriptionTEC = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: kAppBar('Report Donator', true),
        body: ListView(
          children: [
            const SizedBox(height: 10),
            //
            // Name
            //
            Padding(
              padding: kTextFieldPadding,
              child: TextField(
                decoration: kTextInputDecoration(widget.donatorName, false),
                textCapitalization: TextCapitalization.words,
                enabled: false,
              ),
            ),
            const SizedBox(height: 5),
            //
            // Description
            //
            Padding(
              padding: kTextFieldPadding,
              child: TextField(
                decoration: kTextInputDecoration(
                    'Description for Report', descriptionIsValidate),
                cursorColor: kMainPurple,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 10,
                maxLength: 200,
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
                controller: descriptionTEC,
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () {
                validateForm();
              },
              child: kButtonBody('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }

  void validateForm() {
    setState(() {
      descriptionIsValidate = descriptionTEC.text.isEmpty ? true : false;
    });
    if (descriptionTEC.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      FirebaseFirestore.instance.collection('reports').add({
        'reporter': widget.userID,
        'reporterType': 'organization',
        'reportee': widget.donatorID,
        'reporteeType': 'donator',
        'description': description,
        'read': false,
        'date':
            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      }).then((value) {
        setState(() {
          isLoading = false;
        });
        SnackBarClass.kShowSuccessSnackBar(context);
        Navigator.pop(context);
      }).catchError((erorr) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Cannot Submit Report'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => validateForm(),
            ),
          ),
        );
      });
    }
  }
}
