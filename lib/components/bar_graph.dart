import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final List<double> weeklySummary;

  const MyBarGraph({
    super.key,
    required this.weeklySummary,
  });

  @override
  Widget build(BuildContext context) {
    double max = weeklySummary.reduce((a, b) => a > b ? a : b);
    double maxY = max == 0 ? 100 : max + (max * 0.2); // Auto-scale

    final todayIndex =
        DateTime.now().weekday % 7; // Sunday = 0, Monday = 1, ..., Saturday = 6

    return BarChart(
      BarChartData(
        maxY: maxY,
        barGroups: List.generate(7, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                  toY: weeklySummary[index],
                  color: Colors.grey[800], // Today's bar = black
                  width: 25,
                  borderRadius: BorderRadius.circular(4),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: Colors.grey[200],
                  )),
            ],
          );
        }),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  // Weekday labels
  Widget getBottomTitles(double value, TitleMeta meta) {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        days[value.toInt() % 7],
        style: TextStyle(
            color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
