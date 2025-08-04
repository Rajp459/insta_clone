import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/importantdata/user_id.dart';

class ChatPageController extends GetxController {
  RxString currentUserName = ''.obs;
  final RxString currentUserId = ''.obs;
  final userStream = FirebaseFirestore.instance.collection('users').snapshots();

  final UserService userService = UserService();

  @override
  void onInit() {
    super.onInit();
    currentUserId.value = userService.getCurrentUserId();
    fetchCurrentUserName();
  }

  void fetchCurrentUserName() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId.value)
          .get();
      if (doc.exists) {
        currentUserName.value = doc['name'] ?? '';
      }
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user name');
    }
  }
}
