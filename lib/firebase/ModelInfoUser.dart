class ModelInfoUser {
  static const String collection = 'data';
  late int count;

  ModelInfoUser({
    required this.count,
  });

  ModelInfoUser.fromJson(Map<String, dynamic> json) {
    count = json["count"] as int;
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
    };
  }
}
