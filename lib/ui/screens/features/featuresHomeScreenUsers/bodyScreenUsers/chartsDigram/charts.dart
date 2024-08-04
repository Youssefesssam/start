import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Charts extends StatefulWidget {
  static const String routeName = "charts";

  const Charts({super.key});

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: BarChart(
            BarChartData(
            borderData: FlBorderData(
                border: Border(
                    top: BorderSide.none,
                    right: BorderSide.none,
                    left: BorderSide(width: 1),
                    bottom: BorderSide(width: 1))),
            groupsSpace: 10,
            barGroups: [
              BarChartGroupData(x: 1, barRods: [
                BarChartRodData(toY: 5, fromY: 0, width: 7, color: Colors.grey)
              ]),
              BarChartGroupData(x: 2, barRods: [
                BarChartRodData(toY: 1, fromY: 0, width: 7, color: Colors.grey)
              ]),
              BarChartGroupData(x: 3, barRods: [
                BarChartRodData(toY: 2, fromY: 0, width: 7, color: Colors.grey)
              ]),
              BarChartGroupData(x: 4, barRods: [
                BarChartRodData(toY: 6, fromY: 0, width: 7, color: Colors.grey)
              ]),
              BarChartGroupData(x: 5, barRods: [
                BarChartRodData(toY: 5, fromY: 0, width: 7, color: Colors.grey)
              ]),
              BarChartGroupData(x: 6, barRods: [
                BarChartRodData(toY: 4, fromY: 0, width: 7, color: Colors.grey)
              ]),
              BarChartGroupData(x: 7, barRods: [
                BarChartRodData(toY: 3, fromY: 0, width: 7, color: Colors.grey)
              ]),
              BarChartGroupData(x: 8, barRods: [
                BarChartRodData(toY: 1, fromY: 0, width: 7, color: Colors.grey)
              ]),
              BarChartGroupData(x: 9, barRods: [
                BarChartRodData(toY: 5, fromY: 0, width: 7, color: Colors.grey)
              ]),
              BarChartGroupData(x: 10, barRods: [
                BarChartRodData(toY: 10, fromY: 0, width: 7, color: Colors.grey)
              ]),


            ])));
  }
}
