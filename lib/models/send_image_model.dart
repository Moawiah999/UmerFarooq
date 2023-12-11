import 'package:cloud_firestore/cloud_firestore.dart';

class SendImageModel {
  final String imageLink;
  final String date;
  final String senderName;
  final String projectID;
  final String senderID;
  final String? id;


  SendImageModel({
    required this.imageLink,
    required this.date,
    required this.senderName,
    required this.projectID,
    required this.senderID,
    this.id

  });

  SendImageModel.fromJson(QueryDocumentSnapshot<Object?>  json)
      : this (
    imageLink :json['imageLink'] as String,
    date : json['date'] as String,
    senderName : json['senderName'] as String,
    projectID : json['projectID'] as String,
    senderID : json['senderID'] as String,
    id: json.id

  );

  Map<String, dynamic> toJson() {
    return {
      "imageLink": imageLink,
      "date": date,
      "senderName": senderName,
      "projectID": projectID,
      "senderID": senderID,
    };
  }
}
