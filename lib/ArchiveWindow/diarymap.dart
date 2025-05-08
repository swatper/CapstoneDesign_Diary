import 'package:flutter/material.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:capstone_diary/ArchiveWindow/diaryclusteritem.dart';
import 'package:capstone_diary/ArchiveWindow/custommarkergenerator.dart';
import 'package:capstone_diary/Utils/toastmessage.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart'
    as cmanager;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class DiaryMap extends StatefulWidget {
  final List<DiaryModel> diaryList;
  const DiaryMap({super.key, required this.diaryList});

  @override
  State<DiaryMap> createState() => _DiaryMapState();
}

class _DiaryMapState extends State<DiaryMap> {
  late GoogleMapController? mapController;
  //초기 위도 경도(서울 기준)
  double curLat = 37.5665;
  double curLng = 126.9780;
  late LatLng curPos = LatLng(37.5665, 126.9780);

  late cmanager.ClusterManager<DiaryClusterItem> clusterManager; //클러스터 매니저
  Set<Marker> diarymarkers = {}; //마커를 저장할 Set

  void setCurrentLocation() async {
    try {
      //위치 권한 승인
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        //권한 요청
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showToastMessage("위치 권한이 거부되었습니다.");
          return;
        }
      }

      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
      showToastMessage("현재 위치: ${position.latitude}, ${position.longitude}");
      /*setState(() {
        curLat = position.latitude;
        curLng = position.longitude;
        curPos = LatLng(curLat, curLng);
      });*/
    } catch (e) {
      showToastMessage("현재 위치를 가져오는 중 오류 발생: $e");
    }
  }

  //클러스터를 마커로 변환
  void updateMarkers(Set<Marker> markers) {
    if (!mounted) return;
    setState(() {
      diarymarkers = markers;
    });
  }

  Future<Marker> markerBuilder(
    cmanager.Cluster<DiaryClusterItem> cluster,
  ) async {
    if (cluster.isMultiple) {
      return Marker(
        markerId: MarkerId(cluster.getId()),
        position: cluster.location,
        anchor: Offset(0.5, 1.0),
        icon: await CustomMarkerGenerator().createMarkerWithText(
          text: cluster.count.toString(),
          textSize: 16,
          imageSize: 60,
        ),
      );
    } else {
      final diary = cluster.items.first.diaryModel;
      return Marker(
        markerId: MarkerId(diary.date),
        position: LatLng(diary.lat, diary.lng),
        anchor: Offset(0.5, 1.0),
        icon: await CustomMarkerGenerator().createMarkerWithText(
          text: "1",
          textSize: 16,
          imageSize: 60,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    //현재 위치 값 가져오기
    //setCurrentLocation();

    //클러스터 생성 및 초기화 (DirayModel -> DiaryClusterItem)
    List<DiaryClusterItem> clusterItems =
        widget.diaryList
            .map((diary) => DiaryClusterItem(diary))
            .toList(); //일기 목록을 클러스터 아이템으로 변환

    //클러스터 매니저 초기화 (DiaryClustyerItem -> Maker)
    clusterManager = cmanager.ClusterManager<DiaryClusterItem>(
      clusterItems,
      updateMarkers,
      levels: [1, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 20.0], //줌 레벨 설정
      markerBuilder: markerBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: curPos,
          zoom: 10,
        ), //지도 초기 위치 및 줌 레벨 설정
        onMapCreated: (controller) async {
          mapController = controller;
          if (!mounted) return;
          clusterManager.setMapId(controller.mapId); //클러스터 매니저에 맵 ID 설정
          clusterManager.updateMap(); //맵 업데이트
        },
        markers: diarymarkers,
        onCameraMove: clusterManager.onCameraMove,
        onCameraIdle: clusterManager.updateMap,
      ),
    );
  }
}
