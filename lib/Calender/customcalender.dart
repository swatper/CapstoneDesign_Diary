import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Customcalender extends StatefulWidget {
  final Color? backgroundColor;
  final Function(DateTime) getSelectedDate;

  const Customcalender({
    super.key,
    this.backgroundColor,
    required this.getSelectedDate,
  });

  @override
  _CustomcalenderState createState() => _CustomcalenderState();
}

class _CustomcalenderState extends State<Customcalender> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TableCalendar(
        //locale: 'ko_KR',
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          //선택한 날짜 넘겨주기
          widget.getSelectedDate(selectedDay);
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        //꾸미기
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, day, focusedDay) {
            return dateBox(day, Colors.white, Colors.black);
          },
          todayBuilder: (context, day, focusedDay) {
            return dateBox(day, Colors.white, Colors.amberAccent);
          },
          defaultBuilder: (context, day, focusedDay) {
            return dateBox(day, Colors.black, Colors.white);
          },
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          //월-연도
          titleTextStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          //월 바꾸는 아이콘
          leftChevronIcon: Icon(Icons.chevron_left),
          rightChevronIcon: Icon(Icons.chevron_right),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //날짜
  Container dateBox(DateTime day, Color textcolor, Color bgcolor) {
    return Container(
      //배경
      decoration: BoxDecoration(color: bgcolor, shape: BoxShape.rectangle),
      alignment: Alignment.center,
      margin: EdgeInsets.all(5),
      //날짜
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day.day.toString(),
            style: TextStyle(
              color: textcolor,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
