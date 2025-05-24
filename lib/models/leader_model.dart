class LeaderModel {
  final String code;
  final String name;
  final String governorate;
  final String church;
  final String stage; // P / S / U
  final String role; // master_leader / sub_leader
  final String email;
  final String specialty; // ← مثل: "كورال"، "مسرح"، "عام"

  LeaderModel({
    required this.code,
    required this.name,
    required this.governorate,
    required this.church,
    required this.stage,
    required this.role,
    required this.email,
    required this.specialty,
  });

  factory LeaderModel.fromMap(Map<String, dynamic> data) {
    return LeaderModel(
      code: data['code'],
      name: data['name'],
      governorate: data['governorate'],
      church: data['church'],
      stage: data['stage'],
      role: data['role'],
      email: data['email'],
      specialty: data['specialty'] ?? 'عام',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'governorate': governorate,
      'church': church,
      'stage': stage,
      'role': role,
      'email': email,
      'specialty': specialty,
    };
  }
}