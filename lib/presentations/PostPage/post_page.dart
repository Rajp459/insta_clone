import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../importantdata/user_id.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // Keep only necessary controllers
  final TextEditingController _postImageController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Store user data
  String _currentUserName = '';
  String _currentProfileImage = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch current user's data from Firestore
  void _fetchUserData() async {
    final userService = UserService();
    final String userId = userService.getCurrentUserId();

    try {
      await _firestore.collection('users').doc(userId).get();
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          _currentUserName = userDoc['name']; // Field name in your document
          _currentProfileImage = userDoc['profile_image']; // Field name in your document
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: ${e.toString()}')),
      );
    }
  }

  void _createPost() async {
    final userService = UserService();
    final String postImage = _postImageController.text.trim();
    final String caption = _captionController.text.trim();

    if (postImage.isEmpty || caption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      final String userId = userService.getCurrentUserId();
      // Store in global posts collection
      await _firestore.collection('posts').add({
        'userId': userId,
        'name': _currentUserName,
        'profile_image': _currentProfileImage,
        'post_image': postImage,
        'caption': caption,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _postImageController.clear();
      _captionController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Post")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Display user info
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(_currentProfileImage),
              ),
              title: Text(
                _currentUserName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Posting as"),
            ),
            const SizedBox(height: 20),

            // Post fields
            _buildTextField(_postImageController, 'Post Image URL'),
            _buildTextField(_captionController, 'Caption'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createPost,
              child: const Text('Create Post'),
            ),
          ],
        ),
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