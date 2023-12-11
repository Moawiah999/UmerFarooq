import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:project_management/screens/add_project.dart';
import 'package:project_management/screens/chat_screen.dart';
import 'package:project_management/screens/launch_urls_class.dart';
import 'package:project_management/screens/home_screen.dart';
import 'package:project_management/screens/login_screen.dart';
import 'package:project_management/screens/notes_list_screen.dart';
import 'package:project_management/screens/show_project_detail.dart';
import 'package:project_management/screens/show_receipt_list.dart';
import 'package:project_management/screens/user_sign_up_screen.dart';
import 'package:project_management/screens/users_list_screen.dart';
import 'package:project_management/screens/voice_notes_screen.dart';

import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final userId = FirebaseAuth.instance.currentUser?.uid??"";

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber.shade100),
        useMaterial3: true,
      ),
      // home: const AddProjectScreen(),
      // home: const ShowProjectDetailScreen(),
      // home: const ReceiptListScreen(),
      // home: const NotesListScreen(),
      // home: const VoiceNotesScreen(),
      home: userId.isEmpty?const LoginPage():const HomeScreen(),
      // home: userId.isEmpty?const LoginPage():const UserListScreen(),
      // home: const HomeScreen(),
      // home: const SignUpPage(),
      // home: const DropboxScreen(),
    );
  }
}
