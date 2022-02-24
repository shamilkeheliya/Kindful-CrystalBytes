import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/utilities/tab.dart';
import 'package:dashboard/views/tabs/organiztions/all_organizations.dart';
import 'package:dashboard/views/tabs/organiztions/organization_reports.dart';
import 'package:dashboard/views/tabs/organiztions/organizations_verification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Organizations extends StatefulWidget {
  @override
  _OrganizationsState createState() => _OrganizationsState();
}

class _OrganizationsState extends State<Organizations> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TabBar(
          labelColor: kMainGreen,
          unselectedLabelColor: Colors.white,
          indicatorColor: kMainPurple,
          tabs: [
            CustomTab('Organizations'),
            CustomTab('Verification'),
            CustomTab('Reports'),
          ],
        ),
        body: TabBarView(
          children: [
            AllOrganizations(),
            OrganizationsVefirication(),
            OrganizationReports(),
          ],
        ),
      ),
    );
  }
}
