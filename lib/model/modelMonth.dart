class ModelMonth{
  static const String collection = 'Month';


  late int TotalScorOfMonth;
  late int m1;//1 2 3 4
  late int m2;//5 6 7 8
  late int m3;//9 10 11 12

  ModelMonth({
    required this.TotalScorOfMonth
  });
  ModelMonth.fromJson(Map<String, dynamic> json) {
    TotalScorOfMonth =json["TotalScorOfMonth"];
  }

  Map<String, dynamic> toJson() {
    return {
      'TotalScorOfMonth' :TotalScorOfMonth,
    };
  }
}