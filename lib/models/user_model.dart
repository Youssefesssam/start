class UserModel {
  final String id;
  final String userCode;
  final String currentStage;
  final List oldCodes;
  final String governorate;
  final String church;
  final String leaderCode;

  UserModel({
    required this.id,
    required this.userCode,
    required this.currentStage,
    required this.oldCodes,
    required this.governorate,
    required this.church,
    required this.leaderCode,
  });

  factory UserModel.fromMap(String id, Map data) {
    return UserModel(
      id: id,
      userCode: data['user_code'],
      currentStage: data['current_stage'],
      oldCodes: data['old_codes'] ?? [],
      governorate: data['governorate'],
      church: data['church'],
      leaderCode: data['leader_code'],
    );
  }
}