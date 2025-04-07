import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EmotionRadarChart extends StatelessWidget {
  final Map<String, int> emotionData;

  const EmotionRadarChart({super.key, required this.emotionData});

  @override
  Widget build(BuildContext context) {
    return RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        //radarBackgroundColor: Colors.white,
        //선 색깔 지정
        gridBorderData: BorderSide(color: Colors.grey, width: 1.5), //각 항목 구분선
        radarBorderData: BorderSide(color: Colors.grey, width: 2), //태두리 선
        tickBorderData: BorderSide(color: Colors.grey, width: 2), //영역 선
        //항목 수
        tickCount: 2,
        titlePositionPercentageOffset: 0.15,
        //항목 글자(제목) 스타일
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        //항목 글자 가져오기
        getTitle:
            (index, _) =>
                RadarChartTitle(text: emotionData.keys.elementAt(index)),
        //각 항목 데이터 설정(그래프 그리기)
        dataSets: [
          RadarDataSet(
            fillColor: Color.fromRGBO(0, 0, 255, 0.3),
            borderColor: Colors.blue,
            //각 항목의 데이터들 중에서 가장 큰 값으로 정규화 -> 0~1사이의 값으로 변환
            dataEntries:
                emotionData.values
                    .map((value) => RadarEntry(value: value.toDouble()))
                    .toList(),
          ),
        ],
      ),
    );
  }
}
