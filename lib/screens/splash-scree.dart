import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/auth-ui/welcome-screen.dart';
import 'package:shopping_app/screens/user/home-screen.dart';
import 'package:shopping_app/screens/user/select-service.dart';

import '../utils/AppConstant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  User? user = FirebaseAuth.instance.currentUser;


  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds: 3), (){
      keepUserLoggedIn(context);
    });
  }

  //keep user loggedin
  Future<void> keepUserLoggedIn(BuildContext context) async {
    if(user != null){
     Navigator.push(context, MaterialPageRoute(builder: (context) => SelectService()));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConstant.colorBlue,
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 50),
                child: const Center(
                  child: Image(
                    image: AssetImage("assets/images/img_shopping_cart_1.png" ,),
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                child: const Center(
                  child: Text(
                    'E-kedai',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}