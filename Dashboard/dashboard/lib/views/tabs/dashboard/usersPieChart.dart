import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/utilities/const.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'indicator.dart';

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
        elevation: 5,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections()),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                  color: Color(0xfff8b250),
                  text: 'Organizations',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: kMainPurple,
                  text: 'Donators',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: kMainGreen,
                  text: 'Food Donators',
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: organizationsCount.toDouble(),
            title:
                '${(organizationsCount / (food_donatorsCount + donatorsCount + organizationsCount) * 100).toInt()}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: kMainPurple,
            value: donatorsCount.toDouble(),
            title:
                '${(donatorsCount / (food_donatorsCount + donatorsCount + organizationsCount) * 100).toInt()}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: kMainGreen,
            value: food_donatorsCount.toDouble(),
            title:
                '${(food_donatorsCount / (food_donatorsCount + donatorsCount + organizationsCount) * 100).toInt()}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}
