import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management/models/send_audio_model.dart';

import '../models/project_detail_model.dart';

class AudioRepository{

  Future<void> addAudio(SendAudioModel sendAudioModel) async {
    await FirebaseFirestore.instance.collection("audios").doc().set(
        sendAudioModel.toJson()
    );
  }

  Future<List<SendAudioModel>> retrieveAudios(String projectID) async {
    List<SendAudioModel> audioList = [];
    await FirebaseFirestore.instance.collection("audios").where("projectID",isEqualTo: projectID).orderBy(FieldPath.documentId).get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        audioList.add(SendAudioModel.fromJson(doc));
      }
    });

    return audioList;

  }

  Future<void> deleteAudios(ProjectDetailModel projectDetailModel) async {

    CollectionReference collection = FirebaseFirestore.instance.collection('audios');

    // Query to select documents to delete based on a field's value
    QuerySnapshot snapshot = await collection.where('projectID', isEqualTo: projectDetailModel.id).get();

    // Iterate through the documents and delete each one
    for (var doc in snapshot.docs) {
      collection.doc(doc.id).delete();
    }
  }

  Future<void> deleteAudio(String? id) async {
    await FirebaseFirestore.instance.collection("audios").doc(id).delete();
  }

}