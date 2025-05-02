import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';

class DiaryClusterItem with ClusterItem {
  final DiaryModel diaryModel;

  DiaryClusterItem(this.diaryModel);

  @override
  LatLng get location => LatLng(diaryModel.lat, diaryModel.lng);
  String get id => diaryModel.date; //일기장 날짜를 id로 사용 (추후 변경 필요)
  String get title => diaryModel.title; //일기장 제목을 title로 사용
  DiaryModel get diary => diaryModel; //일기장 모델을 diary로 사용
}
