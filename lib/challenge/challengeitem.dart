import 'package:flutter/material.dart';

class ChallengeItem extends StatelessWidget {
  final String title;
  final String description;
  final int currentProgress;
  final int maxProgress;

  const ChallengeItem({
    super.key,
    required this.title,
    required this.description,
    required this.currentProgress,
    required this.maxProgress,
  });

  @override
  Widget build(BuildContext context) {
    double progress = maxProgress > 0 ? currentProgress / maxProgress : 0.0;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xffFFCB6C),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Image.asset('assets/images/default.png', width: 100, height: 100),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 10,
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          color: Color(0xffA7ECF9),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("$currentProgress/$maxProgress"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
