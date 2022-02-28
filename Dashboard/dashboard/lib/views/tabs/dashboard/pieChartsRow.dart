import 'package:dashboard/views/tabs/dashboard/usersPieChart.dart';
import 'package:flutter/material.dart';

class PieChartsRow extends StatefulWidget {
  @override
  _PieChartsRowState createState() => _PieChartsRowState();
}

class _PieChartsRowState extends State<PieChartsRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Flexible(child: UsersPieChart()),
        Flexible(child: UsersPieChart()),
      ],
    );
  }
}
