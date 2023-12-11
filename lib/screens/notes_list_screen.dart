import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:project_management/models/project_detail_model.dart';
import 'package:project_management/models/send_note_model.dart';
import 'package:project_management/models/user_model.dart';
import 'package:project_management/repositories/notes_repository.dart';
import 'package:project_management/repositories/user_repository.dart';

import '../supporting_widgets/showErrorPopup.dart';
import 'launch_urls_class.dart';



class NotesListScreen extends StatefulWidget {
  final ProjectDetailModel projectDetailModel;
  final String link;

  const NotesListScreen({super.key, required this.projectDetailModel, required this.link});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  String userName = "";
  List<SendNoteModel> notesList = [];
  bool loading = false;
  Future<void> getNotes()async {
    try{
      setState(() {
        loading = true;
      });

      notesList.clear();
      UserRepository userRepository = UserRepository();
      UserModel userModel = await userRepository.getUserData(currentUser?.email.toString()??"");
      userName = userModel.userName;
      NotesRepository notesRepository = NotesRepository();
      notesList = await notesRepository.retrieveNotes(widget.projectDetailModel.id.toString());

      setState(() {
        userName;
        notesList;
        loading = false;
      });


    }catch(e){
      setState(() {
        loading=false;
      });
      // ignore: use_build_context_synchronously
      showErrorPopUp(context, e.toString().contains("network")?"Check your Internet":"Something Went Wrong");
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes List"),
      ),
      body: loading?Center(child: CircularProgressIndicator(color: Colors.amber.shade900,),):
      notesList.isEmpty?const Center(child: Text("no record"),):
      ListView.builder(
        itemCount: notesList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: Text("Sent by: ${notesList[index].senderName}",style: const TextStyle(fontSize: 12)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Text(notesList[index].note),
                    const SizedBox(height: 10,),
                    Text(notesList[index].date,style: const TextStyle(fontSize: 8),),

                  ],

                ),
                trailing:currentUser?.email!="admin@gmail.com"?Container(): IconButton(
                  onPressed: (){
                    deletePopup(notesList[index].id??"");
                  },
                  icon: Icon(Icons.delete,color: Colors.red,),
                ),
              ),
            ),
          );
        },
      ),

      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // Add your onPressed code here!
      //     addNotePopUp();
      //   },
      //   label: const Text('Add Note',style: TextStyle(color: Colors.white),),
      //   icon: const Icon(Icons.note,color: Colors.white,),
      //   backgroundColor: Colors.amber.shade900,
      // ),

        floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            widget.link.isEmpty?Container():
            Container(
              margin: EdgeInsets.only(left: 30),
              child: TextButton.icon(
                onPressed: () async {
                  UrlLauncherClass urlLauncherClass = UrlLauncherClass();
                  await urlLauncherClass.doLaunchUrl(widget.link);
                },
                icon: Icon(Icons.drive_folder_upload_outlined,color: Colors.amber.shade900),
                label: const Text("Open dropbox"),
              ),
            ),
            TextButton.icon(
                onPressed: () async {
                  addNotePopUp();
                },
                icon: Icon(Icons.receipt,color: Colors.amber.shade900),
                label: const Text("Send Note")),

          ],
        ),




    );
  }

  Future addNotePopUp(){
    return showDialog(
      context: context,
      builder: (context) {
        TextEditingController textController = TextEditingController();
        return AlertDialog(
          title: const Text('Enter Note'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Type text',
            ),
            maxLines: null,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                if(textController.text.isNotEmpty){
                  Navigator.of(context).pop();
                  sendNote(textController.text);
                }

              },
            ),
          ],
        );
      },
    );
  }

  Future sendNote(String noteText) async {
    try{
      setState(() {
        loading = true;
      });

      NotesRepository notesRepository = NotesRepository();
      await notesRepository.addNotes(
          SendNoteModel(
              note: noteText,
              date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
              senderName: userName,
              projectID: widget.projectDetailModel.id.toString(),
              senderID: userId
          )
      ).then((value) {
        getNotes();
      });


    }catch(e){
      setState(() {
        loading=false;
      });
      // ignore: use_build_context_synchronously
      showErrorPopUp(context, e.toString().contains("network")?"Check your Internet":"Something Went Wrong");
    }
  }

  Future deletePopup(String id){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () async {
                try{
                  setState(() {
                    loading = true;
                  });
                  Navigator.of(context).pop();
                  NotesRepository noteRep = NotesRepository();
                  await noteRep.deleteNote(id);
                  getNotes();
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


}
