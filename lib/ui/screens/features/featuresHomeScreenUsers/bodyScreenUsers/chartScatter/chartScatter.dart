import 'package:d_chart/commons/config_render.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/commons/enums.dart';
import 'package:d_chart/commons/symbol_render.dart';
import 'package:d_chart/ordinal/combo.dart';
import 'package:flutter/material.dart';

class ChartScatter extends StatefulWidget {
  const ChartScatter({super.key});

  @override
  State<ChartScatter> createState() => _ChartScatterState();
}

class _ChartScatterState extends State<ChartScatter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*.26,
            child: AspectRatio(
              aspectRatio: 16/9,

              child: DChartComboO(
                configRenderPoint: ConfigRenderPoint(
                    radiusPx: 3,
                    strokeWidthPx: 10,
                    symbolRender: SymbolRenderCircle(
                      isSolid: true,
                    )
                ),
                groupList: [

                  OrdinalGroup(id: '1',
                      chartType: ChartType.scatterPlot,color: Color(0xfffdb900),
                      data: [
                        OrdinalData(domain: 'Mon', measure: 3.5),
                        OrdinalData(domain: 'Tue', measure: 5),
                        OrdinalData(domain: 'Wed', measure: 9),
                        OrdinalData(domain: 'Thu', measure: 6.5),
                        OrdinalData(domain: 'fri', measure: 6),
                        OrdinalData(domain: 'sun', measure: 7),
                        OrdinalData(domain: 'sat', measure: 6.5),
                      ])
                ],
              ),),
          )
        ],

      ),
    );
  }
}