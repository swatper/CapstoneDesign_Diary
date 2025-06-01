import 'package:flutter/material.dart';

class SummaryTag extends StatefulWidget {
  final String summary;
  final void Function()? onDelete;

  const SummaryTag({super.key, required this.summary, this.onDelete});

  @override
  State<SummaryTag> createState() => _SummaryTagState();
}

class _SummaryTagState extends State<SummaryTag> {
  bool _showDelete = false;

  @override
  Widget build(BuildContext context) {
    final String label = '#${widget.summary}';

    return GestureDetector(
      onTap: () {
        setState(() {
          _showDelete = !_showDelete;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 253, 110),
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
