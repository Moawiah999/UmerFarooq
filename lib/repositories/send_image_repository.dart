import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management/models/send_image_model.dart';

import '../models/project_detail_model.dart';

class ImageRepository{

  Future<void> addImage(SendImageModel sendImageModel) async {
    await FirebaseFirestore.instance.collection("images").doc().set(
        sendImageModel.toJson()
    );
  }
  Future<List<SendImageModel>> retrieveImages(String projectID) async {
    List<SendImageModel> imagesList = [];
    await FirebaseFirestore.instance.collection("images").where("projectID",isEqualTo: projectID).orderBy(FieldPath.documentId).get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        imagesList.add(SendImageModel.fromJson(doc));
      }
    });

    return imagesList;

  }

  Future<void> deleteImage(ProjectDetailModel projectDetailModel) async {

    CollectionReference collection = FirebaseFirestore.instance.collection('images');

    // Query to select documents to delete based on a field's value
    QuerySnapshot snapshot = await collection.where('projectID', isEqualTo: projectDetailModel.id).get();

    // Iterate through the documents and delete each one
    for (var doc in snapshot.docs) {
      collection.doc(doc.id).delete();
    }
  }

  Future<void> deleteImg(String? id) async {
    await FirebaseFirestore.instance.collection("images").doc(id).delete();
  }

}