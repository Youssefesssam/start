class ModelInfoUser {
  static const String collection = 'data';
  late int score;
  late int massScore;
  late int communionScore;
  late int confessionScore;
  late int meetingScore;

  ModelInfoUser({
    required this.score,
    required this.massScore,
    required this.communionScore,
    required this.confessionScore,
    required this.meetingScore,
  });

  ModelInfoUser.fromJson(Map<String, dynamic> json) {
    score = json["score"] as int;
    massScore = json["massScore"] as int;
    communionScore = json["communionScore"] as int;
    confessionScore = json["confessionScore"] as int;
    meetingScore = json["meetingScore"] as int;
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
