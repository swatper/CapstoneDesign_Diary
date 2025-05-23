import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:capstone_diary/Utils/toastmessage.dart';
import 'package:capstone_diary/bottomnavbar.dart';
//메인 화면
import 'package:capstone_diary/Views/homewindow.dart'; //메인
import 'package:capstone_diary/Views/statisticswindow.dart'; //통계
import 'package:capstone_diary/Views/archivewindow.dart'; //일기 목록
import 'package:capstone_diary/KGB/shareddiary.dart'; //들춰보기
import 'package:capstone_diary/Views/challengewindow.dart'; //도전과제
//사이드 메뉴 관련 화면
import 'package:capstone_diary/Views/profilewindow.dart';
//일기쓰기 화면
import 'package:capstone_diary/KGB/writewindow.dart';

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
  DateTime? lastPressedAt; //뒤로가기 버튼을 눌렀을 때의 시간

  //메인 화면 리스트
  late List<Widget> mainScreens;
  //사이드 메뉴 화면 리스트
  late List<Widget> sideScreens;
  //글쓰기 화면 리스트
  late List<Widget> writeScreens;
  //현재 보고 있는 화면
  late Widget currentScreen;

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
      currentScreen = mainScreens[index];
    });
  }

  void updateSideMenuSelectedIndex(int index) {
    setState(() {
      currentScreen = sideScreens[index];
    });
  }

  void updateWriteSelectedIndex(int index) {
    setState(() {
      currentScreen = writeScreens[index];
    });
  }

  void updateWriteWindow(Widget writeWindow) {
    setState(() {
      currentScreen = writeWindow;
    });
  }

  void setSearchWindow(Widget diaryView) {
    setState(() {
      currentScreen = diaryView;
    });
  }

  @override
  void initState() {
    super.initState();

    //메인 화면 리스트 초기화
    mainScreens = [
      HomeWindow(
        sideMenuToHomeWindowIndex: updateSideMenuSelectedIndex,
        writeWindowIndex: updateWriteSelectedIndex,
        selectDiary: updateWriteWindow,
        diaryView: setSearchWindow,
      ),
      StatisticsWindow(sideMenuToHomeWindowIndex: updateSideMenuSelectedIndex),
      ArchiveWindow(
        sideMenuToHomeWindowIndex: updateSideMenuSelectedIndex,
        selectDiary: updateWriteWindow,
      ),
      SharedDiary(sideMenuToHomeWindowIndex: updateSideMenuSelectedIndex),
      ChallengeWindow(),
    ];

    //사이드 메뉴 화면 리스트 초기화
    sideScreens = [
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
    ];

    //글쓰기 화면 리스트 초기화
    writeScreens = [
      WriteWindow(
        setWriteWindowNext: updateWriteWindow,
        goBackToHome: () => updateSelectedIndex(0),
      ),
    ];

    //초기 화면 설정
    currentScreen = mainScreens[0];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          if (currentScreen == mainScreens[0]) {
            DateTime now = DateTime.now();
            if (lastPressedAt == null ||
                now.difference(lastPressedAt!) > Duration(seconds: 2)) {
              lastPressedAt = now;
              showToastMessage("한 번 더 누르면 종료됩니다.");
              return;
            } else {
              //앱 종료
              SystemNavigator.pop();
            }
          } else {
            //다른 화면을 보고 있을 경우
            setState(() {
              updateSelectedIndex(0);
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xffFFE4B5),
        //메인 화면
        body: currentScreen,
        //하단 네비게이션 바
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavBar(
            selectedIndex: _selectedIndex,
            itemTapEvent: updateSelectedIndex,
          ),
        ),
      ),
    );
  }
}
