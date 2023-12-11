import 'package:cloud_firestore/cloud_firestore.dart';

class SendDocModel {
  final String docUrl;
  final String date;
  final String senderName;
  final String projectID;
  final String senderID;
  final String? id;


  SendDocModel({
    required this.docUrl,
    required this.date,
    required this.senderName,
    required this.projectID,
    required this.senderID,
    this.id

  });

  SendDocModel.fromJson(QueryDocumentSnapshot<Object?>  json)
      : this (
    docUrl :json['docUrl'] as String,
    date : json['date'] as String,
    senderName : json['senderName'] as String,
    projectID : json['projectID'] as String,
    senderID : json['senderID'] as String,
    id: json.id

  );

  Map<String, dynamic> toJson() {
    return {
      "docUrl": docUrl,
      "date": date,
      "senderName": senderName,
      "projectID": projectID,
      "senderID": senderID,
    };
  }
}
