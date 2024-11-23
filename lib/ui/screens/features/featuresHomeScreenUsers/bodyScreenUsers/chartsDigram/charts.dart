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
    return Container(
      margin: const EdgeInsets.only(left: 20,right: 20,bottom: 5,top: 0),
      child: AspectRatio(
        aspectRatio: 4,
        child: BarChart(
          BarChartData(
            borderData: FlBorderData(
              border: const Border(
                  top: BorderSide.none,
                  right: BorderSide.none,
                  left: BorderSide(width: 1),
                  bottom: BorderSide(width: 1)),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(color: Colors.orange),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 1:
                        return const Text('Jan',
                            style: TextStyle(color: Colors.deepOrangeAccent));
                      case 2:
                        return const Text('Feb',
                            style: TextStyle(color: Colors.deepOrangeAccent));
                      case 3:
                        return const Text('Mar',
                            style: TextStyle(color: Colors.deepOrangeAccent));
                      case 4:
                        return const Text('Apr',
                            style: TextStyle(color: Colors.deepOrangeAccent));
                      case 5:
                        return const Text('May',
                            style: TextStyle(color: Colors.orange));
                      case 6:
                        return const Text('Jun',
                            style: TextStyle(color: Colors.orange));
                      case 7:
                        return const Text('Jul',
                            style: TextStyle(color: Colors.orange));
                      case 8:
                        return const Text('Aug',
                            style: TextStyle(color: Colors.orange));
                      case 9:
                        return const Text('Sep',
                            style: TextStyle(color: Colors.orange));
                      case 10:
                        return const Text('Oct',
                            style: TextStyle(color: Colors.orange));
                      case 11:
                        return const Text('Nov',
                            style: TextStyle(color: Colors.orange));
                      case 12:
                        return const Text('Dec',
                            style: TextStyle(color: Colors.orange));
                      default:
                        return const Text('');
                    }
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false, // إلغاء الخط العلوي
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false, // إلغاء الأرقام على المحور اليميني
                ),
              ),
            ),
            gridData: FlGridData(
              show: false, // إلغاء الخطوط فوق الأعمدة
            ),
            barTouchData: BarTouchData(
              enabled: true, // تعطيل تفاعل اللمس لإلغاء عرض البيانات عند اللمس
            ),
            groupsSpace: 10,
            barGroups: [
              BarChartGroupData(x: 1, barRods: [
                BarChartRodData(
                  toY: 5,
                  fromY: 0,
                  width: 7,
                  color: Colors.orange,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(6),
                    topLeft: Radius.circular(6),
                  ),
                ),
              ]),
              BarChartGroupData(x: 2, barRods: [
                BarChartRodData(
                  toY: 1,
                  fromY: 0,
                  width: 7,
                  color: Colors.orange,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(6),
                    topLeft: Radius.circular(6),
                  ),
                ),
              ]),
              BarChartGroupData(x: 3, barRods: [
                BarChartRodData(
                  toY: 2,
                  fromY: 0,
                  width: 7,
                  color: Colors.blueAccent,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(6),
                    topLeft: Radius.circular(6),
                  ),
                ),
              ]),
              BarChartGroupData(x: 4, barRods: [
                BarChartRodData(
                  toY: 6,
                  fromY: 0,
                  width: 7,
                  color: Colors.orange,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(6),
                    topLeft: Radius.circular(6),
                  ),
                ),
              ]),
              BarChartGroupData(x: 5, barRods: [
                BarChartRodData(
                  toY: 5,
                  fromY: 0,
                  width: 7,
                  color: Colors.blueAccent,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(6),
                    topLeft: Radius.circular(6),
                  ),
                ),
              ]),
              BarChartGroupData(x: 6, barRods: [
                BarChartRodData(
                  toY: 4,
                  fromY: 0,
                  width: 7,
                  color: Colors.orange,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(6),
                    topLeft: Radius.circular(6),
                  ),
                ),
              ]),
              BarChartGroupData(x: 7, barRods: [
                BarChartRodData(
                  toY: 3,
                  fromY: 0,
                  width: 7,
                  color: Colors.orange,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(6),
                    topLeft: Radius.circular(6),
                  ),
                ),
              ]),
              BarChartGroupData(x: 8, barRods: [
                BarChartRodData(
                  toY: 1,
                  fromY: 0,
                  width: 7,
                  color: Colors.orange,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(6),
                    topLeft: Radius.circular(6),
                  ),
                ),
              ]),
              BarChartGroupData(x: 9, barRods: [
                BarChartRodData(
                  toY: 5,
                  fromY: 0,
                  width: 7,
                  color: Colors.orange,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(6),
                    topLeft: Radius.circular(6),
                  ),
                ),
              ]),
              BarChartGroupData(x: 10, barRods: [
                BarChartRodData(
                  toY: 4,
                  fromY: 0,
                  width: 7,
                  color: Colors.blueAccent,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(6),
                    topLeft: Radius.circular(6),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
