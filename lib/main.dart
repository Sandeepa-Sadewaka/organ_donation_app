import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:organ_donation_app/Screens/splash_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(options:const FirebaseOptions(
    apiKey: "AIzaSyBkIgsMI8bOoQOpCD6VKM0FBOqLY-GfBys",
    authDomain: "organdonationapp-93666.firebaseapp.com",
    projectId: "organdonationapp-93666",
    storageBucket: "organdonationapp-93666.firebasestorage.app",
    messagingSenderId: "469497697071",
    appId: "1:469497697071:web:b5bfdf314f445d0b5dc7da",
    measurementId: "G-34S6VBFF4F"));
  }
  else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

