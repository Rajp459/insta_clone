import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/loginAndSignUp/user_profile_setup.dart';

class RegistrationController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Get.snackbar(
        'Registration Successful',
        'Registration Successful',
        colorText: Colors.black,
        backgroundColor: Colors.green.shade100,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAll(() => UserProfileSetup());
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Failed',
        e.message ?? 'Registration Failed',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
