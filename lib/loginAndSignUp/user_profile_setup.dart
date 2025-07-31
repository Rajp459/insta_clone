import 'package:flutter/material.dart';
import 'package:insta_clone/loginAndSignUp/profile_setup_controller.dart';
import 'package:get/get.dart';

class UserProfileSetup extends StatelessWidget {
  UserProfileSetup({super.key});

  final ProfileSetupController controller = Get.put(ProfileSetupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(controller.nameController, 'Your Name'),
            _buildTextField(
              controller.profileImageController,
              'Profile Image URL',
            ),
            _buildTextField(controller.userNameController, 'username'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.createUser,
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
