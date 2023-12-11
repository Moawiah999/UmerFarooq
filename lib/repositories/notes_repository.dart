import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management/models/project_detail_model.dart';
import 'package:project_management/models/send_note_model.dart';

class NotesRepository{

  Future<void> addNotes(SendNoteModel sendNoteModel) async {
    await FirebaseFirestore.instance.collection("notes").doc().set(
        sendNoteModel.toJson()
    );
  }
  Future<List<SendNoteModel>> retrieveNotes(String projectID) async {
    List<SendNoteModel> notesList = [];
    await FirebaseFirestore.instance.collection("notes").where("projectID",isEqualTo: projectID).orderBy(FieldPath.documentId).get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        notesList.add(SendNoteModel.fromJson(doc));
      }
    });

    return notesList;

  }

  Future<void> deleteNotes(ProjectDetailModel projectDetailModel) async {

    CollectionReference collection = FirebaseFirestore.instance.collection('notes');

    // Query to select documents to delete based on a field's value
    QuerySnapshot snapshot = await collection.where('projectID', isEqualTo: projectDetailModel.id).get();

    // Iterate through the documents and delete each one
    for (var doc in snapshot.docs) {
      collection.doc(doc.id).delete();
    }
  }

  Future<void> deleteNote(String? id) async {
    await FirebaseFirestore.instance.collection("notes").doc(id).delete();
  }
}