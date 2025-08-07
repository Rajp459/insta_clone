import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../application/controllers/chat_page_controller.dart';
import '../../../data/importantdata/user_id.dart';
import 'chat_person_item.dart';

class UsersOnChatPage extends StatelessWidget {
  const UsersOnChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatPageController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.currentUserName.value,
            style: TextStyle(backgroundColor: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Obx(
          () => ChatPerson(
            usersStream: controller.userStream,
            currentUserId: controller.currentUserId.value,
          ),
        ),
      ),
    );
  }
}

class ChatPerson extends StatelessWidget {
  const ChatPerson({
    super.key,
    required this.usersStream,
    required this.currentUserId,
  });

  final Stream<QuerySnapshot<Map<String, dynamic>>> usersStream;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          ); // Show loading indicator
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          ); // Display any errors
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users available for chat.'));
        }

        final List<QueryDocumentSnapshot> allUserDocs = snapshot.data!.docs;

        final List<QueryDocumentSnapshot> chatUsers = allUserDocs
            .where((doc) => doc.id != currentUserId)
            .toList();
        if (chatUsers.isEmpty) {
          return const Center(child: Text('No other users to chat with.'));
        }
        return ListView.builder(
          itemCount: chatUsers.length,
          itemBuilder: (context, index) {
            final userDoc = chatUsers[index];
            final userData = userDoc.data() as Map<String, dynamic>;
            final userName = userData['name'] ?? 'No Name';
            final profileImageUrl = userData['profile_image'] ?? '';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: ChatPersonItem(
                chatPartnerId: userDoc.id,
                userName: userName,
                profileImageUrl: profileImageUrl,
                userService: UserService(),
              ),
            );
          },
        );
      },
    );
  }
}
