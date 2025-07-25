import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/hour.dart';
import '../../../theme/theme.dart';
import '../../../util/parse/chart.dart';

class WeatherHourTemperatureChart extends StatelessWidget {
  final String title;
  final List<Hour> hours;

  const WeatherHourTemperatureChart({
    required this.title,
    required this.hours,
  });

  @override
  Widget build(BuildContext context) {
    final temperatures = hours.map((hour) => hour.temperature).toList();

    final sortedTemps = [...temperatures]..sort();

    /// Get `minTemp`, `maxTemp` & `midTemp`
    final minTemp = temperatures.reduce((a, b) => a < b ? a : b);
    final maxTemp = temperatures.reduce((a, b) => a > b ? a : b);
    final midTemp = sortedTemps[sortedTemps.length ~/ 2];

    /// Find `indexes`
    final minIndex = temperatures.indexOf(minTemp);
    final maxIndex = temperatures.indexOf(maxTemp);

    /// For `midIndex`, find the first `index` closest to the `midTemp` value
    final midIndex = findClosestIndex(
      values: temperatures,
      target: midTemp,
    );

    /// Generate `highlighedIndexes`
    final highlightedIndexes = [
      minIndex,
      maxIndex,
      midIndex,
    ];

    /// Generate `spots`
    final spots = List.generate(
      temperatures.length,
      (index) => FlSpot(
        index.toDouble(),
        temperatures[index],
      ),
    );

    /// Generate `lineBar`
    final lineBar = LineChartBarData(
      spots: spots,
      isCurved: true,
      color: context.colors.accent,
      barWidth: 4,
      dotData: const FlDotData(
        show: false,
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: context.textStyles.currentHourChartTitle,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minY: minTemp - 2,
                maxY: maxTemp + 2,
                showingTooltipIndicators: highlightedIndexes
                    .map(
                      (i) => ShowingTooltipIndicators(
                        [LineBarSpot(lineBar, 0, spots[i])],
                      ),
                    )
                    .toList(),
                lineBarsData: [lineBar],
                lineTouchData: LineTouchData(
                  enabled: false,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipPadding: EdgeInsets.zero,
                    tooltipMargin: 6,
                    getTooltipColor: (_) => Colors.transparent,
                    getTooltipItems: (touchedSpots) => touchedSpots
                        .map(
                          (spot) => LineTooltipItem(
                            '${spot.y.round()}°',
                            context.textStyles.currentHourChartTemperature,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
