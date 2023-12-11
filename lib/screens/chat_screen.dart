
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:project_management/core/core_colors.dart';
import 'package:project_management/models/user_model.dart';
import 'package:project_management/repositories/user_repository.dart';
import 'package:project_management/screens/video_player_Screen.dart';

import '../supporting_widgets/showErrorPopup.dart';
import 'launch_urls_class.dart';

class ChatScreen extends StatefulWidget {
  final UserModel userModel;
  final UserModel currentUserModel;
  const ChatScreen({super.key, required this.userModel, required this.currentUserModel});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final ScrollController _scrollController = ScrollController();
  double currentScrollOffset = 0.0;
  bool initialScrollDone = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> messages = [];
  Future<void> _sendMessage(String message, File? file,String? name, Uint8List? data) async {
    if (message.isEmpty && data == null && file==null) {
      return;
    }

    setState(() {
      loading = true;
    });

    try{
      // Upload file to Firebase Storage
      String? fileUrl;

      if (data != null) {
        Reference storageRef =
        _storage.ref().child('files/${DateTime.now().microsecondsSinceEpoch}$name');
        UploadTask uploadTask = storageRef.putData(data);
        await uploadTask.whenComplete(() async {
          fileUrl = await storageRef.getDownloadURL();
        });
      }else{

        if (file != null) {
          Reference storageRef =
          _storage.ref().child('files/${DateTime.now().microsecondsSinceEpoch}$name');
          UploadTask uploadTask = storageRef.putFile(file);
          await uploadTask.whenComplete(() async {
            fileUrl = await storageRef.getDownloadURL();
          });
        }

      }

      // Add message to Firestore
      await _firestore.collection('chat').doc(currentUser!.email!="admin@gmail.com"?currentUser!.email!:widget.userModel.email).collection("messages").add({
        'text': message,
        'fileUrl': fileUrl,
        'senderEmail': currentUser!.email, // Set the sender email accordingly
        'timestamp': DateTime.now().microsecondsSinceEpoch,
        'senLen': messages.isEmpty?0:messages.length,
        'recLen': messages.isEmpty?0: messages[messages.length-1]["senderEmail"]==currentUser!.email?messages[messages.length-1]["recLen"]??1:messages.length
      });

      _messageController.clear();

      // if(!msgNotifyChecked){
        await addMsgNotify();
        await removeMsgNotify();
      // }
      msgNotifyChecked = true;
      setState(() {
        loading = false;
      });
    }catch(e){
      // ignore: use_build_context_synchronously
      showErrorPopUp(context,e.toString().contains("network")?"Check your Internet":"Something Went Wrong" );
      setState(() {
        loading = false;
      });
    }

    if (initialScrollDone) {
      // Scroll to the bottom after the list is built
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent+100);
      initialScrollDone = true;
    }

  }



  String _getFileTypeName(String fileUrl) {
    if (fileUrl.contains('.mp4') || fileUrl.contains('.avi') || fileUrl.contains('VID')) {
      return 'Video';
    } else if (fileUrl.contains('.mp3') || fileUrl.contains('.wav') || fileUrl.contains('AUD') ) {
      return 'Audio';
    } else if (fileUrl.contains('.doc') || fileUrl.contains('.docx')) {
      return 'Document';
    } else {
      // Add more file types as needed
      return 'File';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation'),
        actions: [
          currentUser!.email!="admin@gmail.com"?Container():
          TextButton(
            onPressed: (){
              deletePopup("");
            },
            child: Text("Clear All",style: TextStyle(color: Colors.red.shade900),),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('chat').doc(currentUser!.email!="admin@gmail.com"?currentUser!.email! :widget.userModel.email).collection("messages").orderBy("timestamp").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                int index = 0;
                 messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  index = index+1;
                  final messageText = message['text'];
                  final fileUrl = message['fileUrl'];
                  final senderEmail = message['senderEmail'];

                  // Check if the current user is the admin
                  final isUser = senderEmail == currentUser!.email;

                  // Determine the alignment based on the sender
                  final alignment = isUser ? MainAxisAlignment.end : MainAxisAlignment.start;

                  // Add message text with background color and alignment
                  messageWidgets.add(
                    Column(
                      children: [

                        (messages.length - 1) - (messages[messages.length - 1]["senLen"] - messages[messages.length - 1]["recLen"] )==index-1 && currentUser!.email != message['senderEmail']?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("new messages"),
                            Divider(color: lightBlack,height: 1,),
                          ],
                        )
                    : const SizedBox(),

                        if (fileUrl != null)
                          Row(
                            mainAxisAlignment: alignment,
                            children: [
                              GestureDetector(
                                onLongPress: (){
                                  deletePopup(message.id);
                                },
                                onTap: () {
                                  if(_getFileTypeName(fileUrl)=="Audio" || _getFileTypeName(fileUrl)=="Video"){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context)=> VideoScreen(videoLink: fileUrl,)
                                    ));
                                  }else{
                                    UrlLauncherClass urlLauncherClass = UrlLauncherClass();
                                    urlLauncherClass.doLaunchUrl(fileUrl);
                                  }

                                },
                                child: Container(
                                  width: messageText.toString().length>26?230:null,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 5,bottom: 5,right: 10,left: 10),
                                  margin: const EdgeInsets.only(left: 10,top: 5,right: 10),
                                  decoration: BoxDecoration(
                                    color: lightBlack,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.open_in_browser,color: Colors.white,),
                                      const SizedBox(width: 5,),
                                      Text(
                                        '${_getFileTypeName(fileUrl)}',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ) else
                          Row(
                          mainAxisAlignment: alignment,
                            children: [
                              GestureDetector(
                                onLongPress: (){
                                  if(currentUser!.email!="admin@gmail.com"){
                                    return ;
                                  }else{
                                    deletePopup(message.id);
                                  }
                              },
                                child: Container(
                                  width: messageText.toString().length>26?230:null,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 12,bottom: 12,right: 15,left: 15),
                                  margin: const EdgeInsets.only(left: 10,top: 5,right: 10),
                                  decoration: BoxDecoration(
                                    color: lightBlack,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: const Radius.circular(20),
                                      topRight: Radius.circular(isUser?0:20),
                                      topLeft: Radius.circular(isUser?20:0),
                                      bottomRight: const Radius.circular(20),
                                    )
                                  ),
                                  child: Text(
                                    '$messageText',
                                    style:  const TextStyle(color: Colors.white,),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        messages[messages.length-1].id == message.id?const SizedBox(height: 100,):const SizedBox(height: 0,)

                      ],
                    ),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!initialScrollDone) {
                    // Scroll to the bottom after the list is built
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent+100);
                    initialScrollDone = true;
                  }
                });

                return ListView(
                  controller: _scrollController,
                  children: messageWidgets,
                );
              },
            ),
          ),
          loading?Center(child: Container(margin:const EdgeInsets.all(20),child: CircularProgressIndicator(color: lightBlack,)),):
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.grey.shade400
                      )
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none
                        ),
                        hintText: 'Enter your message...',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () async {
                    FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                        _sendMessage(
                          '',
                          kIsWeb?null:File(result!.files.single.path!),
                          result!.files.single.name,
                            result.files.single.bytes
                        );


                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text, null,null,null);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool loading = false;
  Future deletePopup(String id){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure you want to delete?"),
          actions: [
            TextButton(
              onPressed: () async {
                try{
                  setState(() {
                    loading = true;
                  });

                  Navigator.of(context).pop();

                  if(id.isNotEmpty) {
                    await _firestore.collection('chat').doc(
                        widget.userModel == null ? currentUser!.email : widget
                            .userModel!.email).collection("messages")
                        .doc(id)
                        .delete();
                  }else{

                    QuerySnapshot querySnapshot = await _firestore
                        .collection('chat')
                        .doc(widget.userModel?.email)
                        .collection('messages')
                        .get();

                    WriteBatch batch = _firestore.batch();

                    for (QueryDocumentSnapshot document in querySnapshot.docs) {
                      batch.delete(document.reference);
                    }

                    await batch.commit();

                  }
                  setState(() {
                    loading = false;
                  });
                }catch(e){
                  // ignore: use_build_context_synchronously
                  showErrorPopUp(context,e.toString().contains("network")?"Check your Internet":"Something Went Wrong" );
                  setState(() {
                    loading = false;
                  });
                }

              },
              child: const Text("Delete"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  addMsgNotify() async {
    if(!widget.userModel.newMessageSender.contains(currentUser!.email)){
      List userList = [];
      userList.addAll(widget.userModel.newMessageSender);
      userList.add(currentUser!.email);

      UserRepository userRepository =UserRepository();
      await userRepository.updateUser(
          UserModel(
              userName: widget.userModel.userName,
              email: widget.userModel.email,
              password: widget.userModel.password,
              userType: widget.userModel.userType,
              newMessageSender: userList,
              timeStamp: DateTime.now().microsecondsSinceEpoch
          ),
          widget.userModel.userID??""
      );
    }
  }

  bool msgNotifyChecked = false;
  removeMsgNotify() async {
    if(widget.currentUserModel.newMessageSender.contains(widget.userModel.email)){
      List userList = [];
      userList.addAll(widget.currentUserModel.newMessageSender);
      bool isDone = userList.remove(widget.userModel.email);

      if(isDone){
        UserRepository userRepository =UserRepository();
        await userRepository.updateUser(
            UserModel(
                userName: widget.currentUserModel.userName,
                email: widget.currentUserModel.email,
                password: widget.currentUserModel.password,
                userType: widget.currentUserModel.userType,
                newMessageSender: userList,
                timeStamp: DateTime.now().microsecondsSinceEpoch
            ),
            currentUser!.uid
        );
      }
    }
  }


}

