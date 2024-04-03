import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference colRef = FirebaseFirestore.instance.collection("users");

  //for password visibility
  var isPasswordVisible = false.obs;

  Future<UserCredential?> signUpMethod(
    String userName,
    String userEmail,
    String userPhone,
    String userPassword,
    String userDeviceToken,
  ) async {
    try {
      
      
      print("-------->>User Created<<----------");


      // EasyLoading.show(status: 'loading...');
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      //send email verification
      await userCredential.user!.sendEmailVerification();

      print("------>>Email sent<<------");

      // print(userModel);
      //save user data to firestore
      // await _firestore
      //     .collection('users')
      //     .doc(userCredential.user!.uid)
      //     .set(userModel.toMap());
      colRef.doc(userCredential.user!.uid).set({
        'uId' : userCredential.user!.uid,
        'name' : userName,
        'email' : userEmail,
        'phone' : userPhone,
        'isAdmin' : false,
        'deviceToken': userDeviceToken,
      }).then((value) => print("User Added"));
      
      print("Everything is okey-----........");

      // EasyLoading.dismiss();

      return userCredential;
      
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", "$e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    return null; 
  }
}