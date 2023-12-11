import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectDetailModel {
  final String projectName;
  final String address;
  final String tenantName;
  final String tenantPhone;
  final String emergencyPersonName;
  final String emergencyPersonPhone;
  final String emergencyDetail;
  final String lockBoxCode;
  final String? id;

  ProjectDetailModel({
    required this.projectName,
    required this.address,
    required this.tenantName,
    required this.tenantPhone,
    required this.emergencyPersonName,
    required this.emergencyPersonPhone,
    required this.emergencyDetail,
    required this.lockBoxCode,
    this.id,
  });

  // Constructor to create an instance from JSON
  ProjectDetailModel.fromJson(QueryDocumentSnapshot<Object?>  json)
      : projectName = json['projectName'] as String,
        address = json['address'] as String,
        tenantName = json['tenantName'] as String,
        tenantPhone = json['tenantPhone'] as String,
        emergencyPersonName = json['emergencyPersonName'] as String,
        emergencyPersonPhone = json['emergencyPersonPhone'] as String,
        emergencyDetail = json['emergencyDetail'] as String,
        lockBoxCode = json['lockBoxCode'] as String,
        id = json.id;

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "projectName": projectName,
      "address": address,
      "tenantName": tenantName,
      "tenantPhone": tenantPhone,
      "emergencyPersonName": emergencyPersonName,
      "emergencyPersonPhone": emergencyPersonPhone,
      "emergencyDetail": emergencyDetail,
      "lockBoxCode": lockBoxCode,
      "id": id,
    };
  }
}

