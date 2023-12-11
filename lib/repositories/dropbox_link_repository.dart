import 'package:cloud_firestore/cloud_firestore.dart';

class DropboxLinkRepository{

  Future<void> putLink(String projectId,String link,String linkId) async {

      await FirebaseFirestore.instance.collection(projectId).doc(linkId).set(
          {"link":link}
      );

  }

  Future<List<String>> getLink(String projectId) async {
    List<String> linksList = [];
    String data = '';

    for (int i = 0; i < 6; i++) {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await FirebaseFirestore.instance.collection(projectId).doc(i.toString()).get();
      if(documentSnapshot.exists){
        linksList.add(documentSnapshot["link"]);
      }else{
        linksList.add(data);
      }
    }

    return linksList;
  }


}
