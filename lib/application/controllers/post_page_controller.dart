import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/core/service/firebase_storage.dart';

import '../../data/importantdata/user_id.dart';

class PostPageController extends GetxController {
  final TextEditingController postImageController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  final userService = UserService();
  final Storage storage = Storage();

  RxString currentUserName = ''.obs;
  RxString currentProfileImage = ''.obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchUserData();
  }

  void _fetchUserData() async {
    final String userId = userService.getCurrentUserId();

    try {
      final userDoc = await storage.getUserData(userId);

      if (userDoc != null) {
        currentUserName.value = userDoc['name'];
        currentProfileImage.value = userDoc['profile_image'];
        isLoading.value = false;
      }
      update();
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
      await storage.createPost(
        userId: userId,
        name: currentUserName.value,
        profileImage: currentProfileImage.value,
        postImage: postImage,
        caption: caption,
      );

      postImageController.clear();
      captionController.clear();
      update();
      Get.snackbar('Successful', 'Post created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Error: ${e.toString()}');
    }
  }
}
