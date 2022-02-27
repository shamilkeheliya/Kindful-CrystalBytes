import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/views/home.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  static const List<String> kUserTypes = <String>[
    'Manager',
    'Admin',
  ];
  bool isLoading = false;
  late String name;
  late String email;
  String selectedUserType = kUserTypes[0];

  TextEditingController nameTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kMainPurple,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                icon: const Icon(Icons.home)),
          ],
          title: const Text(
            'Create User',
            style: TextStyle(fontFamily: 'kindful'),
          ),
        ),
        body: Center(
          child: SizedBox(
            width: 500,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: buildBody(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: kTextFieldPadding,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              controller: nameTEC,
              textCapitalization: TextCapitalization.words,
              decoration: kTextInputDecoration('Name', false),
            ),
          ),
          Padding(
            padding: kTextFieldPadding,
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              child: SizedBox(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'User Type',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                    DropdownButton(
                      underline: const SizedBox(),
                      value: selectedUserType,
                      onChanged: (value) {
                        setState(() {
                          selectedUserType = value.toString();
                        });
                      },
                      items: kUserTypes.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => validate(),
            child: const Text('Create User'),
            style: ElevatedButton.styleFrom(primary: kMainPurple),
          ),
        ],
      ),
    );
  }

  void validate() {
    if (nameTEC.text.isNotEmpty) {}
  }
}
