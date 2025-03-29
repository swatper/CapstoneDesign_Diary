import 'package:flutter/material.dart';
import 'package:capstone_diary/bottomnavbar.dart';
import 'package:capstone_diary/HomeWindow/homewindow.dart';
import 'package:capstone_diary/challenge/challengewindow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'MyDiary', home: HomeScreen());
  }
}

//메인 화면 Widget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  //메인 화면 리스트
  late List<Widget> _screens;
  //현재 보고 있는 화면
  late Widget currentScreen;

  void updateSelectedIndex(int index) {
    setState(() {
      if (index < 5) {
        _selectedIndex = index;
      }
      currentScreen = _screens[index];
    });
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeWindow(sideMenuToHomeWindowIndex: updateSelectedIndex),
      Text('통계', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      Text(
        '일기 목록',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      Text(
        '들춰보기 (공유 일기 목록)',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      Challengewindow(),
      Text('프로필', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    ];
    currentScreen = _screens[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFE4B5),
      //메인 화면
      body: Center(child: currentScreen),
      //하단 네비게이션 바
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        itemTapEvent: updateSelectedIndex,
      ),
    );
  }
}
