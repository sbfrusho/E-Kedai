// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference colRef = FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;
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
      // Check if email is already in use in Firebase Authentication
      List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(userEmail);
      if (signInMethods.isNotEmpty) {
        Fluttertoast.showToast(msg: "The email address is already in use.");
        Get.snackbar("Error", "The email address is already in use.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
        return null;
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      await userCredential.user!.sendEmailVerification();

      await colRef
          .doc(userCredential.user!.uid) // Use uid as the document id
          .set({
            'uId': userCredential.user!.uid,
            'name': userName,
            'email': userEmail,
            'phone': userPhone,
            'isAdmin': false,
            'deviceToken': userDeviceToken,
            'city': '',
            'state': '',
            'country': '',
            'road': '',
            'postalCode': '',
            'adress': '',
          })
          .then((value) => print("User added"))
          .catchError((error) => print("Failed to add user: $error"));

      Get.snackbar("Success", "Registration successful. Please verify your email.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: "The email address is already in use.");
        Get.snackbar("Error", "The email address is already in use.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      } else if (e.code == 'invalid-email') {
        Fluttertoast.showToast(msg: "The email address is not valid.");
        Get.snackbar("Error", "The email address is not valid.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      } else if (e.code == 'weak-password') {
        Get.snackbar("Error", "The password is too weak.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      } else {
        Get.snackbar("Error", e.message!,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white);
    }
    return null;
  }
}
