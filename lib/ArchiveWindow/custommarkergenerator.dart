import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkerGenerator {
  //싱글톤 적용
  static final CustomMarkerGenerator _instance =
      CustomMarkerGenerator._internal();
  factory CustomMarkerGenerator() => _instance;
  final String baseImagePath = "assets/images/icons/marker.png";
  CustomMarkerGenerator._internal();

  //커스텀 마커 생성 메서드
  Future<BitmapDescriptor> createMarkerWithText({
    required String text,
    double textSize = 32,
    Color textColor = const ui.Color.fromARGB(255, 0, 0, 0),
    double imageSize = 150,
  }) async {
    //커스텀 마커 가져오기
    final ByteData byteData = await rootBundle.load(baseImagePath);

    //가져온 마커 이미지 디코딩
    final ui.Codec codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: imageSize.toInt(),
      targetHeight: imageSize.toInt(),
    );

    //디코딩된 이미지에서 프레임 가져오기
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image baseImage = frameInfo.image;

    //캔버스 생성
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    //캔버스에 그리기
    canvas.drawImage(baseImage, Offset.zero, Paint());

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: textSize,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    //텍스트 크기 설정
    textPainter.layout();

    //텍스트가 위치할 offset 계산
    final offset = Offset(
      (imageSize - textPainter.width) / 2,
      (imageSize - textPainter.height) / 2 - 5,
    );

    //캔버스에 텍스트 그리기(추가)
    textPainter.paint(canvas, offset);

    final ui.Image finalImage = await recorder.endRecording().toImage(
      imageSize.toInt(),
      imageSize.toInt(),
    );

    final ByteData? pngBytes = await finalImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    final Uint8List data = pngBytes!.buffer.asUint8List();

    return BitmapDescriptor.bytes(data);
  }
}
