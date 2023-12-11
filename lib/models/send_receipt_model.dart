import 'package:cloud_firestore/cloud_firestore.dart';

class SendReceiptModel {
  final String receiptLink;
  final String date;
  final String senderName;
  final String projectID;
  final String senderID;
  final String? id;


  SendReceiptModel({
    required this.receiptLink,
    required this.date,
    required this.senderName,
    required this.projectID,
    required this.senderID,
    this.id

  });

  SendReceiptModel.fromJson(QueryDocumentSnapshot<Object?>  json)
      : this (
    receiptLink :json['receiptLink'] as String,
    date : json['date'] as String,
    senderName : json['senderName'] as String,
    projectID : json['projectID'] as String,
    senderID : json['senderID'] as String,
    id: json.id

  );

  Map<String, dynamic> toJson() {
    return {
      "receiptLink": receiptLink,
      "date": date,
      "senderName": senderName,
      "projectID": projectID,
      "senderID": senderID,
    };
  }
}
