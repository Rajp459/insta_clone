import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  var likesMap = <String, bool>{}.obs;
  var likeCounts = <String, int>{}.obs;
  var commentCounts = <String, int>{}.obs;

  Future<void> loadLikeStatus(String postId, String userId) async {
    final likeDoc = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userId)
        .get();
    likesMap[postId] = likeDoc.exists;

    final likesSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get();

    likesMap[postId] = likeDoc.exists;
    likeCounts[postId] = likesSnapshot.docs.length;
  }

  Future<void> toggleLike(String postId, String userId) async {
    final likeRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userId);

    if (likesMap[postId] == true) {
      await likeRef.delete();
      likesMap[postId] = false;
      likeCounts[postId] = (likeCounts[postId] ?? 1) - 1;
    } else {
      await likeRef.set({'likedAt': FieldValue.serverTimestamp()});
      likesMap[postId] = true;
      likeCounts[postId] = (likeCounts[postId] ?? 0) + 1;
    }
  }

  void setupCommentCountStream(String postId) {
    _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .listen((snapshot) {
          commentCounts[postId] = snapshot.docs.length;
        });
  }
}
