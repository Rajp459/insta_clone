import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../importantdata/user_id.dart';
import 'chat_detail_screen.dart';
import 'package:get/get.dart';

class ChatPersonItem extends StatelessWidget {
  final String chatPartnerId;
  final String userName;
  final String profileImageUrl;
  final UserService userService;

  const ChatPersonItem({
    super.key,
    required this.chatPartnerId,
    required this.userName,
    required this.profileImageUrl,
    required this.userService,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = userService.getCurrentUserId();
    final roomId = ChatHelper.generateChatRoomId(currentUserId, chatPartnerId);
    final roomRef = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId);

    return StreamBuilder<DocumentSnapshot>(
      stream: roomRef.snapshots(),
      builder: (context, snapshot) {
        int unreadCount = 0;

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final unreadCounts = data['unreadCounts'] as Map<String, dynamic>?;
          unreadCount = unreadCounts?[currentUserId] as int? ?? 0;
        }

        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: profileImageUrl.isNotEmpty
                ? AssetImage(profileImageUrl)
                : const AssetImage('assets/default_avatar.png')
                      as ImageProvider,
          ),
          title: Text(userName),
          trailing: unreadCount > 0
              ? Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              : null,
          onTap: () => Get.to(
            () => ChatDetailScreen(
              chatPartnerId: chatPartnerId,
              chatPartnerName: userName,
            ),
          ),
        );
      },
    );
  }
}

class ChatHelper {
  static String generateChatRoomId(String user1, String user2) {
    final ids = [user1, user2]..sort();
    return '${ids[0]}_${ids[1]}';
  }
}
