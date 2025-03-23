import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Customcalender extends StatefulWidget {
  final Color? backgroundColor; // 배경 색상 매개변수 추가

  const Customcalender({super.key, this.backgroundColor});

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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TableCalendar(
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
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        //꾸미기 builder
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, day, focusedDay) {
            return DateBox(day, Colors.white, Colors.black);
          },
          todayBuilder: (context, day, focusedDay) {
            return DateBox(day, Colors.white, Colors.amberAccent);
          },
          defaultBuilder: (context, day, focusedDay) {
            return DateBox(day, Colors.black, Colors.white);
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
      ),
    );
  }

  //날짜
  Container DateBox(DateTime day, Color textcolor, Color bgcolor) {
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
            style: TextStyle(color: textcolor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Container Diarys(bool hasDiary) {
    return Container();
  }
}
