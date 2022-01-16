import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kindful_organization/const.dart';
import 'package:kindful_organization/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
              value: checkedValue,
              onChanged: (newValue) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title:
                          Text("Warning", style: TextStyle(color: Colors.red)),
                      content: Text(
                          'You can not change your Location after requesting for Verification Process.'),
                      actions: [
                        TextButton(
                          child: Text("Cancel",
                              style: TextStyle(color: kMainPurple)),
                          onPressed: () {
                            setState(() {
                              checkedValue = false;
                            });
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
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
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
            borderRadius: BorderRadius.circular(20),
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
}
