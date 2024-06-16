// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class SignInController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isPasswordVisible = false.obs;

  Future<UserCredential?> signInMethod(
    String userEmail,
    String userPassword,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "User not found");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Incorrect password");
      }
      // Display a general error message for other FirebaseAuthExceptions
      else {
        Fluttertoast.showToast(msg: "An error occurred. Please try again later.");
        showToast("An error occurred. Please try again later.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white);
    }
    return null;
  }

  Future<bool> signInWithBiometric(BuildContext context) async {
    bool canCheckBiometrics = await LocalAuthentication().canCheckBiometrics;
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics =
          await LocalAuthentication().getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        try {
          bool isAuthenticated = await LocalAuthentication().authenticate(
            localizedReason: "Authenticate to login",
          );
          return isAuthenticated;
        } catch (e) {
          Get.snackbar("Error", e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        }
      }
    }
    return false;
  }

  void showToast(String message) {
    Get.snackbar("Error", message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white);
  }
}
