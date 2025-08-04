import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentController extends GetxController {
  final TextEditingController commentController = TextEditingController();
  final String postId;
  CommentController(this.postId);

  var comments = <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    listenToComments();
  }

  void sendComment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || commentController.text.trim().isEmpty) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) return;

    final userData = userDoc.data() as Map<String, dynamic>;
    final String name = userData['name'] ?? 'Anonymous';
    final String profileImage = userData['profile_image'] ?? '';

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
          'text': commentController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid,
          'name': name,
          'profile_image': profileImage, // Store actual value
        });

    commentController.clear();
  }

  void listenToComments() {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
          comments.value = snapshot.docs;
        });
  }

  Widget buildCommentAvatar(String imageUrl) {
    if (imageUrl.isEmpty) {
      return CircleAvatar(radius: 20, child: Icon(Icons.person));
    }

    if (imageUrl.startsWith('http')) {
      return CircleAvatar(radius: 20, backgroundImage: AssetImage(imageUrl));
    }

    return CircleAvatar(radius: 20, backgroundImage: AssetImage(imageUrl));
  }
}
