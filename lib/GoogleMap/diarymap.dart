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
import 'package:flutter_dotenv/flutter_dotenv.dart';

typedef SetLocationCallback =
    void Function(String location, double lat, double lng);

class DiaryMap extends StatefulWidget {
  final List<DiaryModel>? diaryList;
  final bool isFromWrite; //검색에서 넘어온 경우
  final SetLocationCallback? getLocationData;
  const DiaryMap({
    super.key,
    this.diaryList,
    required this.isFromWrite,
    this.getLocationData,
  });

  @override
  State<DiaryMap> createState() => _DiaryMapState();
}

class _DiaryMapState extends State<DiaryMap> {
  static final String googlePlacesApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';

  late bool mode = widget.isFromWrite; //위젯이 쓰기 모드인지 여부
  late GoogleMapController mapController;
  //일기용 데이터
  double diaryLat = 37.5665;
  double diaryLng = 126.9780;
  String curAddress = "부산 어디구 강호동";
  //카메라용 데이터
  late LatLng curCamPos = LatLng(37.5665, 126.9780);
  late double curZoom = mode ? 15 : 11; //초기 줌 레벨

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
      //showToastMessage("현재 위치: ${position.latitude}, ${position.longitude}");
      curCamPos = LatLng(position.latitude, position.longitude);
      setState(() {});
      moveCamera(curCamPos);
    } catch (e) {
      //showToastMessage("현재 위치를 가져오는 중 오류 발생: $e");
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
    // mapPlaces 인스턴스가 null이거나 입력값이 비어있으면 아무것도 하지 않고 예측 리스트 비우기
    if (mapPlaces == null || input.isEmpty) {
      setState(() {
        placePredictions.clear(); //기존 예측 리스트 비우기
      });
      return;
    }

    try {
      // Google Places API의 autocomplete 메서드 호출
      //'language: 'ko''를 추가하여 한국어 결과를 선호하도록 설정
      PlacesAutocompleteResponse response = await mapPlaces!.autocomplete(
        input,
        language: 'ko',
      );

      //응답이 성공적이면 예측 결과를 업데이트
      if (response.isOkay) {
        setState(() {
          placePredictions.clear(); //기존 예측 리스트 비우고
          placePredictions.addAll(response.predictions); //새로운 예측 결과 추가
        });
      } else {
        setState(() {
          placePredictions.clear(); // 오류 시 예측 리스트 비우기
        });
      }
    } catch (e) {
      // 네트워크 오류 등 예외 발생 시 처리
      //showToastMessage("검색 중 오류 발생: $e");
      setState(() {
        placePredictions.clear();
      });
    }
  }

  //카메라 이동
  void moveCamera(LatLng position) {
    if (!mounted) return;
    if (!mode) {
      curZoom = 15;
    } else {
      if (curZoom < 17) {
        curZoom = 17; //줌 레벨을 17로 설정
      }
    }
    mapController.animateCamera(CameraUpdate.newLatLngZoom(position, curZoom));
  }

  Future<void> _displayPrediction(Prediction p) async {
    if (p.placeId == null || mapPlaces == null) {
      showToastMessage("선택된 장소의 ID가 없거나 API 클라이언트가 초기화되지 않았습니다.");
      return;
    }

    try {
      PlacesDetailsResponse detail = await mapPlaces!.getDetailsByPlaceId(
        p.placeId!,
      );
      if (detail.isOkay && detail.result.geometry != null) {
        final lat = detail.result.geometry!.location.lat;
        final lng = detail.result.geometry!.location.lng;
        final newPos = LatLng(lat, lng);
        final addressDescription = p.description ?? "주소 없음";

        setState(() {
          curCamPos = newPos;
          searchedLocationMarker = Marker(
            markerId: MarkerId(p.placeId!), //placeId를 MarkerId로 사용
            position: newPos,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange,
            ),
            infoWindow: InfoWindow(
              title: addressDescription,
              snippet:
                  '위도: ${lat.toStringAsFixed(4)}, 경도: ${lng.toStringAsFixed(4)}',
            ),
          );
          placePredictions.clear(); //검색 결과 리스트 초기화
          searchController.text = addressDescription;
          //기존 마커 제거
          diarymarkers.clear();
          //새로운 마커(선택한 위치) 마커 추가
          diarymarkers.add(searchedLocationMarker!);
        });

        //지도 카메라 이동
        moveCamera(curCamPos);

        //Toast 메시지로 주소 값 확인
        curAddress = addressDescription; //현재 주소 업데이트
        /*showToastMessage(
          "선택된 장소: $addressDescription\n좌표: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}",
        );*/
      } else {
        showToastMessage(
          "장소 상세 정보 로딩 오류: ${detail.errorMessage ?? '알 수 없는 오류'}",
        );
      }
    } catch (e) {
      showToastMessage("장소 상세 정보 가져오는 중 오류 발생: $e");
    }
  }

  void exitMap() {
    //선택된 위치 정보를 상위 위젯으로 전달
    widget.getLocationData?.call(
      curAddress,
      curCamPos.latitude,
      curCamPos.longitude,
    );
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    //현재 위치 값 가져오기
    setCurrentLocation();

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
    if (mode) {
      mapPlaces = GoogleMapsPlaces(apiKey: googlePlacesApiKey);
    }
  }

  Set<Marker> getMapMarkers() {
    if (mode) {
      //isFromWrite 모드일 때의 마커 로직
      if (searchedLocationMarker != null) {
        //검색된 마커가 있을 경우 (주황색 마커)
        return {searchedLocationMarker!};
      } else {
        //검색된 마커가 없을 경우 (지도 탭 또는 현재 위치 버튼 클릭 시의 파란색 마커)
        return {
          Marker(
            markerId: const MarkerId('current_or_tapped_location'),
            position: curCamPos,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
            infoWindow: InfoWindow(
              title: '선택된 위치',
              snippet:
                  '위도: ${curCamPos.latitude.toStringAsFixed(4)}, 경도: ${curCamPos.longitude.toStringAsFixed(4)}',
            ),
          ),
        };
      }
    } else {
      //isFromWrite가 아닐 때의 마커 로직(달력 marker)
      return diarymarkers;
    }
  }

  void onClickedSearchButton() {
    //mapController.animateCamera(CameraUpdate.newLatLngZoom(curPos, 15));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          mode
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
                      _displayPrediction(prediction);
                    },
                  );
                },
              ),
            ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: curCamPos,
                zoom: curZoom,
              ), //지도 초기 위치 및 줌 레벨 설정
              onMapCreated: (controller) async {
                mapController = controller;
                if (!mounted) return;
                if (!mode) {
                  clusterManager.setMapId(controller.mapId); //클러스터 매니저에 맵 ID 설정
                  clusterManager.updateMap(); //맵 업데이트
                }
              },
              markers: getMapMarkers(),
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
          mode
              ? SizedBox(
                child: ElevatedButton(onPressed: exitMap, child: Text("선택")),
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
