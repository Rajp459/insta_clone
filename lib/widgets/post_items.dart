import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../application/controllers/post_controller.dart';
import 'package:intl/intl.dart';

import '../presentation/pages/commentPages/comment_page.dart';

class PostItem extends StatefulWidget {
  final Map<String, dynamic> post;
  final String postId;

  const PostItem({super.key, required this.post, required this.postId});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final postController = Get.find<PostController>();

  @override
  void initState() {
    super.initState();
    postController.loadLikeStatus(widget.postId, postController.userId);
    postController.setupCommentCountStream(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final postId = widget.postId;
    // final postController = Get.find<PostController>();
    // postController.loadLikeStatus(postId, postController.userId);
    // postController.setupCommentCountStream(postId);

    return GetBuilder(
      init: PostController(),
      builder: (postController) {
        final isLiked = postController.likesMap[postId] ?? false;
        final likeCount = postController.likeCounts[postId] ?? 0;
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
                    backgroundImage: AssetImage(post['profile_image'] ?? ''),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          post['timestamp'] != null
                              ? DateFormat(
                                  'dd MMM yyyy, hh:mm a',
                                ).format(post['timestamp'].toDate())
                              : '',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildPostImage(post['post_image']),
            const SizedBox(height: 2),
            Row(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.black,
                      ),
                      onPressed: () {
                        postController.toggleLike(
                          postId,
                          postController.userId,
                        );
                      },
                    ),
                    Text('$likeCount'),
                  ],
                ),

                IconButton(
                  onPressed: () {
                    Get.bottomSheet(
                      CommentPage(postId: postId),
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                ),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .collection('comments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text("0");
                    return Text(snapshot.data!.docs.length.toString());
                  },
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
                const Text('10'),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.save_alt)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(post['caption'] ?? ''),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
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
