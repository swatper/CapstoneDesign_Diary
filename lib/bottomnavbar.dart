import 'package:flutter/material.dart';
import 'package:capstone_diary/homewindow.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const List<Widget> _widgetOptions = <Widget>[
    HomeWindow(),
    //TODO (만든 화면 불러오기)
    Text('통계', style: optionStyle),
    Text('일기 목록', style: optionStyle),
    Text('들춰보기 (공유 일기 목록)', style: optionStyle),
    Text('도전 과제 목록', style: optionStyle),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      //네비게이션 바 구성
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          CreateBottomNavigationBarItem(Icons.home, "홈"),
          CreateBottomNavigationBarItem(Icons.description, "통계"),
          CreateBottomNavigationBarItem(Icons.book, "일기"),
          CreateBottomNavigationBarItem(Icons.remove_red_eye, "들춰보기"),
          CreateBottomNavigationBarItem(Icons.flag, "도전과제제"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.black,
        //fixed를 통해 글자 검은색은 되지만, 선택 애니메이션은 사라짐
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

//네비 아이템 생성 메서드
BottomNavigationBarItem CreateBottomNavigationBarItem(
  IconData icon,
  String label,
) {
  return BottomNavigationBarItem(
    icon: Icon(icon, size: 40),
    label: label,
    backgroundColor: Colors.white,
  );
}

//참고자료
//https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
