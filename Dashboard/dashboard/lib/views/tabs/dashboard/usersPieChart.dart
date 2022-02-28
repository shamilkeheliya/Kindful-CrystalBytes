import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UsersPieChart extends StatefulWidget {
  const UsersPieChart({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UsersPieChartState();
}

class UsersPieChartState extends State {
  int touchedIndex = 0;

  int organizationsCount = 1;
  int donatorsCount = 1;
  int food_donatorsCount = 1;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await FirebaseFirestore.instance
        .collection('organizations')
        .get()
        .then((snapshot) {
      setState(() {
        organizationsCount = snapshot.size;
      });
    });
    await FirebaseFirestore.instance
        .collection('donators')
        .get()
        .then((snapshot) {
      setState(() {
        donatorsCount = snapshot.size;
      });
    });
    await FirebaseFirestore.instance
        .collection('food_donators')
        .get()
        .then((snapshot) {
      setState(() {
        food_donatorsCount = snapshot.size;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
                pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                }),
                borderData: FlBorderData(
                  show: true,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 0,
                sections: showingSections()),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 10.0;
      final radius = isTouched ? 110.0 : 100.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: organizationsCount.toDouble(),
            title: 'Organizations',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: donatorsCount.toDouble(),
            title: 'Doators',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: food_donatorsCount.toDouble(),
            title: 'Food\nDonators',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw 'Oh no';
      }
    });
  }
}
