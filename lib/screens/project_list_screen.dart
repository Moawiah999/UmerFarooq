import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/core/core_colors.dart';
import 'package:project_management/repositories/audio_repository.dart';
import 'package:project_management/repositories/doc_repository.dart';
import 'package:project_management/repositories/notes_repository.dart';
import 'package:project_management/repositories/receipt_repository.dart';
import 'package:project_management/repositories/send_image_repository.dart';
import 'package:project_management/screens/add_project.dart';
import 'package:project_management/screens/show_project_detail.dart';

import '../models/project_detail_model.dart';
import '../repositories/project_repository.dart';
import '../supporting_widgets/showErrorPopup.dart';
class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  List<ProjectDetailModel> projectList = [];
  Future<void> getProjects()async {
    setState(() {
      loading=true;
    });
    try{
      projectList.clear();
      ProjectRepository projectRepository = ProjectRepository();
      projectList = await projectRepository.retrieveProjects();
      setState(() {
        projectList;
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
    getProjects();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title:  Text('Projects List',style: TextStyle(color: lightBlack),),
        backgroundColor: white,
        foregroundColor: lightBlack,
      ),
      body:loading?Center(child: CircularProgressIndicator(color: lightBlack,),):
      projectList.isEmpty?const Center(child: Text("no record!!")):
      ListView.builder(
        itemCount: projectList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShowProjectDetailScreen(projectDetailModel: projectList[index])),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: lightBlack, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80, // Adjust the size as needed
                    height: 80, // Adjust the size as needed
                    child: Image.asset("assets/images/project_icon.png"),
                  ),
                  const SizedBox(width: 16.0), // Add some spacing
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          projectList[index].projectName,
                          style:  TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: lightBlack
                          ),
                        ),
                        // You can add more widgets here, such as project descriptions or buttons.
                      ],
                    ),
                  ),
                  currentUser?.email!="admin@gmail.com"?Container() :IconButton(
                      onPressed: (){
                        showOptionsDialogue(projectList[index]);
                      },
                      icon: Icon(Icons.more_rounded,color: lightBlack,)
                  )
                ],
              ),
            ),
          );

        },
      ),
    );
  }

  Future showOptionsDialogue(ProjectDetailModel projectDetailModel){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text("Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:  Icon(Icons.edit,color: lightBlack,),
                title:  Text("Edit",style: TextStyle(color: lightBlack)),
                onTap: () async {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProjectScreen(projectDetailModel: projectDetailModel)),
                  );

                },
              ),
              ListTile(
                leading:  Icon(Icons.delete,color: lightBlack,),
                title:  Text("Delete",style: TextStyle(color: lightBlack),),
                onTap: () {
                  Navigator.of(context).pop();

                  deletePopup(projectDetailModel);// Close the dialog
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child:  Text("Close",style: TextStyle(color: lightBlack)),
            ),
          ],
        );
      },
    );
  }

  Future deletePopup(ProjectDetailModel projectDetailModel){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                deleteProject(projectDetailModel);
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

  bool loading = false;
  Future deleteProject(ProjectDetailModel projectDetailModel) async {
      try{
        setState(() {
          loading = true;
        });

        ProjectRepository projectRepository = ProjectRepository();
        DocRepository docRepository = DocRepository();
        ImageRepository  imageRepository= ImageRepository();
        ReceiptRepository receiptRepository = ReceiptRepository();
        NotesRepository notesRepository = NotesRepository();
        AudioRepository audioRepository = AudioRepository();
        await projectRepository.deleteProject(projectDetailModel);
        await docRepository.deleteDocs(projectDetailModel);
        await imageRepository.deleteImage(projectDetailModel);
        await receiptRepository.deleteReceipts(projectDetailModel);
        await notesRepository.deleteNotes(projectDetailModel);
        await audioRepository.deleteAudios(projectDetailModel);

        getProjects();

      }catch(e){

        setState(() {
          loading=false;
        });

        // ignore: use_build_context_synchronously
        showErrorPopUp(context, e.toString().contains("network")?"Check your Internet":"Something Went Wrong");

      }


  }





}
