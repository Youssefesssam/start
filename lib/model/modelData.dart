class ModelData {
  static const String collection = 'data';
  late int score;
  late int massScore;
  late int communionScore;
  late int confessionScore;
  late int meetingScore;

  ModelData({
    required this.score,
    required this.massScore,
    required this.communionScore,
    required this.confessionScore,
    required this.meetingScore
  });

  factory ModelData.fromJson(Map<String, dynamic> data) {
    return ModelData(
      score: data['score'] ?? 0,
      communionScore: data['communionScore'] ?? 0,
      confessionScore: data['confessionScore'] ?? 0,
      massScore: data['massScore'] ?? 0,
      meetingScore: data['meetingScore'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'massScore': massScore,
      'communionScore': communionScore,
      'confessionScore': confessionScore,
      'meetingScore': meetingScore,
    };
  }
}
