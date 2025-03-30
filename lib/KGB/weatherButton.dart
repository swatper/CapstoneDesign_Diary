import 'package:flutter/material.dart';

class WeatherButton extends StatefulWidget {
  const WeatherButton({super.key});

  @override
  State<WeatherButton> createState() => _WeatherButtonState();
}

class _WeatherButtonState extends State<WeatherButton> {
  final String sunIconPath = 'assets/images/wd_sun.png';
  final String cloudIconPath = 'assets/images/wd_cloud.png';
  final String rainIconPath = 'assets/images/wd_rain.png';
  final String windIconPath = 'assets/images/wd_wind.png';
  final String snowIconPath = 'assets/images/wd_snow.png';

  Widget selectedWeatherIcon = Image.asset(
    'assets/images/wd_sun.png', // 초기 이미지
    width: 50,
    height: 50,
  );

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
            selectedWeatherIcon = Image.asset(sunIconPath);
            break;
          case 'cloud':
            selectedWeatherIcon = Image.asset(cloudIconPath);
            break;
          case 'rain':
            selectedWeatherIcon = Image.asset(rainIconPath);
            break;
          case 'wind':
            selectedWeatherIcon = Image.asset(windIconPath);
            break;
          case 'snow':
            selectedWeatherIcon = Image.asset(snowIconPath);
            break;
          default:
            {
              selectedWeatherIcon = Image.asset(sunIconPath);
            } // 기본값 (예외처리)
        }
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
