import 'package:flutter/material.dart';
import 'package:capstone_diary/bottomnavbar.dart';
import 'package:capstone_diary/KGB/writewindow.dart';
//메인 화면
import 'package:capstone_diary/HomeWindow/homewindow.dart'; //메인
import 'package:capstone_diary/StatisticsWindow/statisticswindow.dart'; //통계
import 'package:capstone_diary/ArchiveWindow/archivewibdow.dart'; //일기 목록
import 'package:capstone_diary/ChallengeWindow/challengewindow.dart'; //도전과제
//사이드 메뉴 관련 화면
import 'package:capstone_diary/profilewindow.dart';

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
      StatisticsWindow(sideMenuToHomeWindowIndex: updateSelectedIndex),
      ArchiveWindow(sideMenuToHomeWindowIndex: updateSelectedIndex),
      Text(
        '들춰보기 (공유 일기 목록)',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      //Sidemenu에서 선택한 화면
      ChallengeWindow(),
      ProfileWindow(backButtonEvent: updateSelectedIndex),
      Text(
        '알람 설정',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      Text(
        '약관 및 정책',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      Text(
        '회원 탈퇴',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      WriteWindow(backButtonCallback: updateSelectedIndex),
    ];

    //처음에 보여줄 화면
    currentScreen = _screens[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFE4B5),
      //메인 화면
      body: currentScreen,
      //하단 네비게이션 바
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        itemTapEvent: updateSelectedIndex,
      ),
    );
  }
}
