import 'package:flutter/material.dart';
import 'package:capstone_diary/Utils/assetmanager.dart';

class WeatherButton extends StatefulWidget {
  int? weatherIndex = 0; // 날씨 아이콘 인덱스 (0: 맑음, 1: 흐림, 2: 비, 3: 바람, 4: 눈)
  bool? isButtonActive = true;
  WeatherButton({
    super.key,
    this.weatherIndex,
    this.isButtonActive,
    this.onWeatherChanged,
  });
  final Function(int)? onWeatherChanged;

  @override
  State<WeatherButton> createState() => _WeatherButtonState();
}

class _WeatherButtonState extends State<WeatherButton> {
  final String sunIconPath = 'assets/images/wd_sun.png';
  final String cloudIconPath = 'assets/images/wd_cloud.png';
  final String rainIconPath = 'assets/images/wd_rain.png';
  final String windIconPath = 'assets/images/wd_wind.png';
  final String snowIconPath = 'assets/images/wd_snow.png';
  final List<String> weatherIconPaths = [
    'assets/images/wd_sun.png',
    'assets/images/wd_cloud.png',
    'assets/images/wd_rain.png',
    'assets/images/wd_wind.png',
    'assets/images/wd_snow.png',
  ];
  late int weatherIndex; // 날씨 아이콘 인덱스 (0: 맑음, 1: 흐림, 2: 비, 3: 바람, 4: 눈)
  late Widget selectedWeatherIcon;
  late bool isButtonActive;
  @override
  void initState() {
    super.initState();
    weatherIndex = widget.weatherIndex ?? 0;
    isButtonActive = widget.isButtonActive ?? true;
    selectedWeatherIcon = Image.asset(
      weatherIconPaths[weatherIndex], // 초기 이미지 설정
      width: 50,
      height: 50,
    );
  }

  void onClickedWeatherButton() async {
    // 날씨 아이콘 선택을 위한 다이얼로그 표시
    String? newIcon = await showGeneralDialog<String>(
      context: context,
      barrierDismissible: true, // 다이얼로그 외부를 클릭하면 닫힘
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54, // 배경색
      transitionDuration: const Duration(milliseconds: 100), // 애니메이션 지속 시간
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
              margin: const EdgeInsets.only(top: 170), // 상단 여백
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
                  SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 1,
                    children: [
                      WeatherIconButton(weatherType: 'sun'),
                      WeatherIconButton(weatherType: 'cloud'),
                      WeatherIconButton(weatherType: 'rain'),
                      WeatherIconButton(weatherType: 'wind'),
                      WeatherIconButton(weatherType: 'snow'),
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
        switch (newIcon) {
          case 'sun':
            selectedWeatherIcon = AssetManager.instance.getWeatherImage(
              "wd_sun.png",
              45,
              45,
            );
            weatherIndex = 0;
            break;
          case 'cloud':
            selectedWeatherIcon = Image.asset(cloudIconPath);
            weatherIndex = 1;
            break;
          case 'rain':
            selectedWeatherIcon = Image.asset(rainIconPath);
            weatherIndex = 2;
            break;
          case 'wind':
            selectedWeatherIcon = Image.asset(windIconPath);
            weatherIndex = 3;
            break;
          case 'snow':
            selectedWeatherIcon = Image.asset(snowIconPath);
            weatherIndex = 4;
            break;
          default:
            {
              selectedWeatherIcon = Image.asset(sunIconPath);
            } // 기본값 (예외처리)
        }
        widget.onWeatherChanged?.call(weatherIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isButtonActive ? onClickedWeatherButton : null,
      icon: selectedWeatherIcon, // 선택된 이미지 또는 아이콘 표시
      iconSize: 50,
    );
  }
}

class WeatherIconButton extends StatelessWidget {
  final String weatherType;
  const WeatherIconButton({super.key, required this.weatherType});

  String get weatherIconPath {
    switch (weatherType) {
      case 'sun':
        return 'assets/images/wd_sun.png';
      case 'cloud':
        return 'assets/images/wd_cloud.png';
      case 'rain':
        return 'assets/images/wd_rain.png';
      case 'wind':
        return 'assets/images/wd_wind.png';
      case 'snow':
        return 'assets/images/wd_snow.png';
      default:
        return 'assets/images/wd_sun.png'; // 기본값 (예외처리)
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        weatherIconPath,
        width: 45,
        height: 45,
        fit: BoxFit.contain,
      ),
      onPressed:
          () => Navigator.pop(
            context,
            weatherType, // 선택된 이미지 반환
          ),
    );
  }
}
