//이 달력은 이제 안 씀씀
import 'package:flutter/material.dart';
import 'package:custom_calender_picker/custom_calender_picker.dart';

class CustomCalendarWidget extends StatefulWidget {
  final ReturnDateType returnDateType;
  final List<DateTime>? initialDateList;
  final DateTimeRange? initialDateRange;
  final CalenderThema calenderThema;
  final Color? rangeColor;
  final BorderRadius? borderRadius;

  const CustomCalendarWidget({
    super.key,
    required this.returnDateType,
    this.initialDateList,
    this.initialDateRange,
    this.calenderThema = CalenderThema.white,
    this.rangeColor,
    this.borderRadius,
  });

  @override
  State<CustomCalendarWidget> createState() => _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomCalenderPicker(
      returnDateType: widget.returnDateType,
      initialDateList: widget.initialDateList ?? [],
      initialDateRange: widget.initialDateRange,
      calenderThema: widget.calenderThema,
      rangeColor: widget.rangeColor ?? Colors.grey.withAlpha(125),
      borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
    );
  }
}
