import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/core/core_colors.dart';
import 'package:project_management/screens/add_project.dart';
import 'package:project_management/screens/chat_screen.dart';
import 'package:project_management/screens/login_screen.dart';
import 'package:project_management/screens/project_list_screen.dart';
import 'package:project_management/screens/show_project_detail.dart';
import 'package:project_management/screens/users_list_screen.dart';
import 'package:project_management/supporting_widgets/showErrorPopup.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  String userName = "";
  String email = "";
  String pass = "";
  bool loading = false;
  Future<void> getUserDetail()async {

    UserRepository userRepository = UserRepository();
    UserModel userModel = await userRepository.getUserData(currentUser?.email.toString()??"");
    userName = userModel.userName;
    email = userModel.email;
    pass = userModel.password;
    setState(() {
      userName;

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetail();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title:  Text("Home",style: TextStyle(color: lightBlack),),
        leading: IconButton(
          onPressed: (){
              _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),color: lightBlack,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: white,
        actions: [
          SizedBox(width:100,child: NotificationIcon(userId: userId)),
        ],
      ),
      body: loading?Center(child: CircularProgressIndicator(color: lightBlack,),):
      Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [white,white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Column(
              children: [
                SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset("assets/logo/UCG_LOGO.png")
                ),
                 Text('Manage Your Projects',style: TextStyle(color: lightBlack,fontWeight: FontWeight.bold,fontSize: 20),),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ProjectCard(
                  title: 'Show Projects',
                  icon: Icons.list,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> const ProjectListScreen()));
                  },
                ),
               currentUser?.email!="admin@gmail.com"?Container() :ProjectCard(
                  title: 'Add Project',
                  icon: Icons.add,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>const AddProjectScreen(projectDetailModel: null,)));
                  },
                ),
              ],
            ),
            const SizedBox(height: 0,),

          ],
        ),
      ),

      drawer: Drawer(
        backgroundColor: white,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: lightBlack),
              accountName: Text(userName),
              accountEmail: Text(email),
            ),

            // ListTile(
            //   leading: Icon(Icons.edit),
            //   title: Text('Edit'),
            //   onTap: () {
            //     _scaffoldKey.currentState?.closeDrawer();
            //   },
            // ),

            ListTile(
              leading: Icon(Icons.message_outlined,color: lightBlack,),
              title: Text('Messenger',style: TextStyle(color: lightBlack),),
              onTap: () async {
                setState(() {
                  _scaffoldKey.currentState?.closeDrawer();
                });

                  // ignore: use_build_context_synchronously
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) => const UserListScreen()
                  ));

              },
            ),

            ListTile(
              leading: Icon(Icons.logout,color: lightBlack,),
              title: Text('Log Out',style: TextStyle(color: lightBlack),),
              onTap: () async {
                setState(() {
                  _scaffoldKey.currentState?.closeDrawer();
                  loading =true;
                });

                  try {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    const LoginPage()), (Route<dynamic> route) => false);

                  } catch (e) {
                    setState(() {
                      loading =false;
                    });
                    // ignore: use_build_context_synchronously
                    await showErrorPopUp(context, e.toString());

                  }

              },
            ),
          ],
        ),
      ),

    );
  }
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ProjectCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;

  const ProjectCard({super.key, required this.title, required this.icon, required this.onTap});

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Card(
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      color: lightBlack, // Background color for the card
      child: Container(
        width: 150,
        height: 150,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 50,
              color: white, // Customize the icon color
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style:  TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: white, // Customize the text color
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}



class NotificationIcon extends StatelessWidget {
  final String userId ;

  const NotificationIcon({super.key, required this.userId}); // Replace with the desired user ID

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("users").doc(userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('');
        }

        List<dynamic> list = snapshot.data!['newMessageSender']??[];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        // Check if the document exists and conditions are met
        bool shouldShowButton = snapshot.hasData &&
            snapshot.data!.exists && list.isNotEmpty;

        return shouldShowButton
            ? TextButton.icon(
          onPressed: () {
            // Handle button press
          },
          label: const Text(
            "*New",
            style: TextStyle(color: Colors.red),
          ),
          icon: const Icon(
            Icons.notifications_sharp,
            color: Colors.red,
          ),
        )
            : const SizedBox();
      },
    );
  }
}