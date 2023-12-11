import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_management/models/send_doc_model.dart';
import 'package:project_management/repositories/doc_repository.dart';
import 'package:project_management/screens/add_project.dart';
import 'package:project_management/screens/launch_urls_class.dart';
import 'package:project_management/screens/read_document.dart';
import 'package:project_management/screens/show_project_detail.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/project_detail_model.dart';
import '../models/send_image_model.dart';
import '../models/user_model.dart';
import '../repositories/project_repository.dart';
import '../repositories/send_image_repository.dart';
import '../repositories/user_repository.dart';
import 'package:file_picker/file_picker.dart';

import '../supporting_widgets/showErrorPopup.dart';
class PlansAndPermitsListScreen extends StatefulWidget {
  final ProjectDetailModel projectDetailModel;
  final String link;
  const PlansAndPermitsListScreen({super.key, required this.projectDetailModel, required this.link});

  @override
  State<PlansAndPermitsListScreen> createState() => _PlansAndPermitsListScreenState();
}

class _PlansAndPermitsListScreenState extends State<PlansAndPermitsListScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  String userName = "";
  List<SendDocModel> docList = [];
  bool loading = false;
  Future<void> getDocs()async {
    try{
      setState(() {
        loading = true;
      });

      docList.clear();
      UserRepository userRepository = UserRepository();
      UserModel userModel = await userRepository.getUserData(currentUser?.email.toString()??"");
      userName = userModel.userName;
      print("name is: $userName");
      DocRepository docRepository = DocRepository();
      docList = await docRepository.retrieveDocs(widget.projectDetailModel.id.toString());

      setState(() {
        userName;
        docList;
        loading=false;
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
    getDocs();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      appBar: AppBar(
        title: const Text('Plans an permits'),
      ),
      body:loading?Center(child: CircularProgressIndicator(color: Colors.amber.shade900,),):docList.isEmpty?const Center(child: Text("no record!!")): ListView.builder(
        itemCount: docList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              // if(docList[index].docUrl.toString().contains(".pdf")){
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             DocumentViewer(documentUrl: docList[index].docUrl)
              //     ),
              //   );
              // }else{}

                UrlLauncherClass urlLauncherClass = UrlLauncherClass();
                await urlLauncherClass.doLaunchUrl(docList[index].docUrl);


            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.amber.shade900, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 80, // Adjust the size as needed
                    height: 80, // Adjust the size as needed
                    child: Image.asset(
                        docList[index].docUrl.contains(".pdf")?
                        "assets/images/pdf_icon.png":
                        docList[index].docUrl.contains(".doc")?
                        "assets/images/word_icon.png":"assets/images/excel_icon.png"
                    ),
                  ),
                  const SizedBox(width: 16.0), // Add some spacing
                   Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Document",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "sent by ${docList[index].senderName}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          docList[index].date,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // You can add more widgets here, such as project descriptions or buttons.
                      ],
                    ),
                  ),
                  currentUser?.email!="admin@gmail.com"?Container(): IconButton(
                    onPressed: (){
                      deletePopup(docList[index].id??"");
                    },
                    icon: Icon(Icons.delete,color: Colors.red,),
                  ),
                ],
              ),
            ),
          );
        },
      ),

    //   floatingActionButton: FloatingActionButton.extended(
    //     onPressed: () async {
    //       // Add your onPressed code here!
    //       await pickDoc();
    //       if(docSelected){
    //         uploadDoc();
    //       }
    //     },
    //     label: const Text('Upload',style: TextStyle(color: Colors.white),),
    //     icon: const Icon(Icons.file_copy,color: Colors.white,),
    //     backgroundColor: Colors.amber.shade900,
    //   ),
    //
    // );
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
              await pickDoc();
              if(docSelected){
                uploadDoc();
              }
            },
            icon: Icon(Icons.attach_file,color: Colors.amber.shade900),
            label: Text("Upload Doc")),

      ],
    )

    );
  }

  FilePickerResult? result;

  File? file;
  bool docSelected = false;

  // Pick an image
  Future pickDoc()async{
    result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx' , 'xls' , 'xlsx']
    );

    if (result != null) {
      file = File(result!.files.single.path!);
      if(await file!.exists()) {
        setState(() {
          file;
          docSelected = true;
        });
      }
    }

  }

  uploadDoc() async {

    try{
      setState(() {
        loading = true;
      });

      await FirebaseStorage.instance.ref("docs/${result!.files.single.name}").putFile(file!).then((p) async {
        String url = await FirebaseStorage.instance.ref("docs/${result!.files.single.name}").getDownloadURL();

        DocRepository docRepository = DocRepository();
        await docRepository.addDoc(
            SendDocModel(
              docUrl: url,
              date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
              senderName: userName,
              projectID: widget.projectDetailModel.id.toString(),
              senderID: userId,
            )
        ).then((value) {
          getDocs();
        });

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
                  DocRepository docRep = DocRepository();
                  await docRep.deleteDoc(id);
                  getDocs();
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

