import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/importantdata/user_id.dart';
import 'chat_person_item.dart';

class UsersOnChatPage extends StatefulWidget {
  const UsersOnChatPage({super.key});

  @override
  State<UsersOnChatPage> createState() => _UsersOnChatPageState();
}

class _UsersOnChatPageState extends State<UsersOnChatPage> {
  String _currentUserName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    final userService = UserService();
    final String userId = userService.getCurrentUserId();

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          _currentUserName = userDoc['name'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: ${e.toString()}')),
      );
    }
  }

  final Stream<QuerySnapshot<Map<String, dynamic>>> _allUsersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_currentUserName),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ChatPerson(
          usersStream: _allUsersStream,
          currentUserId: _userService.getCurrentUserId(),
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
                currentUserId: currentUserId,
                chatPartnerId: userDoc.id,
                userName: userName,
                profileImageUrl: profileImageUrl,
              ),
            );
          },
        );
      },
    );
  }
}
