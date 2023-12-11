import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_management/models/project_detail_model.dart';
import 'package:project_management/models/send_audio_model.dart';
import 'package:project_management/repositories/audio_repository.dart';
import 'package:record/record.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../supporting_widgets/showErrorPopup.dart';
import 'launch_urls_class.dart';



class VoiceNotesScreen extends StatefulWidget {
  final ProjectDetailModel projectDetailModel;
  final String link;
  const VoiceNotesScreen({super.key, required this.projectDetailModel, required this.link});

  @override
  // ignore: library_private_types_in_public_api
  _VoiceNotesScreenState createState() => _VoiceNotesScreenState();
}

class _VoiceNotesScreenState extends State<VoiceNotesScreen> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  String userName = "";
  List<SendAudioModel> audioList = [];
  bool loading = false;

  Future<void> getAudios()async {

    try{
      setState(() {
        loading = true;
      });
      audioList.clear();
      UserRepository userRepository = UserRepository();
      UserModel userModel = await userRepository.getUserData(currentUser?.email.toString()??"");
      userName = userModel.userName;
      AudioRepository audioRepository = AudioRepository();
      audioList = await audioRepository.retrieveAudios(widget.projectDetailModel.id.toString());

      setState(() {
        userName;
        audioList;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Notes List"),
      ),
      body: loading?Center(child: CircularProgressIndicator(color: Colors.amber.shade900,),):
      audioList.isEmpty?Center(child: Text("no record!!"),):
      ListView.builder(
        // itemCount: audioNotes.length,
        itemCount: audioList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [

                   ListTile(
                    title: Text(
                      "sent by: ${audioList[index].senderName}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(audioList[index].date),
                      ],

                    ),
                     trailing:currentUser?.email!="admin@gmail.com"?Container(): IconButton(
                       onPressed: (){
                         deletePopup(audioList[index].id??"");
                       },
                       icon: Icon(Icons.delete,color: Colors.red,),
                     ),
                  ),

                  // Slider.adaptive(
                  //     thumbColor: Colors.black,
                  //     activeColor: Colors.black,
                  //     inactiveColor: Colors.grey,
                  //     min: 0,
                  //     value: position.inSeconds.toDouble(),
                  //     max: musicLength.inSeconds.toDouble()<1?5:musicLength.inSeconds.toDouble(),
                  //     onChanged: (value) {
                  //       seekToSec(value.toInt());
                  //     }),

                  const Divider(height: 20,thickness: 2,endIndent: 20,indent: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {

                          if(!playing || indexNumber!=index){
                            setState(() {
                              indexNumber = index;
                              playing = true;
                            });
                            // await _player.play(UrlSource(audioNotes[index].audioUrl));
                            // await _player.play(UrlSource(audioList[index].audioUrl));
                            await _player.setUrl(audioList[index].audioUrl);
                            _player.play();

                          }else{
                            setState(() {
                              indexNumber = index;
                              playing = false;
                            });
                            await _player.pause();
                          }
                        },
                          child: Icon(playing && indexNumber==index?Icons.pause:Icons.play_arrow,size: 30,)
                      )
                    ],
                  ),
                  const SizedBox(height: 15,)

                ],
              ),
            ),
          );
        },
      ),

      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () async {
      //     // Add your onPressed code here!
      //
      //   },
      //   label: Container(
      //     color: Colors.amber.shade900,
      //     padding: EdgeInsets.all(3),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //
      //         isRec?Container():
      //         GestureDetector(
      //             onTap: (){
      //               setState(() {
      //                 isRec=true;
      //               });
      //               recordVoice();
      //             },
      //             child: const Icon(Icons.keyboard_voice,color: Colors.white)
      //         ),
      //
      //
      //         !isRec?Container(): const Text('Recoding....',style: TextStyle(color: Colors.white),),
      //         const SizedBox(width: 20,),
      //
      //         !isRec?Container(): GestureDetector(
      //           onTap: () async {
      //             await record.dispose();
      //             setState(() {
      //               isRec=false;
      //             });
      //           },
      //             child: const Text('Cancel',style: TextStyle(color: Colors.white),)),
      //
      //         const SizedBox(width: 20,),
      //
      //         !isRec?Container(): GestureDetector(
      //             onTap: (){
      //               stopRecorder();
      //             },
      //             child: const Text('Send',style: TextStyle(color: Colors.white),)),
      //
      //       ],
      //     ),
      //   ),
      //
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
              label: const Text("dropbox"),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.amber.shade900,
              borderRadius: BorderRadius.circular(20)
            ),
            padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                isRec?Container():
                GestureDetector(
                    onTap: (){
                      setState(() {
                        isRec=true;
                      });
                      recordVoice();
                    },
                    child: const Icon(Icons.keyboard_voice,color: Colors.white)
                ),


                !isRec?Container(): const Text('Recoding..',style: TextStyle(color: Colors.white),),
                const SizedBox(width: 20,),

                !isRec?Container(): GestureDetector(
                    onTap: () async {
                      await record.dispose();
                      setState(() {
                        isRec=false;
                      });
                    },
                    child: const Text('Cancel',style: TextStyle(color: Colors.white),)),

                const SizedBox(width: 20,),

                !isRec?Container(): GestureDetector(
                    onTap: (){
                      stopRecorder();
                    },
                    child: const Text('Send',style: TextStyle(color: Colors.white),)),

              ],
            ),
          ),

        ],
      ),

    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _player.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAudios();
    _player.playerStateStream.listen((state) {
      if(state.processingState == ProcessingState.completed){
        setState(() {
          playing = false;
        });
      }

    });

  }


  bool playing = false;
  final AudioPlayer _player = AudioPlayer();
  // late AudioCache cache;
  int indexNumber = 0;

  final record = Record();
  bool isRec = false;

  Future recordVoice() async{
    Directory? tempDir = await getApplicationDocumentsDirectory();
    File filePath = File('${tempDir.path}/audioFile.mp3');
    if (await record.hasPermission()) {
      // Start recording
      await record.start(
        path: filePath.path,
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
        samplingRate: 44100, // by default
      );
    }
  }

  late var path="";
  stopRecorder() async {
     path = (await record.stop())!;
     setState(() {
       isRec = false;
       loading = true;

     });

     File file = File(path);
     String fileName = DateTime.now().toLocal().toString();

     try{

       await FirebaseStorage.instance.ref("audios/$fileName.mp3").putFile(file).then((p) async {
         String url = await FirebaseStorage.instance.ref("audios/$fileName.mp3").getDownloadURL();
         AudioRepository receiptRepository = AudioRepository();
         await receiptRepository.addAudio(
             SendAudioModel(
               audioUrl: url,
               date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
               senderName: userName,
               projectID: widget.projectDetailModel.id.toString(),
               senderID: userId,
             )
         ).then((value) {
           getAudios();
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
                  AudioRepository audioRep = AudioRepository();
                  await audioRep.deleteAudio(id);
                  getAudios();
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
