import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userName;
  final String email;
  final String password;
  final String userType;
  final List newMessageSender;
  final int timeStamp;
  final String? userID;


  UserModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.userType,
    required this.newMessageSender,
    required this.timeStamp,
    this.userID

  });

  UserModel.fromJson(QueryDocumentSnapshot<Object?>  json)
      : this (
      userName :json['userName'] as String,
      email : json['email'] as String,
      password : json['password'] as String,
      userType : json['userType'] as String,
      newMessageSender : json['newMessageSender'] as List<dynamic>,
      timeStamp : json['timeStamp'] as int,
      userID : json.id,

  );

  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "email": email,
      "password": password,
      "userType": userType,
      "newMessageSender": newMessageSender,
      "timeStamp": timeStamp,
    };
  }
}
