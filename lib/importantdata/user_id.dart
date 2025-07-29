import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  String getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not authenticated");
    return user.uid;
  }

  DocumentReference getUserDocument() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(getCurrentUserId());
  }

  DocumentReference getUserDocumentById(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid);
  }
}