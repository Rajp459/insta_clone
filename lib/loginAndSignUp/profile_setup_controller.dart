import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';

class ProfileSetupController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController profileImageController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void createUser() async {
    final String name = nameController.text.trim();
    final String username = userNameController.text.trim();
    final String profileImage = profileImageController.text.trim();
    if (name.isEmpty || username.isEmpty) {
      Get.snackbar('Missing info', 'Please fill name and username');
      return;
    }
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'profile_image': profileImage,
        'user_name': username,
        'timestamp': FieldValue.serverTimestamp(),
      });
      nameController.clear();
      userNameController.clear();
      profileImageController.clear();
      Get.offAll(() => MyHomePage(title: ''));
      Get.snackbar('SuccessFul', 'User created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Error: ${e.toString()}');
    }
  }
}
