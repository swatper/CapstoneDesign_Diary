import 'package:flutter/material.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:capstone_diary/GoogleMap/diaryclusteritem.dart';
import 'package:capstone_diary/GoogleMap/custommarkergenerator.dart';
import 'package:capstone_diary/Utils/toastmessage.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart'
    as cmanager;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_maps_webservices/places.dart';

class DiaryMap extends StatefulWidget {
  final List<DiaryModel>? diaryList;
  final bool isFromWrite; //검색에서 넘어온 경우
  const DiaryMap({super.key, this.diaryList, required this.isFromWrite});

  @override
  State<DiaryMap> createState() => _DiaryMapState();
}

class _DiaryMapState extends State<DiaryMap> {
  late GoogleMapController mapController;
  //초기 위도 경도(서울 기준)
  double curLat = 37.5665;
  double curLng = 126.9780;
  late LatLng curPos = LatLng(37.5665, 126.9780);
  late double curZoom = widget.isFromWrite ? 15 : 11; //초기 줌 레벨

  final TextEditingController searchController = TextEditingController();
  GoogleMapsPlaces? mapPlaces;
  final List<Prediction> placePredictions = [];
  Marker? searchedLocationMarker;

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

  //장소 검색 자동 완성 기능을 처리하는 메서드
  Future<void> autoCompleteSearch(String input) async {
    // mapPlaces 인스턴스가 null이거나 입력값이 비어있으면 아무것도 하지 않고 예측 리스트를 비웁니다.
    if (mapPlaces == null || input.isEmpty) {
      setState(() {
        placePredictions.clear(); // 기존 예측 리스트 비우기
      });
      return;
    }

    try {
      // Google Places API의 autocomplete 메서드 호출
      // 'language: 'ko''를 추가하여 한국어 결과를 선호하도록 설정할 수 있습니다.
      PlacesAutocompleteResponse response = await mapPlaces!.autocomplete(
        input,
        language: 'ko',
      );

      // 응답이 성공적이면 예측 결과를 업데이트합니다.
      if (response.isOkay) {
        setState(() {
          placePredictions.clear(); // 기존 예측 리스트 비우고
          placePredictions.addAll(response.predictions); // 새로운 예측 결과 추가
        });
      } else {
        // 오류 발생 시 토스트 메시지 표시
        showToastMessage("검색 자동 완성 오류: ${response.errorMessage}");
        setState(() {
          placePredictions.clear(); // 오류 시 예측 리스트 비우기
        });
      }
    } catch (e) {
      // 네트워크 오류 등 예외 발생 시 처리
      showToastMessage("검색 중 오류 발생: $e");
      setState(() {
        placePredictions.clear();
      });
    }
  }

  //카메라 이동
  void moveCamera(LatLng position) {
    if (!mounted) return;
    if (curZoom < 17) {
      curZoom = 17; //줌 레벨을 17로 설정
    }
    mapController.animateCamera(CameraUpdate.newLatLngZoom(position, curZoom));
  }

  @override
  void initState() {
    super.initState();
    //현재 위치 값 가져오기
    //setCurrentLocation();

    //클러스터 생성 및 초기화 (DirayModel -> DiaryClusterItem)
    List<DiaryClusterItem> clusterItems = [];
    if (widget.diaryList != null) {
      //일기 목록을 클러스터 아이템으로 변환
      clusterItems =
          widget.diaryList!.map((diary) => DiaryClusterItem(diary)).toList();
    }

    //클러스터 매니저 초기화 (DiaryClustyerItem -> Maker)
    clusterManager = cmanager.ClusterManager<DiaryClusterItem>(
      clusterItems,
      updateMarkers,
      levels: [1, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 20.0], //줌 레벨 설정
      markerBuilder: markerBuilder,
    );
    if (widget.isFromWrite) {
      mapPlaces = GoogleMapsPlaces(apiKey: "구글API키");
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void onClickedSearchButton() {
    //mapController.animateCamera(CameraUpdate.newLatLngZoom(curPos, 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          widget.isFromWrite
              ? TextField(
                onChanged: autoCompleteSearch,
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "검색하려는 위치를 입력하세요",
                  prefixIcon: SizedBox.shrink(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Color(0xFFFC8650),
                      size: 40,
                    ),
                    onPressed: onClickedSearchButton,
                  ),
                ),
              )
              : SizedBox.shrink(),
          if (placePredictions.isNotEmpty)
            SizedBox(
              // ListView의 높이를 적절히 조절 (최대 높이 200)
              height:
                  placePredictions.length * 50.0 > 200
                      ? 200
                      : placePredictions.length * 50.0,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: placePredictions.length,
                itemBuilder: (context, index) {
                  final prediction = placePredictions[index];
                  return ListTile(
                    title: Text(prediction.description ?? ''),
                    onTap: () {
                      //_displayPrediction(prediction);
                    },
                  );
                },
              ),
            ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: curPos,
                zoom: curZoom,
              ), //지도 초기 위치 및 줌 레벨 설정
              onMapCreated: (controller) async {
                mapController = controller;
                if (!mounted) return;
                clusterManager.setMapId(controller.mapId); //클러스터 매니저에 맵 ID 설정
                clusterManager.updateMap(); //맵 업데이트
              },
              markers: diarymarkers,
              onCameraMove:
                  (CameraPosition position) => {
                    setState(() {
                      curZoom = position.zoom; //현재 줌 레벨 업데이트
                    }),
                    clusterManager.onCameraMove,
                  },
              onCameraIdle: clusterManager.updateMap,
              onTap: moveCamera,
            ),
          ),
          widget.isFromWrite
              ? SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("선택"),
                ),
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
