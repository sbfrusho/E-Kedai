import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    // userDeviceToken = Get.find<GetDeviceTokenController>().deviceToken!.toString();

    try {
      // print("-------->>User Created<<----------");
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      await userCredential.user!.sendEmailVerification();

      // print("------>>Email sent<<------");

      await colRef
          .add(
            {
              'uId': userCredential.user!.uid,
              'name': userName,
              'email': userEmail,
              'phone': userPhone,
              'isAdmin': false,
              'deviceToken': userDeviceToken,
            },
          )
          .then((value) => print("User added"))
          .catchError((error) => print("Failed to add user: $error"));

      // print("Everything is okey-----........");

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
