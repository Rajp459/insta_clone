import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileSetup extends StatefulWidget {
  const UserProfileSetup({super.key});

  @override
  State<UserProfileSetup> createState() => _UserProfileSetupState();
}

class _UserProfileSetupState extends State<UserProfileSetup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _profileImageController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void _createUser() async {
    final String name = _nameController.text.trim();
    final String username = _userNameController.text.trim();
    final String profileImage = _profileImageController.text.trim();
    if (name.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill name and username')));
      return;
    }
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await _firestore.collection('users').doc(uid).set({

        'name': name,
        'profile_image': profileImage,
        'user_name': username,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _nameController.clear();
      _userNameController.clear();
      _profileImageController.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: '')),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(_nameController, 'Your Name'),
            _buildTextField(_profileImageController, 'Profile Image URL'),
            _buildTextField(_userNameController, 'username'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createUser,
              child: const Text('Create Profile'),
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

// MaterialPageRoute(builder: (context) => const MyHomePage(title: '')),
