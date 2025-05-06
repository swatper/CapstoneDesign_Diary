import 'package:flutter/material.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';
//import 'package:capstone_diary/ArchiveWindow/diaryclusteritem.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DiaryMap extends StatefulWidget {
  //final List<DiaryModel> diaryList;
  const DiaryMap({super.key /*, required this.diaryList*/});

  @override
  _DiaryMapState createState() => _DiaryMapState();
}

class _DiaryMapState extends State<DiaryMap> {
  late GoogleMapController? mapController;
  /*
  late cluManager.ClusterManager<DiaryClusterItem> clusterManager; //클러스터 매니저
  Set<Marker> diarymarkers = {}; //마커를 저장할 Set
  */
  static const LatLng initialPos = LatLng(37.5665, 126.9780); // 서울

  /*
  //클러스터를 마커로 변환
  void updateMarkers(Set<Marker> markers) {
    setState(() {
      diarymarkers = markers;
    });
  }

  Future<Marker> markerBuilder(
    cluManager.Cluster<DiaryClusterItem> cluster,
  ) async {
    if (cluster.isMultiple) {
      return Marker(
        markerId: MarkerId(cluster.getId()),
        position: cluster.location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: '${cluster.count}'),
      );
    } else {
      final diary = cluster.items.first.diaryModel;
      return Marker(
        markerId: MarkerId(diary.date),
        position: LatLng(diary.lat, diary.lng),
        infoWindow: InfoWindow(title: '1'),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    //클러스터 생성 및 초기화 (DirayModel -> DiaryClusterItem)
    List<DiaryClusterItem> clusterItems =
        widget.diaryList
            .map((diary) => DiaryClusterItem(diary))
            .toList(); //일기 목록을 클러스터 아이템으로 변환

    //클러스터 매니저 초기화 (DiaryClustyerItem -> Maker)
    clusterManager = cluManager.ClusterManager<DiaryClusterItem>(
      clusterItems,
      updateMarkers,
      markerBuilder: (diaryCluster) async {
        final DiaryClusterItem clusterItem = diaryCluster as DiaryClusterItem;
        return Marker(
          markerId: MarkerId(clusterItem.diaryModel.date),
          position: clusterItem.location,
          infoWindow: InfoWindow(title: clusterItem.diaryModel.title),
        );
      },
    );
    //현재 위치 값 가져오기
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: initialPos, zoom: 12),
        onMapCreated: (controller) {
          mapController = controller;
        },
        /*
        markers: diarymarkers,
        onCameraMove: clusterManager.onCameraMove,
        onCameraIdle: clusterManager.updateMap,*/
      ),
    );
  }
}
