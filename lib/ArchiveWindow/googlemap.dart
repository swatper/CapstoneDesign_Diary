import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DiaryMap extends StatefulWidget {
  const DiaryMap({super.key});

  @override
  _DiaryMapState createState() => _DiaryMapState();
}

class _DiaryMapState extends State<DiaryMap> {
  GoogleMapController? _mapController;

  static const LatLng _initialPosition = LatLng(37.5665, 126.9780); // 서울

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 12,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
