import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Storage {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final userDoc = await firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data();
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<void> setUser({
    required String name,
    required String profileImage,
    required username,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await firestore.collection('users').doc(uid).set({
      'name': name,
      'profile_image': profileImage,
      'user_name': username,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createPost({
    required String userId,
    required String name,
    required String profileImage,
    required String postImage,
    required String caption,
  }) async {
    try {
      await firestore.collection('posts').add({
        'userId': userId,
        'name': name,
        'profile_image': profileImage,
        'post_image': postImage,
        'caption': caption,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }
}
