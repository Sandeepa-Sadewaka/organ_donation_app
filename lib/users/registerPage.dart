import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:organ_donation_app/Database/database_connection.dart';
import 'package:organ_donation_app/users/loginPage.dart';
import 'package:organ_donation_app/users/model/user.dart';
import 'package:http/http.dart' as http;


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

final GlobalKey<FormState> formKey = GlobalKey<FormState>();
TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

validateUserEmail() async{
  try{
    var res = await http.post(
      Uri.parse(Database.validateEmail),
      body: {
        'user_email': emailController.text.trim(),
      }
    );

    if(res.statusCode == 200)//from flutter app the connection with api to server - success
    {
      var resBodyOfValidateEmail = jsonDecode(res.body);

      if(resBodyOfValidateEmail['emailFound'] == true)
      {
        Fluttertoast.showToast(msg: "Email is already in someone else use. Try another email.");
      }
      else{
        //register & save new user record to database
        registerAndSaveUserRecord();
      }
    }

  }catch(e){

  }
}

registerAndSaveUserRecord() async{
  User userModel = User(
    1,
    nameController.text.trim(),
    emailController.text.trim(),
    passwordController.text.trim()
  );

  try{

    var res = await http.post(
      Uri.parse(Database.signUp),
      body: userModel.toJson()
    );

    if(res.statusCode==200){
      var resBodyOfSignUp = jsonDecode(res.body);
      if(resBodyOfSignUp['success'] == true){
        Fluttertoast.showToast(msg: "Registered Successfully.");

        setState(() {
          nameController.clear();
          passwordController.clear();
          emailController.clear();
        });

        Navigator.push(context, MaterialPageRoute(builder: (context)=> const Loginpage()));
      }else{
        Fluttertoast.showToast(msg: "Error Occured, Try Again.");
      }
    }

  }catch(e){
    print(e.toString());
    Fluttertoast.showToast(msg: e.toString());
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(3,57,108, 1),
      body: SingleChildScrollView(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,top: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/Images/logo.png",width: 120,),
                const Text("REGISTER",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
                const SizedBox(
                  height: 50,
                ),
                Form(
                  key: formKey,
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text("User Name",style: TextStyle(color: Colors.grey,fontSize: 20),),
                      ),
                      TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      helperText: 'Enter New Username',
                      helperStyle: TextStyle(color: Colors.grey),
                      
                    ),
                    style: const TextStyle(color: Colors.white),
                  ), 
                    ],
                  ),
                ),
        
                 const SizedBox(
                  height: 10,
                ),
        
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text("Email",style: TextStyle(color: Colors.grey,fontSize: 20),),
                    ),
                    TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    helperText: 'Enter Your Email',
                    helperStyle: TextStyle(color: Colors.grey),
                    
                  ),
                  style: const TextStyle(color: Colors.white),
                ), 
        
                
                  ],
                ),
        
                const SizedBox(
                  height: 10,
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
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    helperText: 'Enter New Password',
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
                        //validate the email
                        validateUserEmail();
                        //john@gmail.com
                        //john22@gmail.com
                        
                      }
                    },
                    child: const Text("Register",style: TextStyle(fontSize: 20),),
                  ),
                ),
        
                const SizedBox(
                  height: 20,
                ),
        
                RichText(text: TextSpan(children: [
                  const TextSpan(
                    text: "Already have an account ?",
                    style: TextStyle(
                      color: Colors.white
                    )
                  ),
        
                  
        
                  TextSpan(
                      text: '  Login here',
                      style: const TextStyle(
                        color: Colors.yellow
                      ),
                      recognizer: TapGestureRecognizer()..onTap = (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const Loginpage()));
                      }
                    )
        
                ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}