import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EmotionRadarChart extends StatelessWidget {
  final Map<String, int> emotionData;

  const EmotionRadarChart({super.key, required this.emotionData});

  @override
  Widget build(BuildContext context) {
    List<String> labels = emotionData.keys.toList();
    List<RadarDataSet> dataSets = [
      RadarDataSet(
        fillColor: Color.fromRGBO(0, 0, 255, 0.3),
        borderColor: Colors.blue,
        entryRadius: 3,
        dataEntries:
            emotionData.values
                .map((value) => RadarEntry(value: value.toDouble()))
                .toList(),
      ),
    ];

    return RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        dataSets: dataSets,
        radarBackgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        tickCount: 5, // 눈금 개수
        titlePositionPercentageOffset: 0.15,
        getTitle: (index, _) => RadarChartTitle(text: labels[index]),
      ),
    );
  }
}
