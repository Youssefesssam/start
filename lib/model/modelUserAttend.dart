class User {
  late String name;
  late var id ;
  late int seenWord;
  late int pons;
  late int winVoting;
  late int solTaskoo;
  late int rank;


  User({required this.name,required this.id,
    this.seenWord = 0,
    this.pons = 0,
    this.winVoting = 0,
    this.solTaskoo = 0,
    this.rank = 0,
  });

  // تحويل من JSON إلى كائن User
  User.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    id =json["id"] ;
    seenWord : json ['seenWord'] ?? 0;
    pons : json["pons"] ?? 0;
    solTaskoo :json ["solTaskoo"] ?? 0;
    rank : json["rank"] ?? 0;

  }

  // تحويل من كائن User إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id' :id,
      'seenWord':seenWord,
      'pons':pons,
      'solTaskoo':solTaskoo,
      'rank':rank
    };
  }
}
