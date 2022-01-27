import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kindful_organization/const.dart';
import 'package:kindful_organization/location.dart';
import 'package:kindful_organization/navBar.dart';
import 'package:kindful_organization/textField.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  FirebaseStorage _storage = FirebaseStorage.instance;

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
    getLocation();
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
                textCapitalization: TextCapitalization.characters,
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
              onPressed: () {
                validateForm();
              },
              child: kButtonBody('Submit'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  validateForm() {
    setState(() async {
      regNum.isValidate =
          regNum.textEditingController.text.isEmpty ? true : false;
      guardianName.isValidate =
          guardianName.textEditingController.text.isEmpty ? true : false;
      guardianNIC.isValidate =
          guardianNIC.textEditingController.text.isEmpty ? true : false;

      if (regNum.textEditingController.text.isEmpty ||
          guardianName.textEditingController.text.isEmpty ||
          guardianNIC.textEditingController.text.length < 10 ||
          !checkedValue ||
          certificateImageFilePath == 'Certificate Image Empty' ||
          nicFrontImageFilePath == 'NIC Front Image Empty' ||
          nicBackImageFilePath == 'NIC Back Image Empty') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Fields cannot be Empty'),
            action: SnackBarAction(
              label: 'Okay',
              onPressed: () {},
            ),
          ),
        );
      } else {
        setState(() {
          isProcessing = true;
        });
        uploadCertificateImage();
      }
    });
  }

  uploadCertificateImage() {
    Reference certificateReference = _storage
        .ref()
        .child('organizations')
        .child(widget.uid)
        .child('certificate.${certificateImageFilePath.split('.').last}');

    UploadTask certificateUploadTask =
        certificateReference.putFile(_certificateImageFile);

    certificateUploadTask.whenComplete(() async {
      String certificateDownloadURL = await _storage
          .ref()
          .child('organizations')
          .child(widget.uid)
          .child('certificate.${certificateImageFilePath.split('.').last}')
          .getDownloadURL();
      setState(() {
        certificateURL = certificateDownloadURL;
        print('Certificate : $certificateURL');
        uploadNICfrontImage();
      });
    });
  }

  uploadNICfrontImage() {
    Reference nicFrontReference = _storage
        .ref()
        .child('organizations')
        .child(widget.uid)
        .child('nicFront.${nicFrontImageFilePath.split('.').last}');

    UploadTask nicFrontUploadTask =
        nicFrontReference.putFile(_nicFrontImageFile);

    nicFrontUploadTask.whenComplete(() async {
      String nicFrontDownloadURL = await _storage
          .ref()
          .child('organizations')
          .child(widget.uid)
          .child('nicFront.${nicFrontImageFilePath.split('.').last}')
          .getDownloadURL();
      setState(() {
        nicFrontURL = nicFrontDownloadURL;
        print('NIC Front : $nicFrontURL');
        uplaodNICbackImage();
      });
    });
  }

  uplaodNICbackImage() {
    Reference nicBackReference = _storage
        .ref()
        .child('organizations')
        .child(widget.uid)
        .child('nicBack.${nicBackImageFilePath.split('.').last}');

    UploadTask nicBackUploadTask = nicBackReference.putFile(_nicBackImageFile);

    nicBackUploadTask.whenComplete(() async {
      String nicBackDownloadURL = await _storage
          .ref()
          .child('organizations')
          .child(widget.uid)
          .child('nicBack.${nicBackImageFilePath.split('.').last}')
          .getDownloadURL();
      setState(() {
        nicBackURL = nicBackDownloadURL;
        print('NIC Back : $nicBackURL');
        requestVerify();
      });
    });
  }

  requestVerify() async {
    await FirebaseFirestore.instance
        .collection('organizations')
        .doc(widget.uid)
        .update({
      'requestVerify': true,
      'location': {'latitude': latitude, 'longitude': longitude},
      'regNumber': regNum.variableName,
      'regImage': certificateURL,
      'guardian': {
        'guardianName': guardianName.variableName,
        'guardianNIC': guardianNIC.variableName,
        'nicFront': nicFrontURL,
        'nicBack': nicBackURL
      }
    }).then((value) {
      setState(() {
        isProcessing = false;
      });

      SnackBarClass.kShowSuccessSnackBar(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavBar(widget.uid),
        ),
      );
    }).catchError((error) {
      setState(() {
        isProcessing = false;
      });

      print(error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cannot Submit'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () => validateForm(),
          ),
        ),
      );
    });
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
}
