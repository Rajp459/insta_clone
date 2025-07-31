import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../importantdata/user_id.dart';

class PostPageController extends GetxController {
  final TextEditingController postImageController = TextEditingController();
  final TextEditingController captionController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxString currentUserName = ''.obs;
  RxString currentProfileImage = ''.obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchUserData();
  }

  // Fetch current user's data from Firestore
  void _fetchUserData() async {
    final userService = UserService();
    final String userId = userService.getCurrentUserId();

    try {
      await _firestore.collection('users').doc(userId).get();
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        currentUserName.value = userDoc['name']; // Field name in your document
        currentProfileImage.value =
            userDoc['profile_image']; // Field name in your document
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Error fetching user data: ${e.toString()}');
    }
  }

  void createPost() async {
    final userService = UserService();
    final String postImage = postImageController.text.trim();
    final String caption = captionController.text.trim();

    if (postImage.isEmpty || caption.isEmpty) {
      Get.snackbar('', 'Please fill all fields');
      return;
    }

    try {
      final String userId = userService.getCurrentUserId();
      await _firestore.collection('posts').add({
        'userId': userId,
        'name': currentUserName.value,
        'profile_image': currentProfileImage.value,
        'post_image': postImage,
        'caption': caption,
        'timestamp': FieldValue.serverTimestamp(),
      });

      postImageController.clear();
      captionController.clear();

      Get.snackbar('Successful', 'Post created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Error: ${e.toString()}');
    }
  }
}
