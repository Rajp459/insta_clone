import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'comment_controller.dart';

class CommentPage extends StatelessWidget {
  const CommentPage({super.key, required this.postId});
  final String postId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentController(postId));
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
              Obx(() {
                if (controller.comments.isEmpty) {
                  return const Center(child: Text("No comments yet"));
                }

                return Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: controller.comments.length,
                    itemBuilder: (context, index) {
                      final data =
                          controller.comments[index].data()
                              as Map<String, dynamic>;
                      return ListTile(
                        leading: controller.buildCommentAvatar(
                          data['profile_image'] ?? '',
                        ),
                        title: Text(
                          data['name'] ?? 'Anonymous',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          data['text'] ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    },
                  ),
                );
              }),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.commentController,
                      decoration: InputDecoration(
                        labelText: 'Start the conversation...',
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.sendComment,
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
