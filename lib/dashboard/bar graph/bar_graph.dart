import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:testproject/dashboard/bar%20graph/bar_data.dart';

class BarGraph extends StatelessWidget {
  final List<int> regionalSummary;
  const BarGraph({super.key, required this.regionalSummary});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
        riftValley: regionalSummary[0],
        nyanza: regionalSummary[1],
        western: regionalSummary[2],
        central: regionalSummary[3],
        northEastern: regionalSummary[4],
        coast: regionalSummary[5],
        eastern: regionalSummary[6],
        nairobi: regionalSummary[7]
    );
    int max = regionalSummary.reduce((value, element) => value > element? value: element);
    double maxY = ((max + (max*0.1))/10).round()*10;
    myBarData.initBarData();
    return BarChart(BarChartData(
      maxY: maxY,
      minY: 0,

      gridData: FlGridData(drawHorizontalLine: true, drawVerticalLine: false),
      //backgroundColor: Colors.green[50],
      titlesData: FlTitlesData(
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false)
        ),

        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getBottomTitles,

          )
        )
      ),
      barGroups: myBarData.barData.map((data) => BarChartGroupData(
          x: data.x,
          barRods: [BarChartRodData(toY: data.y.toDouble(),
          color: Colors.green,
          width: 25,
          borderRadius: BorderRadius.circular(2)),
          ]
      )).toList()
    ));
  }

  Widget getBottomTitles(double value, TitleMeta meta){
    String text = "";
    Widget title;
    switch (value.toInt()){
      case 1:
        text = "Nairobi";
        break;
      case 2:
        text = "Eastern";
        break;
      case 3:
        text = "Coast";
        break;
      case 4:
        text = "N-Eastern";
        break;
      case 5:
        text = "Central";
        break;
      case 6:
        text = "Western";
        break;
      case 7:
        text = "Nyanza";
        break;
      case 8:
        text = "R-Valley";
        break;
      default:
        text = "";
        break;
    }
    title = Transform.rotate(
      angle: -90 * 3.14 / 180,
      child: Container(
        margin: const EdgeInsets.only(right: 25),
        child: Text(text,
        style: const TextStyle(
          fontSize: 10
        ),),
      ),
    );
    return SideTitleWidget(axisSide: meta.axisSide, child: title);
  }
}
