import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/core/core_colors.dart';
import 'package:project_management/repositories/user_repository.dart';
import 'package:project_management/screens/add_project.dart';
import 'package:project_management/screens/home_screen.dart';
import 'package:project_management/screens/user_sign_up_screen.dart';
import 'package:project_management/supporting_widgets/showErrorPopup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;
  bool passVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text('LOGIN',style: TextStyle(color: lightBlack)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: loading?const Center(child: CircularProgressIndicator()):
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30,),
                SizedBox(
                  height: 200,
                    width: 200,
                    child: Image.asset("assets/logo/UCG_LOGO.png")
                ),
                SizedBox(height: MediaQuery.of(context).size.height/8,),
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
                    doLogin();
                  },
                  child: Text('Login',style: TextStyle(color: white)),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>const SignUpPage()));
                  },
                  child:  Text("Sign up",style: TextStyle(color: lightBlack)),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future doLogin() async {
    if (_formKey.currentState!.validate()) {
      try{
        setState(() {
          loading = true;
        });

        UserRepository userRepository = UserRepository();
        await userRepository.userLogin(_emailController.text, _passwordController.text);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context)=>const HomeScreen()));

      }catch(e){

        setState(() {
          loading=false;
        });

        // ignore: use_build_context_synchronously
        showErrorPopUp(context, e.toString().contains("network")?"Check your Internet":"wrong credentials");

      }

    }
  }


}
