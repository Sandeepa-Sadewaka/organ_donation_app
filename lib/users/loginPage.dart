import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:organ_donation_app/Database/database_connection.dart';
import 'package:organ_donation_app/Screens/HomePage.dart';
import 'package:organ_donation_app/users/model/user.dart';
import 'package:organ_donation_app/users/model/userPrefereces/user_preferences.dart';
import 'package:organ_donation_app/users/registerPage.dart';
import 'package:http/http.dart' as http;

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {

var formKey = GlobalKey<FormState>();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

loginUserNow() async{
  try{
    var res = await http.post(
      Uri.parse(Database.login),
      body: {
        "user_email": emailController.text.trim(),
        "user_password": passwordController.text.trim()
      }
    );

  if(res.statusCode==200){
      var resBodyOfLogin = jsonDecode(res.body);
      if(resBodyOfLogin['success'] == true){
        Fluttertoast.showToast(msg: "Logged-in Successfully.");

        User userInfo = User.fromJson(resBodyOfLogin["userData"]);

        // save userInfo to local Storage using shared prefrences
        await RememberUserPrefs.saveRememberUser(userInfo);

        

        setState(() {
          passwordController.clear();
          emailController.clear();
        });

        Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomePage()));
      }else{
        Fluttertoast.showToast(msg: "Incorrect Email or Password, Please Try Again.");
      }
    }
  }catch(e){
    print("Error :$e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(3,57,108, 1),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,top: 100),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/Images/logo.png",width: 120,),
                  const Text("LOGIN",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text("Your Email",style: TextStyle(color: Colors.grey,fontSize: 20),),
                      ),
                      TextField(
                      controller: emailController,
                      decoration:const InputDecoration(
                      border: OutlineInputBorder(),
                      helperText: 'Enter Your Registered Email',
                      helperStyle: TextStyle(color: Colors.grey),
                      
                    ),
                    style: const TextStyle(color: Colors.white),
                  ), 
                    ],
                  ),
                      
                  const SizedBox(
                    height: 15,
                  ),
                  
              
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text("Password",style: TextStyle(color: Colors.grey,fontSize: 20),),
                      ),
                      
                      TextField(
                      controller: passwordController,
                      decoration:const InputDecoration(
                      border: OutlineInputBorder(),
                      helperText: 'Enter Your Password',
                      helperStyle: TextStyle(color: Colors.grey),
                      
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                    ],
                  ),
                  
                  const SizedBox(
                    height: 20,
                  ),
              
                  SizedBox(
                    width: 500,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: (){
                        if(formKey.currentState!.validate()){
                          loginUserNow();
                        }
                      },
                      child: const Text("Login",style: TextStyle(fontSize: 20),),
                    ),
                  ),
                      
                  const SizedBox(
                    height: 20,
                  ),
                      
                  RichText(text: TextSpan(children: [
                    const TextSpan(
                      text: "If you haven't an account ?",
                      style: TextStyle(
                        color: Colors.white
                      )
                    ),
                      
                    
                      
                    TextSpan(
                        text: '  Register here',
                        style: const TextStyle(
                          color: Colors.yellow
                        ),
                        recognizer: TapGestureRecognizer()..onTap = (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const RegisterPage()));
                        }
                      )
                      
                  ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}