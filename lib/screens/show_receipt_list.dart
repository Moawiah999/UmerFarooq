import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_management/models/send_receipt_model.dart';
import 'package:project_management/repositories/receipt_repository.dart';

import '../models/project_detail_model.dart';
import '../models/send_image_model.dart';
import '../models/user_model.dart';
import '../repositories/send_image_repository.dart';
import '../repositories/user_repository.dart';
import '../supporting_widgets/showErrorPopup.dart';
import 'launch_urls_class.dart';
class ReceiptListScreen extends StatefulWidget {
  final ProjectDetailModel projectDetailModel;
  final String link;

  const ReceiptListScreen({super.key, required this.projectDetailModel, required this.link});

  @override
  State<ReceiptListScreen> createState() => _ReceiptListScreenState();
}

class _ReceiptListScreenState extends State<ReceiptListScreen> {


  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  String userName = "";
  List<SendReceiptModel> receiptList = [];
  bool loading = false;
  Future<void> getReceipt()async {
    setState(() {
      loading = true;
    });
    try{
      receiptList.clear();
      UserRepository userRepository = UserRepository();
      UserModel userModel = await userRepository.getUserData(currentUser?.email.toString()??"");
      userName = userModel.userName;
      print("name is: $userName");
      ReceiptRepository receiptRepository = ReceiptRepository();
      receiptList = await receiptRepository.retrieveReceipts(widget.projectDetailModel.id.toString());

      setState(() {
        userName;
        receiptList;
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
  final ImagePicker _picker = ImagePicker();

  File? file;
  bool imgSelected = false;
  XFile? image;
  // Pick an image
  Future pickImage()async{
    image = await _picker.pickImage(source: ImageSource.gallery);
    file = File(image!.path);
    if(await file!.exists()) {
      setState(() {
        file;
        imgSelected = true;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReceipt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt List"),
      ),
      body: loading?Center(child: CircularProgressIndicator(color: Colors.amber.shade900,),):
      receiptList.isEmpty?const Center(child: Text("no record!!"),):
      ListView.builder(
        itemCount: receiptList.length,
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
                  const SizedBox(height: 10,),
                  Image.network(
                    receiptList[index].receiptLink,
                    fit: BoxFit.fill,
                    height: 200.0, // Set the image height as needed
                  ),
                  ListTile(
                    title: Text("sent by: ${receiptList[index].senderName}"),
                    subtitle: Text(receiptList[index].date),
                    trailing:currentUser?.email!="admin@gmail.com"?Container(): IconButton(
                      onPressed: (){
                        deletePopup(receiptList[index].id??"");
                      },
                      icon: const Icon(Icons.delete,color: Colors.red,),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    //   floatingActionButton: FloatingActionButton.extended(
    //   onPressed: () async {
    //     // Add your onPressed code here!
    //     await pickImage();
    //     if(imgSelected){
    //       uploadImage();
    //     }
    //   },
    //   label: const Text('Upload',style: TextStyle(color: Colors.white),),
    //   icon: const Icon(Icons.receipt,color: Colors.white,),
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
                  await pickImage();
                  if(imgSelected){
                    uploadImage();
                  }
                },
                icon: Icon(Icons.receipt,color: Colors.amber.shade900),
                label: const Text("Upload receipt")),

          ],
        )

    );
  }


  uploadImage() async {
    try{
      setState(() {
        loading = true;
      });

      await FirebaseStorage.instance.ref("receipts/${image!.name}").putFile(file!).then((p) async {
        String url = await FirebaseStorage.instance.ref("receipts/${image!.name}").getDownloadURL();

        ReceiptRepository receiptRepository = ReceiptRepository();
        await receiptRepository.addReceipt(
            SendReceiptModel(
              receiptLink: url,
              date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
              senderName: userName,
              projectID: widget.projectDetailModel.id.toString(),
              senderID: userId,
            )
        ).then((value) {
          getReceipt();
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
                  ReceiptRepository receiptRepo = ReceiptRepository();
                  await receiptRepo.deleteReceipt(id);
                  getReceipt();
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

