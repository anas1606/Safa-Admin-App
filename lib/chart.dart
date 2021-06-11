import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  Chart({
    @required this.data,
    @required this.active,
    @required this.total,
  });

  final List<PieChartSectionData> data;
  final int active;
  final int total;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: data,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Active",
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Colors.white54,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  active.toString(),
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Colors.white54,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                Text(
                  "of "+total.toString(),
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<PieChartSectionData> paiChartSelectionDatas = [
  PieChartSectionData(
    color: Color(0xFF26E5FF),
    value: 20,
    showTitle: false,
    radius: 25,
  ),
  PieChartSectionData(
    color: Color(0xFFFFCF26),
    value: 10,
    showTitle: false,
    radius: 25,
  ),
  PieChartSectionData(
    color: Color(0xFFEE2727),
    value: 15,
    showTitle: false,
    radius: 25,
  ),
  PieChartSectionData(
    color: Colors.grey.withOpacity(0.1),
    value: 30,
    showTitle: false,
    radius: 25,
  ),
];
