import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:shop_pay/features/admin/models/sales.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> salesList;

  const CategoryProductsChart({
    Key? key,
    required this.salesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          groupsSpace: 10,
          borderData: borderData,
          titlesData: titlesData,
          barTouchData: barTouchData,
          barGroups: salesList.asMap().entries.map((e) {
            final index = e.key;
            final sales = e.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: double.parse(sales.earning.toString()),
                  gradient: _barsGradient,
                ),
              ],
              showingTooltipIndicators: [0],
            );
          }).toList(),
        ),
      ),
    );
  }

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Colors.blue.shade800,
          Colors.cyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.white,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlBorderData get borderData => FlBorderData(
          border: const Border(
        top: BorderSide.none,
        right: BorderSide.none,
        left: BorderSide(width: 1),
        bottom: BorderSide(width: 1),
      ));

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.blue.shade800,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value >= 0 && value < salesList.length) {
      text = salesList[value.toInt()].label;
    } else {
      text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );
}
