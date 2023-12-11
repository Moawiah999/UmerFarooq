import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/core/core_colors.dart';
import 'package:project_management/models/user_model.dart';
import 'package:project_management/screens/add_project.dart';
import 'package:project_management/screens/home_screen.dart';
import 'package:project_management/screens/login_screen.dart';

import '../repositories/user_repository.dart';
import '../supporting_widgets/showErrorPopup.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        foregroundColor: lightBlack,
        title: Text('Sign up',),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
      ),
      body:loading?const Center(child: CircularProgressIndicator()):
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30,),
              // SizedBox(
              //     height: 200,
              //     width: 200,
              //     child: Image.asset("assets/logo/admin.png")
              // ),
              // SizedBox(height: MediaQuery.of(context).size.height/8,),
              TextFormField(
                controller: _nameController,
                cursorColor: lightBlack,
                style: TextStyle(color: lightBlack),
                decoration:  InputDecoration(
                  labelStyle: TextStyle(color: lightBlack),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow), // Change underline color
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow), // Change underline color
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow), // Change underline color
                  ),enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow), // Change underline color
                ),
                  labelText: 'Name',
                  icon: Icon(Icons.person,color: lightBlack,),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                cursorColor: lightBlack,
                style: TextStyle(color: lightBlack),
                decoration:  InputDecoration(
                  labelStyle: TextStyle(color: lightBlack),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow), // Change underline color
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow), // Change underline color
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow), // Change underline color
                  ),enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow), // Change underline color
                ),
                  labelText: 'Email',
                  icon: Icon(Icons.email,color: lightBlack,),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains("@")||!value.contains(".")||!value.contains("com")) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                cursorColor: lightBlack,
                style: TextStyle(color: lightBlack),
                decoration:  InputDecoration(
                  labelStyle: TextStyle(color: lightBlack),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow), // Change underline color
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow), // Change underline color
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow), // Change underline color
                  ),enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow), // Change underline color
                ),
                  labelText: 'Password',
                  icon: Icon(Icons.lock,color: lightBlack,),
                  suffixIcon: GestureDetector(
                      onTap: (){
                        setState(() {
                          passVisible = !passVisible;
                        });
                      },
                      child: Icon(!passVisible?Icons.visibility:Icons.visibility_off,color: lightBlack,)
                  ),
                ),
                obscureText: passVisible,

                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightBlack
                ),
                onPressed: () async {
                  doSignUp();
                },
                child: Text('Sign up',style: TextStyle(color: white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool loading = false;

  Future doSignUp() async {
    if (_formKey.currentState!.validate()) {
      try{
        setState(() {
          loading = true;
        });

        UserRepository userRepository = UserRepository();
        await userRepository.createUser(
            UserModel(
                userName: _nameController.text,
                email: _emailController.text,
                password: _passwordController.text,
                userType: "user",
              newMessageSender: [],
              timeStamp: DateTime.now().microsecondsSinceEpoch
            )
        );
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context)=>const LoginPage()));


      }catch(e){

        setState(() {
          loading=false;
        });

        // ignore: use_build_context_synchronously
        showErrorPopUp(context, e.toString().contains("network")?"Check your Internet":"This email already Taken");

      }

    }
  }


}
