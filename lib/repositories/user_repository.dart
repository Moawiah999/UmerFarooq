import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_management/models/user_model.dart';

class UserRepository{

  Future<void> createUser(UserModel userModel) async {

    await FirebaseAuth.instance.
    createUserWithEmailAndPassword(
        email: userModel.email,
      password: userModel.password
    ).then((value) async {
      await FirebaseFirestore.instance.collection("users").doc(value.user!.uid).set(
          userModel.toJson()
      );
    });
  }

  Future<void> userLogin(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    );

  }

  Future<UserModel> getUserData(String email) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection("users").where('email', isEqualTo: email).get();

    return UserModel.fromJson(querySnapshot.docs.elementAt(0));
  }

  Future<void> updateUser(UserModel userModel,String docId) async {

      await FirebaseFirestore.instance.collection("users").doc(docId).set(
          userModel.toJson()
      );

  }

}