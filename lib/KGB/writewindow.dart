import 'package:flutter/material.dart';

class WriteWindow extends StatefulWidget {
  const WriteWindow({super.key});
  @override
  State<WriteWindow> createState() => _WriteWindow();
}

void onClickedBackButton() {}
void onClickedNestButton() {}
void onClickedCalanderButton() {}

class _WriteWindow extends State<WriteWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFE4B5),
      body: Padding(
        padding: const EdgeInsets.only(top: 45), // 전체 Column 위쪽에 패딩 추가
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: onClickedBackButton,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: 30,
                      color: Colors.amber,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 248, 229),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: Size(80, 35),
                    ),
                    onPressed: onClickedNestButton,
                    child: Text('다음', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Transform.translate(
                            offset: Offset(0, 10),
                            child: Text('2025', style: TextStyle(fontSize: 15)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text('10월 12일', style: TextStyle(fontSize: 22)),
                          IconButton(
                            onPressed: onClickedCalanderButton,
                            icon: Icon(Icons.calendar_month_outlined),
                            iconSize: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  WeatherButton(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style: TextStyle(fontSize: 25),
                  decoration: InputDecoration(
                    labelText: '제목',
                    labelStyle: TextStyle(fontSize: 25, color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(width: 100),
                    ),
                  ),
                  maxLines: null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    labelText: '내용을 입력하세요.',
                    labelStyle: TextStyle(fontSize: 15, color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherButton extends StatefulWidget {
  const WeatherButton({super.key});

  @override
  State<WeatherButton> createState() => _WeatherButtonState();
}

class _WeatherButtonState extends State<WeatherButton> {
  Widget selectedWeatherIcon = Image.asset(
    'assets/images/wd_sun.png', // 초기 이미지
    width: 50,
    height: 50,
  );

  void onClickedWeatherButton() async {
    // 날씨 아이콘 선택을 위한 다이얼로그 표시
    Widget? newIcon = await showGeneralDialog<Widget>(
      context: context,
      barrierDismissible: true, // 다이얼로그 외부를 클릭하면 닫힘
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54, // 배경색
      transitionDuration: const Duration(milliseconds: 300), // 애니메이션 지속 시간
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return Align(
          alignment: Alignment.topCenter, // 다이얼로그 위치를 화면 상단으로 이동
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.93, // 화면 너비의 60%
              margin: const EdgeInsets.only(top: 140), // 상단 여백
              //padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/weatherBack.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center, // 세로 방향 중앙 정렬
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '날씨를 선택하세요',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 1,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/images/wd_sun.png',
                          width: 45,
                          height: 45,
                        ),
                        onPressed:
                            () => Navigator.pop(
                              context,
                              Image.asset(
                                'assets/images/wd_sun.png',
                                width: 50,
                                height: 50,
                              ),
                            ),
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/wd_cloud.png',
                          width: 45,
                          height: 45,
                        ),
                        onPressed:
                            () => Navigator.pop(
                              context,
                              Image.asset(
                                'assets/images/wd_cloud.png',
                                width: 50,
                                height: 50,
                              ),
                            ),
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/wd_rain.png',
                          width: 45,
                          height: 45,
                        ),
                        onPressed:
                            () => Navigator.pop(
                              context,
                              Image.asset(
                                'assets/images/wd_rain.png',
                                width: 50,
                                height: 50,
                              ),
                            ),
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/wd_wind.png',
                          width: 45,
                          height: 45,
                        ),
                        onPressed:
                            () => Navigator.pop(
                              context,
                              Image.asset(
                                'assets/images/wd_wind.png',
                                width: 50,
                                height: 50,
                              ),
                            ),
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/wd_snow.png',
                          width: 45,
                          height: 45,
                        ),
                        onPressed:
                            () => Navigator.pop(
                              context,
                              Image.asset(
                                'assets/images/wd_snow.png',
                                width: 50,
                                height: 50,
                              ),
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );

    // 선택된 아이콘 업데이트
    if (newIcon != null) {
      setState(() {
        selectedWeatherIcon = newIcon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onClickedWeatherButton,
      icon: selectedWeatherIcon, // 선택된 이미지 또는 아이콘 표시
      iconSize: 50,
    );
  }
}
