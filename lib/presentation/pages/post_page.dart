import 'package:flutter/material.dart';
import 'package:insta_clone/application/controllers/post_page_controller.dart';
import 'package:get/get.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Post")),
      body: GetBuilder(
        init: PostPageController(),
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      controller.currentProfileImage.value,
                    ),
                  ),
                  title: Text(
                    controller.currentUserName.value,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("Posting as"),
                ),
                const SizedBox(height: 20),

                // Post fields
                _buildTextField(
                  controller.postImageController,
                  'Post Image URL',
                ),
                _buildTextField(controller.captionController, 'Caption'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.createPost,
                  child: const Text('Create Post'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
