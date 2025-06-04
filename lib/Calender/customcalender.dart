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
  State<Customcalender> createState() => _CustomcalenderState();
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
        //locale: 'ko-KR', 한글 안됨...
        firstDay: DateTime.utc(2020, 01, 01),
        lastDay: DateTime.utc(2030, 12, 31),
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
          dowBuilder: (context, day) {
            switch (day.weekday) {
              case 1:
                return Center(child: Text('월'));
              case 2:
                return Center(child: Text('화'));
              case 3:
                return Center(child: Text('수'));
              case 4:
                return Center(child: Text('목'));
              case 5:
                return Center(child: Text('금'));
              case 6:
                return Center(child: Text('토'));
              case 7:
                return Center(
                  child: Text('일', style: TextStyle(color: Colors.red)),
                );
            }
            return null;
          },
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
        //eventLoader: ,
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
