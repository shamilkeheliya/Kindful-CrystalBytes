import 'package:flutter/material.dart';

class OrganizationView extends StatefulWidget {
  late String organizationID, organizationName;
  OrganizationView(this.organizationID, this.organizationName);
  @override
  _OrganizationViewState createState() => _OrganizationViewState();
}

class _OrganizationViewState extends State<OrganizationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.organizationName,
          style: const TextStyle(fontFamily: 'kindful'),
        ),
      ),
    );
  }
}
