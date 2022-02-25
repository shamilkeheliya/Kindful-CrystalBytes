import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/views/home.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/utilities/cardTextStyles.dart';

class ViewReport extends StatefulWidget {
  late String docID;
  ViewReport(this.docID);
  @override
  _ViewReportState createState() => _ViewReportState();
}

class _ViewReportState extends State<ViewReport> {
  String date = 'Date';
  String description = 'Description';
  String reportee = '';
  String reporteeName = 'Reportee';
  String reporteeType = 'Reportee Type';
  String reporter = '';
  String reporterName = 'Reporter';
  String reporterType = 'Reporter Type';
  bool read = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await FirebaseFirestore.instance
        .collection('reports')
        .doc(widget.docID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        date = documentSnapshot['date'];
        description = documentSnapshot['description'];
        reportee = documentSnapshot['reportee'];
        reporteeType = documentSnapshot['reporteeType'];
        reporter = documentSnapshot['reporter'];
        reporterType = documentSnapshot['reporterType'];
        read = documentSnapshot['read'];
      });
    });

    await getName(reportee, reporteeType).then((value) {
      setState(() {
        reporteeName = value;
      });
    });
    await getName(reporter, reporterType).then((value) {
      setState(() {
        reporterName = value;
      });
    });
  }

  Future<String> getName(String id, String type) async {
    String name = '';
    String collection = type == 'organization'
        ? 'organizations'
        : type == 'donator'
            ? 'donators'
            : 'food_donators';

    await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      name = documentSnapshot['name'];
    });
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainPurple,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              icon: Icon(Icons.home)),
        ],
      ),
      body: Padding(
        padding: kCardsPadding,
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 500,
              child: Card(
                child: Padding(
                  padding: kCardsInsidePadding,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(date, style: kCardQuantityTextStyle),
                        subtitle: const Text('Date'),
                      ),
                      ListTile(
                        title:
                            Text(reporteeName, style: kCardQuantityTextStyle),
                        subtitle: const Text('Reportee'),
                        onTap: () {},
                      ),
                      ListTile(
                        title:
                            Text(reporterName, style: kCardQuantityTextStyle),
                        subtitle: const Text('Reporter'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text(description, style: kCardQuantityTextStyle),
                        subtitle: const Text('Report Description'),
                      ),
                      Visibility(
                        visible: !read,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            FirebaseFirestore.instance
                                .collection('reports')
                                .doc(widget.docID)
                                .update({
                              'read': true,
                            }).then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewReport(widget.docID)));
                              setState(() {
                                isLoading = false;
                              });
                            });
                          },
                          child: const Text('Mark as Read'),
                          style: ElevatedButton.styleFrom(primary: kMainGreen),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
