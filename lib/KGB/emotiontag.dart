import 'package:flutter/material.dart';

class EmotionTag extends StatelessWidget {
  final int emotionIndex;

  EmotionTag({super.key, required this.emotionIndex});

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
        '#${emotions[emotionIndex.clamp(0, emotions.length - 1)]}';

    return Container(
      decoration: BoxDecoration(
        color: Colors.amber[400],
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    );
  }
}
