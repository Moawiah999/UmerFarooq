import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_management/models/user_model.dart';

import 'chat_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messenger'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').orderBy("timeStamp",descending: false).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          List<UserModel> userList = snapshot.data!.docs.map((doc) {
            return UserModel.fromJson(doc);
          }).toList();
          List<UserModel> currentUserModel = userList.where((element) => element.email==currentUser!.email).toList();
          print(currentUserModel[0].email);
          return ListView.builder(
            itemCount: userList.length ?? 0,
            itemBuilder: (context, index) {

              return userList[index].email=="admin@gmail.com" && currentUser!.email=="admin@gmail.com"?
              Container():
              currentUser!.email!="admin@gmail.com" && userList[index].email!="admin@gmail.com"?Container():
              InkWell(
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(userModel: userList[index],currentUserModel: currentUserModel[0]),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(userList[index].userName),
                  subtitle: Text(userList[index].email),
                  trailing: currentUserModel[0].newMessageSender.contains(userList[index].email)?
                      TextButton.icon(
                        onPressed: () {  },
                        label: const Text("Reply*",style: TextStyle(color: Colors.red),),
                        icon: const Icon(Icons.notifications_none,color: Colors.red,),
                      ) :
                  const Icon(Icons.chat),
                ),
              );
            },
          );
        },
      ),
    );
  }

  final User? currentUser = FirebaseAuth.instance.currentUser;

  final userId = FirebaseAuth.instance.currentUser!.uid;

  // bool newMessageIndication(UserModel userModel , UserModel currentUserModel){
  //   bool newMsg = false;
  //   for (var element in userModel.newMessageSender) {
  //     if(element.toString() == currentUser!.email){
  //       newMsg = true;
  //     }
  //   }
  //   return newMsg;
  // }
}




