import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  static const String collection = 'user';
  late var id ;
  late String name;
  late String email;
  late String address;
  late String phone;
  late String talent;
  late String university;
  late String gender;

  MyUser({

    required this.name,
    required this.id,
    required this.email,
    required this.phone,
    required this.address,
    required this.gender,
    required this.talent,
    required this.university,
  });

  MyUser.fromJson(Map<String, dynamic> json) {

    name =json["name"];
    id =json["id"] ;
    email =json["email"];
    phone =json["phone"];
    address =json["address"];
    gender =json["gender"];
    talent = json["talent"];
    university=json["university"];
  }

  Map<String, dynamic> toJson() {
    return {
      'name' :name,
      'id' :id,
      'email':email,
      'phone' :phone,
      'address':address,
      'gender':gender,
      'talent':talent,
      'university':university
    };
  }
}