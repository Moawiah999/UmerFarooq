

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/core/core_colors.dart';
import 'package:project_management/models/project_detail_model.dart';
import 'package:project_management/repositories/dropbox_link_repository.dart';
import 'package:project_management/supporting_widgets/icon_container.dart';
import 'package:project_management/supporting_widgets/showErrorPopup.dart';

import 'launch_urls_class.dart';

class ShowProjectDetailScreen extends StatefulWidget {
  final ProjectDetailModel projectDetailModel;
  const ShowProjectDetailScreen({super.key, required this.projectDetailModel});

  @override
  // ignore: library_private_types_in_public_api
  _ShowProjectDetailScreenState createState() => _ShowProjectDetailScreenState();
}

class _ShowProjectDetailScreenState extends State<ShowProjectDetailScreen> {

// // Fetch the data from wherever you have stored it
//   late String projectName = widget.projectDetailModel.projectName;
//   late String address = widget.projectDetailModel.address;
//   late String phoneNumber = widget.projectDetailModel.phoneNumber;
//   late String email = widget.projectDetailModel.email;
//   late String lockBoxCode = widget.projectDetailModel.lockboxCode;
//   late String emergencyContact = widget.projectDetailModel.emergencyContact;
//   late String notes = widget.projectDetailModel.notes;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    takeLink();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amberAccent.shade700,
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        title: Text(widget.projectDetailModel.projectName,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
        centerTitle: true,
        foregroundColor: lightBlack,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16),
        child: SingleChildScrollView(
          child:loading?Center(
            child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/2.2),
                child: CircularProgressIndicator(color: lightBlack,)),
          ) :
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width/1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/project.jfif'), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 10,),

                 Text(
                  'Project Name:',
                  style: TextStyle(fontWeight: FontWeight.bold,color: lightBlack),
                ),
                Text(widget.projectDetailModel.projectName,
                    style: TextStyle(color: lightBlack)
                ),
                const SizedBox(height: 5.0),
                 Text(
                  'Address:',
                  style: TextStyle(fontWeight: FontWeight.bold,color: lightBlack),
                ),
                Text(widget.projectDetailModel.address,
                    style: TextStyle(color: lightBlack)),
                const SizedBox(height: 5.0),
                 Text(
                  'Tenant Name:',
                  style: TextStyle(fontWeight: FontWeight.bold,color: lightBlack),
                ),
                Text(widget.projectDetailModel.tenantName,
                    style: TextStyle(color: lightBlack)),
                const SizedBox(height: 5.0),
                 Text(
                  'Tenant Phone:',
                  style: TextStyle(fontWeight: FontWeight.bold,color: lightBlack),
                ),
                Text(widget.projectDetailModel.tenantPhone,
                    style: TextStyle(color: lightBlack)),
                const SizedBox(height: 5.0),
                 Text(
                  'LockBox Code:',
                  style: TextStyle(fontWeight: FontWeight.bold,color: lightBlack),
                ),
                Text(widget.projectDetailModel.lockBoxCode,
                    style: TextStyle(color: lightBlack)),
                const SizedBox(height: 5.0),
                 Text(
                  'Emergency Contact Person Name:',
                  style: TextStyle(fontWeight: FontWeight.bold,color: lightBlack),
                ),
                Text(widget.projectDetailModel.emergencyPersonName,
                    style: TextStyle(color: lightBlack)),
                const SizedBox(height: 5.0),
                 Text(
                  'Emergency Contact:',
                  style: TextStyle(fontWeight: FontWeight.bold,color: lightBlack),
                ),
                Text(
                    widget.projectDetailModel.emergencyPersonPhone,
                    style: TextStyle(color: lightBlack)),
                const SizedBox(height: 5.0),
                Text(
                  'Emergency Detail:',
                  style: TextStyle(fontWeight: FontWeight.bold,color: lightBlack),
                ),
                Text(
                    widget.projectDetailModel.emergencyDetail,
                    style: TextStyle(color: lightBlack)),
                const SizedBox(height: 5.0),

               currentUser?.email!="admin@gmail.com"?Container():
               Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    TextButton.icon(
                      onPressed: (){
                        addLinkPopup("0");
                      },
                      icon:  Icon(Icons.edit_calendar,color: lightBlack,),
                      label: Text(linksList.isNotEmpty?linksList[0].isNotEmpty?linksList[0]:"put DropBoxLink":"put DropBoxLink"),
                    ),

                    TextButton.icon(
                        onPressed: (){
                          addLinkPopup("1");
                        },
                        icon:  Icon(Icons.shopping_bag,color: lightBlack,),
                      label: Text(linksList.isNotEmpty?linksList[1].isNotEmpty?linksList[1]:"put DropBoxLink":"put DropBoxLink"),
                    ),

                    TextButton.icon(
                        onPressed: (){
                          addLinkPopup("2");
                        },
                        icon:  Icon(Icons.image,color: lightBlack,),
                      label: Text(linksList.isNotEmpty?linksList[2].isNotEmpty?linksList[2]:"put DropBoxLink":"put DropBoxLink"),
                    ),

                    TextButton.icon(
                        onPressed: (){
                          addLinkPopup("3");
                        },
                        icon: Icon(Icons.receipt,color: lightBlack,),
                      label: Text(linksList.isNotEmpty?linksList[3].isNotEmpty?linksList[3]:"put DropBoxLink":"put DropBoxLink"),
                    ),

                    TextButton.icon(
                        onPressed: (){
                          addLinkPopup("4");
                        },
                        icon:  Icon(Icons.note,color: lightBlack,),
                      label: Text(linksList.isNotEmpty?linksList[4].isNotEmpty?linksList[4]:"put DropBoxLink":"put DropBoxLink"),
                    ),

                    TextButton.icon(
                        onPressed: (){
                          addLinkPopup("5");
                        },
                        icon: Icon(Icons.audiotrack,color: lightBlack,),
                      label: Text(linksList.isNotEmpty?linksList[5].isNotEmpty?linksList[5]:"put DropBoxLink":"put DropBoxLink"),
                    ),
                  ],
                ),

                const SizedBox(height: 20,),

                 SizedBox(
                   width: MediaQuery.of(context).size.width/1,
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      GestureDetector(
                        onTap: () async {
                          UrlLauncherClass urlLauncherClass = UrlLauncherClass();
                          await urlLauncherClass.doLaunchUrl(
                              linksList.isNotEmpty?linksList[0].isNotEmpty?linksList[0]:"":""
                          );

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context)=>
                          //         PlansAndPermitsListScreen(projectDetailModel: widget.projectDetailModel,
                          //           link: linksList.isNotEmpty?linksList[0].isNotEmpty?linksList[0]:"":"",
                          //         )));

                        },
                        child: const IconContainer(
                          tittle: "Plans",
                          icon: Icons.edit_calendar,
                          height: 100,
                          width: 80,
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          UrlLauncherClass urlLauncherClass = UrlLauncherClass();
                          await urlLauncherClass.doLaunchUrl(
                              linksList.isNotEmpty?linksList[1].isNotEmpty?linksList[1]:"":""
                          );

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context)=>
                          //         PlansAndPermitsListScreen(projectDetailModel: widget.projectDetailModel,
                          //           link: linksList.isNotEmpty?linksList[0].isNotEmpty?linksList[0]:"":"",
                          //         )));

                        },
                        child: const IconContainer(
                          tittle: "Permits",
                          icon: Icons.shopping_bag,
                          height: 100,
                          width: 80,
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          UrlLauncherClass urlLauncherClass = UrlLauncherClass();
                          await urlLauncherClass.doLaunchUrl(
                              linksList.isNotEmpty?linksList[2].isNotEmpty?linksList[2]:"":""
                          );

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context)=>
                          //         ImageListScreen(projectDetailModel: widget.projectDetailModel,
                          //           link: linksList.isNotEmpty?linksList[1].isNotEmpty?linksList[1]:"":"",)));

                        },
                        child: const IconContainer(
                          tittle: "Image",
                          icon: Icons.camera_alt_rounded,
                          height: 100,
                          width: 80,
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          UrlLauncherClass urlLauncherClass = UrlLauncherClass();
                          await urlLauncherClass.doLaunchUrl(
                              linksList.isNotEmpty?linksList[3].isNotEmpty?linksList[3]:"":""
                          );

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context)=>
                          //         ReceiptListScreen(projectDetailModel: widget.projectDetailModel,
                          //           link: linksList.isNotEmpty?linksList[2].isNotEmpty?linksList[2]:"":"",
                          //         )));
                        },
                        child: const IconContainer(
                          tittle: "Receipt",
                          icon: Icons.receipt,
                          height: 100,
                          width: 80,
                        ),
                      ),

                    ],
                                 ),
                 ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        UrlLauncherClass urlLauncherClass = UrlLauncherClass();
                        await urlLauncherClass.doLaunchUrl(
                            linksList.isNotEmpty?linksList[4].isNotEmpty?linksList[4]:"":""
                        );

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context)=>
                        //             NotesListScreen(
                        //               projectDetailModel: widget.projectDetailModel,
                        //                 link: linksList.isNotEmpty?linksList[3].isNotEmpty?linksList[3]:"":""
                        //             ))
                        // );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width/1,
                        height: 70,
                        decoration: BoxDecoration(
                            color: lightBlack,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_sharp,
                              color: Colors.white, // Change the icon color as needed
                              size: 40, // Change the icon size as needed
                            ),

                            Text(
                              'Text Notes',
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                            ),

                          ],
                        ),
                      ),
                    ),


                    GestureDetector(
                      onTap: () async {
                        UrlLauncherClass urlLauncherClass = UrlLauncherClass();
                        await urlLauncherClass.doLaunchUrl(
                            linksList.isNotEmpty?linksList[5].isNotEmpty?linksList[5]:"":""
                        );

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context)=> VoiceNotesScreen(
                        //       projectDetailModel: widget.projectDetailModel,
                        //         link: linksList.isNotEmpty?linksList[4].isNotEmpty?linksList[4]:"":""
                        //     ))
                        // );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width/1,
                        height: 70,
                        decoration: BoxDecoration(
                            color: lightBlack,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.audiotrack,
                              color: Colors.white, // Change the icon color as needed
                              size: 40, // Change the icon size as needed
                            ),

                            Text(
                              'Audio Notes',
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future addLinkPopup(String linkId){
    return showDialog(
      context: context,
      builder: (context) {
        TextEditingController textController = TextEditingController();
        return AlertDialog(
          title: const Text('Make sure link is correct'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Paste link',
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
                  putLink(textController.text,linkId);
                }

              },
            ),
          ],
        );
      },
    );
  }

  bool loading = false;

  putLink(String linkTxt,String linkId) async {
    try{

        Navigator.of(context).pop();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );
        DropboxLinkRepository dropbxrep = DropboxLinkRepository();
        await dropbxrep.putLink(widget.projectDetailModel.id??"", linkTxt,linkId);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        takeLink();
    }catch(e){
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      showErrorPopUp(context, e.toString().contains("network")?"Check your Internet":"Something Went Wrong");
    }
  }
  List<String> linksList = [];
  takeLink() async {
    try{
      setState(() {
        loading = true;
      });
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => const Center(child: CircularProgressIndicator()),
      // );
      DropboxLinkRepository dropbxrep = DropboxLinkRepository();
      linksList.clear();
       linksList = await dropbxrep.getLink(widget.projectDetailModel.id??"");

       setState(() {
         linksList;
         loading = false;
       });
      // ignore: use_build_context_synchronously
      // Navigator.of(context).pop();

    }catch(e){
      setState(() {
        loading = false;
      });
      // ignore: use_build_context_synchronously
      // Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      showErrorPopUp(context, e.toString().contains("network")?"Check your Internet":"Something Went Wrong");
    }
  }

}
