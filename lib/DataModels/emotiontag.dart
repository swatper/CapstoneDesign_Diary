//감정 통계용 데이터 모델
//직접 파싱해서 안 씀 2025/06/07.
class EmotionTag {
  final int joy; //기쁨
  final int happy; //행복
  final int ecited; //설렘
  final int angry; //화남
  final int depressed; //우울
  final int sad; //슬픔
  final int bored; //지루함
  final int surprise; //놀람
  final int nervous; //불안
  final int shy; //부끄러움

  EmotionTag(
    this.joy,
    this.happy,
    this.ecited,
    this.angry,
    this.depressed,
    this.sad,
    this.bored,
    this.surprise,
    this.nervous,
    this.shy,
  );
}
