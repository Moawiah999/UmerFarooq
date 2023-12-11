import 'package:cloud_firestore/cloud_firestore.dart';

class SendNoteModel {
  final String note;
  final String date;
  final String senderName;
  final String projectID;
  final String senderID;
  final String? id;

  SendNoteModel({
    required this.note,
    required this.date,
    required this.senderName,
    required this.projectID,
    required this.senderID,
    this.id

  });

  SendNoteModel.fromJson(QueryDocumentSnapshot<Object?>  json)
      : this (
    note :json['note'] as String,
    date : json['date'] as String,
    senderName : json['senderName'] as String,
    projectID : json['projectID'] as String,
    senderID : json['senderID'] as String,
    id: json.id

  );

  Map<String, dynamic> toJson() {
    return {
      "note": note,
      "date": date,
      "senderName": senderName,
      "projectID": projectID,
      "senderID": senderID,
    };
  }
}
