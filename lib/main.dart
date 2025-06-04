import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:capstone_diary/Utils/toastmessage.dart';
import 'package:capstone_diary/bottomnavbar.dart';
import 'package:capstone_diary/Views/searchingwindow.dart';
import 'package:capstone_diary/Calender/sidemenuwidget.dart';
//메인 화면
import 'package:capstone_diary/Views/loginwindow.dart';
import 'package:capstone_diary/Views/homewindow.dart'; //메인
import 'package:capstone_diary/Views/statisticswindow.dart'; //통계
import 'package:capstone_diary/Views/archivewindow.dart'; //일기 목록
import 'package:capstone_diary/KGB/shareddiary.dart'; //들춰보기
import 'package:capstone_diary/Views/challengewindow.dart'; //도전과제
//사이드 메뉴 관련 화면
import 'package:capstone_diary/Views/profilewindow.dart';
//일기쓰기 화면
import 'package:capstone_diary/KGB/writewindow.dart';
import 'package:capstone_diary/KGB/writewindowNext.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //화면 회전 잠금(세로 모드)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDiary',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', ''), // 한국어
        Locale('en', ''), // 영어
      ],
      home: HomeScreen(),
    );
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
  bool isLogin = false;
  DateTime? lastPressedAt; //뒤로가기 버튼을 눌렀을 때의 시간

  //메인 화면 리스트
  late List<Widget> mainScreens;
  //사이드 메뉴 화면 리스트
  late List<Widget> sideScreens;
  //글쓰기 화면 리스트
  late List<Widget> writeScreens;
  //현재 보고 있는 화면
  Widget currentScreen = const Center(child: CircularProgressIndicator());

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
      currentScreen = mainScreens[index];
    });
  }

  void updateSideMenuSelectedIndex(int index) {
    setState(() {
      if (index > 0) {
        showToastMessage("준비 중입니다.");
        return;
      }
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

  void gotoSrearchWithOption(String option, String value) {
    setState(() {
      currentScreen = ArchiveWindow(
        selectDiary: updateWriteWindow,
        logOutCallback: updateLoginStatus,
        option: option,
        value: value,
      );
    });
    _selectedIndex = 2;
  }

  void setSearchWindow() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Searchingwindow(onSearch: gotoSrearchWithOption),
      ),
    );
  }

  void showSideMenu() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(1.0, 0),
              end: Offset(0, 0),
            ).animate(animation),
            child: SideMenuWidget(
              sideMenuSelectedIndex: updateSideMenuSelectedIndex,
              logOutCallback: updateLoginStatus,
            ),
          );
        },
      ),
    );
  }

  void updateLoginStatus(bool status) {
    if (status) {
      isLogin = true;
      updateSelectedIndex(0);
    } else {
      isLogin = false;
      updateSelectedIndex(5); //로그인 화면으로 이동
    }
  }

  bool isNeedAppbar() {
    return isLogin &&
        _selectedIndex < 4 &&
        (currentScreen is HomeWindow ||
            currentScreen is StatisticsWindow ||
            currentScreen is ArchiveWindow ||
            currentScreen is SharedDiary);
  }

  @override
  void initState() {
    super.initState();

    //메인 화면 리스트 초기화
    mainScreens = [
      HomeWindow(
        writeWindowIndex: updateWriteSelectedIndex,
        selectDiary: updateWriteWindow,
        logOutCallback: updateLoginStatus,
      ),
      StatisticsWindow(logOutCallback: updateLoginStatus),
      ArchiveWindow(
        selectDiary: updateWriteWindow,
        logOutCallback: updateLoginStatus,
      ),
      SharedDiary(logOutCallback: updateLoginStatus),
      ChallengeWindow(),
      LoginWindow(onLogin: updateLoginStatus),
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
      Text('도움말', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    ];

    //글쓰기 화면 리스트 초기화
    writeScreens = [
      WriteWindow(
        setWriteWindowNext: updateWriteWindow,
        goBackToHome: () => updateSelectedIndex(0),
      ),
    ];

    //초기 화면 설정: 코드 중복
    if (isLogin) {
      //로그인 정보가 있으면
      currentScreen = mainScreens[0];
    } else {
      currentScreen = mainScreens[5];
      updateSelectedIndex(5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          if (currentScreen == mainScreens[0] || !isLogin) {
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
        appBar:
            isNeedAppbar()
                ? AppBar(
                  backgroundColor: Color(0xffFFE4B5),
                  centerTitle: true,
                  actions: [
                    currentScreen is! SharedDiary
                        ? IconButton(
                          onPressed: setSearchWindow,
                          icon: Icon(Icons.search, size: 35),
                        )
                        : SizedBox.shrink(),
                    IconButton(
                      onPressed: showSideMenu,
                      icon: Icon(Icons.menu, size: 35),
                    ),
                    SizedBox(width: 20),
                  ],
                )
                : null, //메인 화면
        body: currentScreen,
        //하단 네비게이션 바
        bottomNavigationBar:
            isLogin
                ? Container(
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
                )
                : null,
      ),
    );
  }
}
