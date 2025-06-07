import 'dart:math';
import 'package:capstone_diary/Utils/diarymanager.dart';
import 'package:capstone_diary/Utils/toastmessage.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class SummaryChart extends StatefulWidget {
  const SummaryChart({super.key});

  @override
  State<SummaryChart> createState() => _SummaryChartState();
}

class _SummaryChartState extends State<SummaryChart> {
  String currentMonth = "${DateTime.now().month}월";
  void selectWord(String word) {
    print("클릭한 단어: $word");
  }

  void selectDate(DateTime date) {
    print("선택한 날짜: $date");
  }

  Future<void> _loadAllSummaryData() async {
    keywordCounts = await DiaryManager().getAllSummary("20213010"); //userId
    entries = _generateWordEntries(); // 데이터 변경 후 entries 갱신
    setState(() {}); // 화면 갱신
  }

  Map<String, int> keywordCounts = {
    "여행": 1,
    "음식": 7,
    "공부": 5,
    "운동": 3,
    "독서": 2,
  };

  List<_WordEntry> entries = [];
  String? selectedWord; // 클릭된 단어 저장
  List<_WordPosition> wordPositions = []; // 단어별 위치 저장

  @override
  void initState() {
    super.initState();
    _loadAllSummaryData();
  }

  void showMonthCalander() {
    String selectedMonth;
    showMonthPicker(context: context, initialDate: DateTime.now()).then((
      DateTime? date,
    ) {
      if (date != null) {
        selectDate(date);
        selectedMonth = "${date.year}년 ${date.month}월";
        showToastMessage("선택한 월: $selectedMonth");
      }
    });
  }

  List<_WordEntry> _generateWordEntries() {
    final values = keywordCounts.values;
    if (values.isEmpty) return [];

    final minValue = values.reduce(min);
    final maxValue = values.reduce(max);

    const double minFontSize = 8;
    const double maxFontSize = 72;

    List<_WordEntry> list =
        keywordCounts.entries.map((e) {
          final fontSize =
              minValue == maxValue
                  ? (minFontSize + maxFontSize) / 2
                  : minFontSize +
                      (e.value - minValue) *
                          (maxFontSize - minFontSize) /
                          (maxValue - minValue);
          return _WordEntry(text: e.key, value: e.value, fontSize: fontSize);
        }).toList();

    // 큰 단어부터 내림차순 정렬
    list.sort((a, b) => b.fontSize.compareTo(a.fontSize));
    return list;
  }

  // WordCloudPainter에서 위치 계산 후 전달받음
  void _updateWordPositions(List<_WordPosition> positions) {
    setState(() {
      wordPositions = positions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 제목 및 아이콘
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$currentMonth 주요 이벤트",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              IconButton(
                onPressed: () {
                  showMonthCalander();
                  // 선택된 단어 초기화
                  setState(() {
                    selectedWord = null;
                  });
                },
                icon: Icon(Icons.calendar_month, size: 40),
              ),
            ],
          ),
        ),
        Divider(color: Color(0xff919572), thickness: 1),
        SizedBox(height: 30),

        // 워드클라우드 + 클릭 영역 (Stack)
        SizedBox(
          width: 380,
          height: 380,
          child: Stack(
            children: [
              CustomPaint(
                size: Size(380, 380),
                painter: WordCloudPainter(
                  entries,
                  onPositionsCalculated: _updateWordPositions,
                ),
              ),
              ...wordPositions.map((wp) {
                return Positioned(
                  left: wp.rect.left,
                  top: wp.rect.top,
                  width: wp.rect.width,
                  height: wp.rect.height,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedWord = wp.text;
                        selectWord(wp.text);
                      });
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(),
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 20),

        // 클릭된 단어 표시
        if (selectedWord != null)
          Text(
            '선택된 단어: $selectedWord',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
      ],
    );
  }
}

class WordCloudPainter extends CustomPainter {
  final List<_WordEntry> words;
  final Random random = Random();
  final void Function(List<_WordPosition>)? onPositionsCalculated;

  WordCloudPainter(this.words, {this.onPositionsCalculated});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final usedRects = <Rect>[];
    final positions = <_WordPosition>[];

    if (words.isEmpty) return;

    // 1. 가장 큰 단어는 정중앙에 고정
    final biggest = words.first;
    final textStyleBiggest = TextStyle(
      fontSize: biggest.fontSize,
      fontWeight: FontWeight.bold,
      color: Colors.primaries[biggest.text.hashCode % Colors.primaries.length],
    );
    final tpBiggest = TextPainter(
      text: TextSpan(text: biggest.text, style: textStyleBiggest),
      textDirection: TextDirection.ltr,
    )..layout();

    final biggestPosition =
        center - Offset(tpBiggest.width / 2, tpBiggest.height / 2);
    tpBiggest.paint(canvas, biggestPosition);
    final biggestRect = biggestPosition & tpBiggest.size;
    usedRects.add(biggestRect);
    positions.add(_WordPosition(biggest.text, biggestRect));

    // 2. 나머지 단어 나선형 배치
    for (var word in words.skip(1)) {
      final textStyle = TextStyle(
        fontSize: word.fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.primaries[word.text.hashCode % Colors.primaries.length],
      );
      final tp = TextPainter(
        text: TextSpan(text: word.text, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      Offset? position;

      for (double r = 0; r < size.width / 2; r += 5) {
        for (double angle = 0; angle < 2 * pi; angle += pi / 12) {
          final dx = r * cos(angle);
          final dy = r * sin(angle);
          final candidate =
              center + Offset(dx, dy) - Offset(tp.width / 2, tp.height / 2);
          final rect = candidate & tp.size;

          if (!_collides(rect, usedRects, size)) {
            position = candidate;
            usedRects.add(rect);
            positions.add(_WordPosition(word.text, rect));
            break;
          }
        }
        if (position != null) break;
      }

      if (position != null) {
        tp.paint(canvas, position);
      }
    }

    if (onPositionsCalculated != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onPositionsCalculated!(positions);
      });
    }
  }

  bool _collides(Rect rect, List<Rect> others, Size size) {
    if (!Rect.fromLTWH(0, 0, size.width, size.height).contains(rect.topLeft) ||
        !Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ).contains(rect.bottomRight)) {
      return true;
    }

    for (var other in others) {
      if (rect.overlaps(other)) return true;
    }
    return false;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _WordEntry {
  final String text;
  final int value;
  final double fontSize;

  _WordEntry({required this.text, required this.value, required this.fontSize});
}

// 단어 텍스트와 위치(Rect) 저장용
class _WordPosition {
  final String text;
  final Rect rect;

  _WordPosition(this.text, this.rect);
}
