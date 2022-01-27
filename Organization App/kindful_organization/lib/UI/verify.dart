import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kindful_organization/const.dart';
import 'package:kindful_organization/location.dart';
import 'package:kindful_organization/textField.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class Verify extends StatefulWidget {
  late String uid;

  Verify(uid) {
    this.uid = uid;
  }

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  bool isProcessing = false;
  bool checkedValue = false;

  double latitude = 0;
  double longitude = 0;

  TextFieldForm regNum = TextFieldForm();
  TextFieldForm guardianName = TextFieldForm();
  TextFieldForm guardianNIC = TextFieldForm();

  late File _certificateImageFile, _nicFrontImageFile, _nicBackImageFile;
  late String certificateURL, nicFrontURL, nicBackURL;
  String certificateImageFilePath = 'Certificate Image Empty';
  String nicFrontImageFilePath = 'NIC Front Image Empty';
  String nicBackImageFilePath = 'NIC Back Image Empty';

  @override
  void initState() {
    super.initState();
    //getLocation();
  }

  getLocation() async {
    setState(() {
      isProcessing = true;
    });

    Location location = Location();
    await location.getLocation();

    setState(() {
      latitude = location.latitude;
      longitude = location.longitude;
      isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar('Request Verify', true),
      body: ModalProgressHUD(
        inAsyncCall: isProcessing,
        child: ListView(
          children: [
            SizedBox(height: 8),
            Heading('Location Details'),
            //
            // Location
            //
            Row(
              children: [
                locationShow('Latitude', latitude.toString()),
                locationShow('Longitude', longitude.toString()),
              ],
            ),
            //
            // Refresh Location
            //
            MaterialButton(
              onPressed: () => getLocation(),
              child: kButtonBody('Refresh Location'),
            ),
            const SizedBox(height: 10),
            //
            // Check Location on Map
            //
            MaterialButton(
              onPressed: () {
                MapUtils.openMap(latitude, longitude);
              },
              child: kButtonBody('Check Location on Map'),
            ),
            //
            // Check Box
            //
            CheckboxListTile(
              title: Text("My Location is Correct"),
              checkColor: kMainGreen,
              activeColor: kMainPurple,
              value: checkedValue,
              onChanged: (newValue) {
                if (newValue!) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text("Warning",
                            style: TextStyle(color: Colors.red)),
                        content: Text(
                            'You can not change your Location after requesting for Verification Process.'),
                        actions: [
                          TextButton(
                            child: Text("Cancel",
                                style: TextStyle(color: kMainPurple)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text("Confirm",
                                style: TextStyle(color: kMainPurple)),
                            onPressed: () {
                              setState(() {
                                checkedValue = true;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  setState(() {
                    checkedValue = false;
                  });
                }
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            //
            // Divider
            //
            divider(),
            Heading('Registration Details'),
            //
            // Registration Number
            //
            Padding(
              padding: kTextFieldPadding,
              child: TextField(
                decoration: kTextInputDecoration(
                    'Registration Number', regNum.isValidate),
                cursorColor: kMainPurple,
                textCapitalization: TextCapitalization.words,
                maxLength: 30,
                onChanged: (value) {
                  setState(() {
                    regNum.variableName = value;
                  });
                },
                controller: regNum.textEditingController,
              ),
            ),
            //
            // Certificate Image
            //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                certificateImageFilePath,
                textAlign: TextAlign.center,
              ),
            ),
            MaterialButton(
              onPressed: () async {
                final pickedFile =
                    await ImagePicker().getImage(source: ImageSource.camera);
                setState(() {
                  _certificateImageFile = File(pickedFile!.path);
                  certificateImageFilePath = _certificateImageFile.path;
                });
              },
              child: kButtonBody('Get Certificate Image'),
            ),
            //
            // Divider
            //
            divider(),
            Heading('Guardian Details'),
            //
            // Guardian Name
            //
            Padding(
              padding: kTextFieldPadding,
              child: TextField(
                decoration: kTextInputDecoration(
                    'Guardian Name', guardianName.isValidate),
                cursorColor: kMainPurple,
                textCapitalization: TextCapitalization.words,
                maxLength: 50,
                onChanged: (value) {
                  setState(() {
                    guardianName.variableName = value;
                  });
                },
                controller: guardianName.textEditingController,
              ),
            ),
            //
            // Guardian NIC
            //
            Padding(
              padding: kTextFieldPadding,
              child: TextField(
                decoration: kTextInputDecoration(
                    'Guardian NIC Number', guardianNIC.isValidate),
                cursorColor: kMainPurple,
                textCapitalization: TextCapitalization.words,
                maxLength: 12,
                onChanged: (value) {
                  setState(() {
                    guardianNIC.variableName = value;
                  });
                },
                controller: guardianNIC.textEditingController,
              ),
            ),
            //
            // NIC Front
            //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                nicFrontImageFilePath,
                textAlign: TextAlign.center,
              ),
            ),
            MaterialButton(
              onPressed: () async {
                final pickedFile =
                    await ImagePicker().getImage(source: ImageSource.camera);
                setState(() {
                  _nicFrontImageFile = File(pickedFile!.path);
                  nicFrontImageFilePath = _nicFrontImageFile.path;
                });
              },
              child: kButtonBody('Get NIC Front Image'),
            ),
            //
            // NIC Back
            //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                nicBackImageFilePath,
                textAlign: TextAlign.center,
              ),
            ),
            MaterialButton(
              onPressed: () async {
                final pickedFile =
                    await ImagePicker().getImage(source: ImageSource.camera);
                setState(() {
                  _nicBackImageFile = File(pickedFile!.path);
                  nicBackImageFilePath = _nicBackImageFile.path;
                });
              },
              child: kButtonBody('Get NIC Front Image'),
            ),
            //
            // Divider
            //
            divider(),
            MaterialButton(
              onPressed: () {},
              child: kButtonBody('Submit'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Expanded locationShow(String title, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: kMainGreen,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: kMainPurple,
                    fontFamily: 'kindful',
                    fontSize: 18,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: kMainPurple,
                    fontFamily: 'kindful',
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Divider(thickness: 3),
    );
  }

  Center Heading(String title) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'kindful',
            fontSize: 20,
            color: kMainPurple,
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {});
  }
}
