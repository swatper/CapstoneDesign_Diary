import 'package:flutter/material.dart';
import 'package:capstone_diary/Utils/toastmessage.dart';
import 'package:capstone_diary/HomeWindow/sidemenuwidget.dart';

class Statisticswindow extends StatefulWidget {
  final Function(int) sideMenuToHomeWindowIndex;
  const Statisticswindow({super.key, required this.sideMenuToHomeWindowIndex});
  @override
  State<Statisticswindow> createState() => _StatisticswindowState();
}

class _StatisticswindowState extends State<Statisticswindow> {
  final Map<String, int> emotionData = {
    '행복': 0,
    '슬픔': 0,
    '분노': 0,
    '불안': 0,
    '기쁨': 0,
    '우울': 0,
  };

  @override
  void initState() {
    super.initState();
  }

  void handleDateSelected(DateTime date) {
    setState(() {});
  }

  void searchDiray() {
    showToastMessage("아직 미구현");
  }

  //메뉴 버튼
  void showMenu() {
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
              sideMenuSelectedIndex: widget.sideMenuToHomeWindowIndex,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFE4B5),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: searchDiray,
                    icon: Icon(Icons.search, size: 35),
                  ),
                  IconButton(
                    onPressed: showMenu,
                    icon: Icon(Icons.menu, size: 35),
                  ),
                ],
              ),
              SizedBox(height: 10),
              //그래프 영역
            ],
          ),
        ),
      ),
    );
  }
}
