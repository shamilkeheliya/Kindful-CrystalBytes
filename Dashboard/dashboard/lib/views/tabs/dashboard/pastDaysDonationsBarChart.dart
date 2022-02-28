import 'package:dashboard/utilities/const.dart';
import 'package:dashboard/views/tabs/dashboard/getDataClass.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PastDaysDonationsBarChart extends StatefulWidget {
  const PastDaysDonationsBarChart({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PastDaysDonationsBarChartState();
}

class PastDaysDonationsBarChartState extends State<PastDaysDonationsBarChart> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  String day0 = '⌛';
  String day1 = '⌛';
  String day2 = '⌛';
  String day3 = '⌛';
  String day4 = '⌛';
  String day5 = '⌛';
  String day6 = '⌛';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    DonationsForSevenDays data = DonationsForSevenDays();
    await data.getDataForSevenDays();
    setState(() {
      day0 = data.d0.showDate;
      day1 = data.d1.showDate;
      day2 = data.d2.showDate;
      day3 = data.d3.showDate;
      day4 = data.d4.showDate;
      day5 = data.d5.showDate;
      day6 = data.d6.showDate;
    });

    final barGroup1 = makeGroupData(0, data.d6.donationsCount.toDouble(),
        data.d6.foodDonationsCount.toDouble());
    final barGroup2 = makeGroupData(1, data.d5.donationsCount.toDouble(),
        data.d5.foodDonationsCount.toDouble());
    final barGroup3 = makeGroupData(2, data.d4.donationsCount.toDouble(),
        data.d4.foodDonationsCount.toDouble());
    final barGroup4 = makeGroupData(3, data.d3.donationsCount.toDouble(),
        data.d3.foodDonationsCount.toDouble());
    final barGroup5 = makeGroupData(4, data.d2.donationsCount.toDouble(),
        data.d2.foodDonationsCount.toDouble());
    final barGroup6 = makeGroupData(5, data.d1.donationsCount.toDouble(),
        data.d1.foodDonationsCount.toDouble());
    final barGroup7 = makeGroupData(6, data.d0.donationsCount.toDouble(),
        data.d0.foodDonationsCount.toDouble());

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return day6 == '⌛'
        ? const Padding(
            padding: EdgeInsets.all(100.0),
            child: SpinKitCircle(
              color: kMainPurple,
            ),
          )
        : AspectRatio(
            aspectRatio: 3,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              color: kMainPurple,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        makeTransactionsIcon(),
                        const SizedBox(
                          width: 38,
                        ),
                        const Text(
                          'Donations',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Text(
                          'Past Week',
                          style: TextStyle(color: kMainGreen, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 38),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          maxY: 10,
                          barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                tooltipBgColor: Colors.grey,
                                getTooltipItem: (_a, _b, _c, _d) => null,
                              ),
                              touchCallback: (FlTouchEvent event, response) {
                                if (response == null || response.spot == null) {
                                  setState(() {
                                    touchedGroupIndex = -1;
                                    showingBarGroups = List.of(rawBarGroups);
                                  });
                                  return;
                                }

                                touchedGroupIndex =
                                    response.spot!.touchedBarGroupIndex;

                                setState(() {
                                  if (!event.isInterestedForInteractions) {
                                    touchedGroupIndex = -1;
                                    showingBarGroups = List.of(rawBarGroups);
                                    return;
                                  }
                                  showingBarGroups = List.of(rawBarGroups);
                                  if (touchedGroupIndex != -1) {
                                    var sum = 0.0;
                                    for (var rod
                                        in showingBarGroups[touchedGroupIndex]
                                            .barRods) {
                                      sum += rod.y;
                                    }
                                    final avg = sum /
                                        showingBarGroups[touchedGroupIndex]
                                            .barRods
                                            .length;

                                    showingBarGroups[touchedGroupIndex] =
                                        showingBarGroups[touchedGroupIndex]
                                            .copyWith(
                                      barRods:
                                          showingBarGroups[touchedGroupIndex]
                                              .barRods
                                              .map((rod) {
                                        return rod.copyWith(y: avg);
                                      }).toList(),
                                    );
                                  }
                                });
                              }),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: SideTitles(showTitles: false),
                            topTitles: SideTitles(showTitles: false),
                            bottomTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (context, value) =>
                                  const TextStyle(
                                      color: kMainGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                              margin: 20,
                              getTitles: (double value) {
                                switch (value.toInt()) {
                                  case 0:
                                    return day6;
                                  case 1:
                                    return day5;
                                  case 2:
                                    return day4;
                                  case 3:
                                    return day3;
                                  case 4:
                                    return day2;
                                  case 5:
                                    return day1;
                                  case 6:
                                    return day0;
                                  default:
                                    return '';
                                }
                              },
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (context, value) =>
                                  const TextStyle(
                                      color: kMainGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                              margin: 8,
                              reservedSize: 28,
                              interval: 1,
                              getTitles: (value) {
                                if (value == 0) {
                                  return '1';
                                } else if (value == 10) {
                                  return '5';
                                } else if (value == 19) {
                                  return '10';
                                } else {
                                  return '';
                                }
                              },
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          barGroups: showingBarGroups,
                          gridData: FlGridData(show: false),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
