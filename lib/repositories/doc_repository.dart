import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management/models/send_audio_model.dart';
import 'package:project_management/models/send_doc_model.dart';

import '../models/project_detail_model.dart';

class DocRepository{

  Future<void> addDoc(SendDocModel sendDocModel) async {
    await FirebaseFirestore.instance.collection("docs").doc().set(
        sendDocModel.toJson()
    );
  }

  Future<List<SendDocModel>> retrieveDocs(String projectID) async {
    List<SendDocModel> docList = [];
    await FirebaseFirestore.instance.collection("docs").where("projectID",isEqualTo: projectID).orderBy(FieldPath.documentId).get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        docList.add(SendDocModel.fromJson(doc));
      }
    });

    return docList;

  }

  Future<void> deleteDocs(ProjectDetailModel projectDetailModel) async {

    CollectionReference collection = FirebaseFirestore.instance.collection('docs');

    // Query to select documents to delete based on a field's value
    QuerySnapshot snapshot = await collection.where('projectID', isEqualTo: projectDetailModel.id).get();

    // Iterate through the documents and delete each one
    for (var doc in snapshot.docs) {
      collection.doc(doc.id).delete();
    }
  }

  Future<void> deleteDoc(String? id) async {
    await FirebaseFirestore.instance.collection("docs").doc(id).delete();
  }

}