import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'comment_page.dart';

class PostSection extends StatefulWidget {
  const PostSection({super.key});

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No posts yet'));
        }

        final posts = snapshot.data!.docs;
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: posts.map((doc) {
            final post = doc.data() as Map<String, dynamic>;
            final postId = doc.id;
            return _PostItem(
              post: post,
              postId: postId,
              userId: userId,
            );
          }).toList(),
        );
      },
    );
  }
}

class _PostItem extends StatefulWidget {
  final Map<String, dynamic> post;
  final String postId;
  final String userId;

  const _PostItem({
    required this.post,
    required this.postId,
    required this.userId,
  });

  @override
  State<_PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<_PostItem> {
  late bool _isLiked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _isLiked = false;
    _likeCount = 0;
    _loadLikeStatus();
  }

  void _loadLikeStatus() async {
    final likeDoc = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('likes')
        .doc(widget.userId)
        .get();

    final likesSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('likes')
        .get();

    if (mounted) {
      setState(() {
        _isLiked = likeDoc.exists;
        _likeCount = likesSnapshot.docs.length;
      });
    }
  }

  void _toggleLike() async {
    final likeRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('likes')
        .doc(widget.userId);

    if (_isLiked) {
      await likeRef.delete();
      setState(() {
        _isLiked = false;
        _likeCount -= 1;
      });
    } else {
      await likeRef.set({'likedAt': FieldValue.serverTimestamp()});
      setState(() {
        _isLiked = true;
        _likeCount += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage:
                AssetImage(widget.post['profile_image'] ?? ''),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.post['timestamp'] != null
                          ? DateFormat('dd MMM yyyy, hh:mm a')
                          .format(widget.post['timestamp'].toDate())
                          : '',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.more_vert)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _buildPostImage(widget.post['post_image']),
        const SizedBox(height: 2),
        Row(
          children: [
            IconButton(
              onPressed: _toggleLike,
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_outline,
                color: _isLiked ? Colors.red : Colors.black,
              ),
            ),
            Text(_likeCount.toString()),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  builder: (context) => CommentPage(postId: widget.postId),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text("0");
                return Text(snapshot.data!.docs.length.toString());
              },
            ),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.send)),
            const Text('10'),
            const Spacer(),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.save_alt)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(widget.post['caption'] ?? ''),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPostImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        height: 300,
        color: Colors.grey[200],
        child: const Center(child: Icon(Icons.broken_image)),
      );
    }

    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 400,
      errorBuilder: (context, error, stackTrace) =>
      const Icon(Icons.broken_image),
    );
  }
}