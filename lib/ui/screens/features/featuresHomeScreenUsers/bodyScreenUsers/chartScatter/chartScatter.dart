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
          SizedBox(
            height: MediaQuery.of(context).size.height*.22,
            child: AspectRatio(
              aspectRatio: 16/8,
              child: DChartComboO(animate: true,
                configRenderPoint: ConfigRenderPoint(

                    radiusPx: 3,
                    strokeWidthPx: 10,
                    symbolRender: SymbolRenderCircle(
                      isSolid: true,
                    )
                ),
                groupList: [

                  OrdinalGroup(id: '1',
                      chartType: ChartType.scatterPlot,color: Colors.orange,
                      data: [
                        OrdinalData(domain: 'Mon 1', measure: 3.5),
                        OrdinalData(domain: 'Mon 2', measure: 10),
                        OrdinalData(domain: 'Mon 3', measure: 9),
                        OrdinalData(domain: 'Mon 4', measure: 6.5),
                        OrdinalData(domain: 'Mon 5', measure: 6),
                        OrdinalData(domain: 'Mon 6', measure: 7),
                        OrdinalData(domain: 'Mon 7', measure: 6.5),
                      ])
                ],
              ),),
          )
        ],

      ),
    );
  }
}