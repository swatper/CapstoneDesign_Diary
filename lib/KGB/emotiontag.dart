import 'package:flutter/material.dart';

class EmotionTag extends StatefulWidget {
  final int emotionIndex;
  final void Function()? onDelete;

  const EmotionTag({super.key, required this.emotionIndex, this.onDelete});

  @override
  State<EmotionTag> createState() => _EmotionTagState();
}

class _EmotionTagState extends State<EmotionTag> {
  bool _showDelete = false;

  final List<String> emotions = [
    '기쁨',
    '행복',
    '설렘',
    '화남',
    '우울함',
    '슬픔',
    '불안',
    '놀람',
    '부끄러움',
    '지루함',
  ];

  @override
  Widget build(BuildContext context) {
    final String label =
        '#${emotions[widget.emotionIndex.clamp(0, emotions.length - 1)]}';

    return GestureDetector(
      onTap: () {
        setState(() {
          _showDelete = !_showDelete;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.amber[400],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            if (_showDelete && widget.onDelete != null)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: GestureDetector(
                  onTap: widget.onDelete,
                  child: const Icon(Icons.close, size: 16, color: Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
