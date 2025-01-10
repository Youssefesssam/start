import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bottomAppBarUsers/statistcsViewModel.dart';

class Charts extends StatefulWidget {
  static const String routeName = "charts";
  var selectedmonth;

  Charts({super.key,this.selectedmonth=0});

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  List<int> fetchedData = [0, 0, 0, 0]; // لتخزين البيانات لكل أسبوع

  @override
  Widget build(BuildContext context) {
    StatisticsViewModel statisticsViewModel = Provider.of(context);

    return Container(
      padding: EdgeInsets.only(top: 25,right: 25,left: 25,bottom: 0),
       margin: EdgeInsets.only(top: 10,bottom: 15,left: 10,right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(0),
            bottomLeft: Radius.circular(0),
            topRight:Radius.circular(0) ,
            topLeft: Radius.circular(0) ),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 4,
        child: StreamBuilder<int>(
          stream: statisticsViewModel.getStatisticsCircle2(
            'score',
            'week_1',
            widget.selectedmonth.toString(),  // تحويل selectedmonth إلى String
          ), // الأسبوع الأول
          builder: (context, snapshot1) {
            fetchedData[0] = (snapshot1.data != null && snapshot1.data! > 1) ? snapshot1.data! : 0;
            print(fetchedData[0]);
            return StreamBuilder<int>(
              stream: statisticsViewModel.getStatisticsCircle2(
                'score',
                'week_2',
                widget.selectedmonth.toString(), // تحويل selectedmonth إلى String
              ),
              builder: (context, snapshot2) {


                fetchedData[1] = (snapshot2.data != null && snapshot2.data! > 1) ? snapshot2.data! : 0;

                return StreamBuilder<int>(
                  stream: statisticsViewModel.getStatisticsCircle2(
                    'score',
                    'week_3',
                    widget.selectedmonth.toString(), // تحويل selectedmonth إلى String
                  ),
                  builder: (context, snapshot3) {
                    fetchedData[2] = (snapshot3.data != null && snapshot3.data! > 1) ? snapshot3.data! : 0;

                    return StreamBuilder<int>(
                      stream: statisticsViewModel.getStatisticsCircle2(
                        'score',
                        'week_4',
                        widget.selectedmonth.toString(), // تحويل selectedmonth إلى String
                      ),
                      builder: (context, snapshot4) {

                        fetchedData[3] = (snapshot4.data != null && snapshot4.data! > 1) ? snapshot4.data! : 0;

                        // بناء الرسم البياني باستخدام البيانات المستلمة
                        return BarChart(
                          BarChartData(
                            borderData: FlBorderData(
                              border: const Border(
                                top: BorderSide.none,
                                right: BorderSide.none,
                                left: BorderSide(width: 1),
                                bottom: BorderSide(width: 1),
                              ),
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
                                        return const Text('w1', style: TextStyle(color: Colors.deepOrangeAccent));
                                      case 2:
                                        return const Text('w2', style: TextStyle(color: Colors.deepOrangeAccent));
                                      case 3:
                                        return const Text('w3', style: TextStyle(color: Colors.deepOrangeAccent));
                                      case 4:
                                        return const Text('w4', style: TextStyle(color: Colors.deepOrangeAccent));
                                      default:
                                        return const Text('');
                                    }
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: FlGridData(show: false),
                            barTouchData: BarTouchData(enabled: true),
                            groupsSpace: 10,
                            barGroups: [
                              BarChartGroupData(x: 1, barRods: [
                                BarChartRodData(
                                  toY: fetchedData[0].toDouble(), // الأسبوع الأول
                                  fromY: 0,
                                  width: 7,
                                  color: Colors.orange,
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6)),
                                ),
                              ]),
                              BarChartGroupData(x: 2, barRods: [
                                BarChartRodData(
                                  toY: fetchedData[1].toDouble(), // الأسبوع الثاني
                                  fromY: 0,
                                  width: 7,
                                  color: Colors.blueAccent,
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6)),
                                ),
                              ]),
                              BarChartGroupData(x: 3, barRods: [
                                BarChartRodData(
                                  toY: fetchedData[2].toDouble(), // الأسبوع الثالث
                                  fromY: 0,
                                  width: 7,
                                  color: Colors.orange,
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6)),
                                ),
                              ]),
                              BarChartGroupData(x: 4, barRods: [
                                BarChartRodData(
                                  toY: fetchedData[3].toDouble(), // الأسبوع الرابع
                                  fromY: 0,
                                  width: 7,
                                  color: Colors.blueAccent,
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6)),
                                ),
                              ]),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        )
        ,
      ),
    );
  }
}