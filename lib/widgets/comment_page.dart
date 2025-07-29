import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentPage extends StatefulWidget {
  final String postId;
  const CommentPage({super.key, required this.postId});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();

  void sendComment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _commentController.text.trim().isEmpty) return;

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
        .doc(widget.postId)
        .collection('comments')
        .add({
          'text': _commentController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid,
          'name': name,
          'profile_image': profileImage, // Store actual value
        });

    _commentController.clear();
  }

  // Helper to build avatar from stored URL
  Widget _buildCommentAvatar(String imageUrl) {
    if (imageUrl.isEmpty) {
      return CircleAvatar(radius: 20, child: Icon(Icons.person));
    }

    if (imageUrl.startsWith('http')) {
      return CircleAvatar(radius: 20, backgroundImage: AssetImage(imageUrl));
    }

    return CircleAvatar(radius: 20, backgroundImage: AssetImage(imageUrl));
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Icon(Icons.horizontal_rule, size: 10),
              Center(
                child: Text(
                  'Comments',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              Divider(),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.postId)
                      .collection('comments')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final comments = snapshot.data!.docs;

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final data =
                            comments[index].data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(
                            data['name'] ?? 'Anonymous', // Use stored name
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            data['text'] ?? '',
                            style: TextStyle(fontSize: 14),
                          ),
                          leading: _buildCommentAvatar(
                            data['profile_image'] ?? '', // Use stored image
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        labelText: 'Start the conversation...',
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(onPressed: sendComment, icon: Icon(Icons.send)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
