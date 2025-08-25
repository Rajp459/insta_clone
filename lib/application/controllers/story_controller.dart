import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryController extends GetxController {
  var allUsers = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  void fetchAllUsers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();

      final usersList = snapshot.docs.map((doc) {
        final data = doc.data();

        final String name = data['name'] ?? 'Unknown';
        final String profileImage = data['profile_image'] ?? '';

        if (kDebugMode) {
          print('User: $name, Image: $profileImage');
        }

        return {'name': name, 'profile_image': profileImage};
      }).toList();

      allUsers.value = usersList;
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch users: ${e.toString()}');
    }
  }
}
