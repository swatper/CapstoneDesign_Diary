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
  Function(int)? onWeatherChanged;

  @override
  State<WeatherButton> createState() => _WeatherButtonState();
}

class _WeatherButtonState extends State<WeatherButton> {
  late int weatherIndex; // 날씨 아이콘 인덱스 (0: 맑음, 1: 흐림, 2: 비, 3: 바람, 4: 눈)
  late Widget selectedWeatherIcon;
  late bool isButtonActive;
  @override
  void initState() {
    super.initState();
    weatherIndex = widget.weatherIndex ?? 0;
    isButtonActive = widget.isButtonActive ?? true;
    selectedWeatherIcon = getWeatherIcon();
  }

  Widget getWeatherIcon() {
    switch (weatherIndex) {
      case 0:
        return AssetManager.instance.getWeatherImage("wd_sun.png", 45, 45);
      case 1:
        return AssetManager.instance.getWeatherImage("wd_cloud.png", 45, 45);
      case 2:
        return AssetManager.instance.getWeatherImage("wd_rain.png", 45, 45);
      case 3:
        return AssetManager.instance.getWeatherImage("wd_wind.png", 45, 45);
      case 4:
        return AssetManager.instance.getWeatherImage("wd_snow.png", 45, 45);
      default:
        return AssetManager.instance.getWeatherImage("wd_sun.png", 45, 45);
    }
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
                  image: AssetManager.instance.getWeatherImage2(
                    "weatherBack.png",
                  ),
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
            selectedWeatherIcon = AssetManager.instance.getWeatherImage(
              "wd_cloud.png",
              45,
              45,
            );
            weatherIndex = 1;
            break;
          case 'rain':
            selectedWeatherIcon = AssetManager.instance.getWeatherImage(
              "wd_rain.png",
              45,
              45,
            );
            weatherIndex = 2;
            break;
          case 'wind':
            selectedWeatherIcon = AssetManager.instance.getWeatherImage(
              "wd_wind.png",
              45,
              45,
            );
            weatherIndex = 3;
            break;
          case 'snow':
            selectedWeatherIcon = AssetManager.instance.getWeatherImage(
              "wd_snow.png",
              45,
              45,
            );
            weatherIndex = 4;
            break;
          default:
            {
              selectedWeatherIcon = AssetManager.instance.getWeatherImage(
                "wd_sun.png",
                45,
                45,
              );
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

  Widget get weatherIconImage {
    switch (weatherType) {
      case 'sun':
        return AssetManager.instance.getWeatherImage("wd_sun.png", 45, 45);
      case 'cloud':
        return AssetManager.instance.getWeatherImage("wd_cloud.png", 45, 45);
      case 'rain':
        return AssetManager.instance.getWeatherImage("wd_rain.png", 45, 45);
      case 'wind':
        return AssetManager.instance.getWeatherImage("wd_wind.png", 45, 45);
      case 'snow':
        return AssetManager.instance.getWeatherImage("wd_snow.png", 45, 45);
      default:
        return AssetManager.instance.getWeatherImage("wd_sun.png", 45, 45);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: weatherIconImage,
      onPressed:
          () => Navigator.pop(
            context,
            weatherType, // 선택된 이미지 반환
          ),
    );
  }
}
