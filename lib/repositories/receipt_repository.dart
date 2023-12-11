import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management/models/send_image_model.dart';
import 'package:project_management/models/send_receipt_model.dart';

import '../models/project_detail_model.dart';

class ReceiptRepository{

  Future<void> addReceipt(SendReceiptModel sendReceiptModel) async {
    await FirebaseFirestore.instance.collection("receipts").doc().set(
        sendReceiptModel.toJson()
    );
  }

  Future<List<SendReceiptModel>> retrieveReceipts(String projectID) async {
    List<SendReceiptModel> receiptList = [];
    await FirebaseFirestore.instance.collection("receipts").where("projectID",isEqualTo: projectID).orderBy(FieldPath.documentId).get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        receiptList.add(SendReceiptModel.fromJson(doc));
      }
    });

    return receiptList;

  }

  Future<void> deleteReceipts(ProjectDetailModel projectDetailModel) async {

    CollectionReference collection = FirebaseFirestore.instance.collection('receipts');

    // Query to select documents to delete based on a field's value
    QuerySnapshot snapshot = await collection.where('projectID', isEqualTo: projectDetailModel.id).get();

    // Iterate through the documents and delete each one
    for (var doc in snapshot.docs) {
      collection.doc(doc.id).delete();
    }
  }
  Future<void> deleteReceipt(String? id) async {
    await FirebaseFirestore.instance.collection("receipts").doc(id).delete();
  }

}