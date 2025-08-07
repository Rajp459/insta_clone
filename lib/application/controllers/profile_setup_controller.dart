import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/core/service/firebase_storage.dart';
import 'package:insta_clone/widgets/navigation_page.dart';

class ProfileSetupController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController profileImageController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  final storage = Storage();
  void createUser() async {
    final String name = nameController.text.trim();
    final String username = userNameController.text.trim();
    final String profileImage = profileImageController.text.trim();
    if (name.isEmpty || username.isEmpty) {
      Get.snackbar('Missing info', 'Please fill name and username');
      return;
    }
    try {
      storage.setUser(
        name: name,
        username: username,
        profileImage: profileImage,
      );
      nameController.clear();
      userNameController.clear();
      profileImageController.clear();
      Get.offAll(() => NavigationPage(title: ''));
      Get.snackbar(
        'Successful',
        'User created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.black,
      );
    } catch (e) {
      Get.snackbar('Error', 'Error: ${e.toString()}');
    }
  }
}
