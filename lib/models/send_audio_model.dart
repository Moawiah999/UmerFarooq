import 'package:cloud_firestore/cloud_firestore.dart';

class SendAudioModel {
  final String audioUrl;
  final String date;
  final String senderName;
  final String projectID;
  final String senderID;
  final String? id;


  SendAudioModel({
    required this.audioUrl,
    required this.date,
    required this.senderName,
    required this.projectID,
    required this.senderID,
    this.id

  });

  SendAudioModel.fromJson(QueryDocumentSnapshot<Object?>  json)
      : this (
    audioUrl :json['audioUrl'] as String,
    date : json['date'] as String,
    senderName : json['senderName'] as String,
    projectID : json['projectID'] as String,
    senderID : json['senderID'] as String,
    id: json.id

  );

  Map<String, dynamic> toJson() {
    return {
      "audioUrl": audioUrl,
      "date": date,
      "senderName": senderName,
      "projectID": projectID,
      "senderID": senderID,
    };
  }
}
