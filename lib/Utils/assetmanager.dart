import 'package:flutter/material.dart';

// AssetManager 클래스 (싱글톤)
class AssetManager {
  String profilePath = 'assets/images/profile/';
  String weatherPath = 'assets/images/weather/';
  String iconPath = 'assets/images/icons/';
  String chanllengePath = 'assets/images/challenge/';
  String etcPath = 'assets/images/etc/';

  AssetManager._privateConstructor();
  static final AssetManager _instance = AssetManager._privateConstructor();
  static AssetManager get instance => _instance;

  Widget getProfileImage(String imageName, double width, double height) {
    return Image.asset(
      profilePath + imageName,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  Widget getWeatherImage(String imageName, double width, double height) {
    return Image.asset(weatherPath + imageName, width: width, height: height);
  }

  AssetImage getWeatherImage2(String imageName) {
    return AssetImage(weatherPath + imageName);
  }

  Widget getIconImage(String imageName, double width, double height) {
    return Image.asset(iconPath + imageName, width: width, height: height);
  }

  Widget getChallengeImage(String imageName, double width, double height) {
    return Image.asset(
      chanllengePath + imageName,
      width: width,
      height: height,
    );
  }

  Widget getEtcImage(String imageName) {
    return Image.asset(etcPath + imageName, fit: BoxFit.cover);
  }
}
