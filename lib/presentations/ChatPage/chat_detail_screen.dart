import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/importantdata/user_id.dart';
import 'package:intl/intl.dart';

import 'chat_person_item.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatPartnerId;
  final String chatPartnerName;
  final UserService userService;

  const ChatDetailScreen({
    super.key,
    required this.chatPartnerId,
    required this.chatPartnerName,
    required this.userService,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController messageController = TextEditingController();
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    _resetUnreadCount();
    currentUserId = widget.userService.getCurrentUserId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final roomId = generateChatRoomId(currentUserId, widget.chatPartnerId);
      markMessagesAsSeen(roomId);
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void _resetUnreadCount() async {
    final userService = widget.userService;
    final currentUserId = userService.getCurrentUserId();
    final roomId = ChatHelper.generateChatRoomId(
      currentUserId,
      widget.chatPartnerId,
    );

    final chatRoomRef = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId);

    // Update unread count for current user to 0
    await chatRoomRef.set({
      'unreadCounts': {currentUserId: 0},
    }, SetOptions(merge: true));
  }

  void markMessagesAsSeen(String roomId) async {
    final roomId = ChatHelper.generateChatRoomId(
      currentUserId,
      widget.chatPartnerId,
    );
    final roomRef = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId);

    final batch = FirebaseFirestore.instance.batch();

    final unreadMessages = await roomRef
        .collection('messages')
        .where('seen', isEqualTo: false)
        .where('senderId', isNotEqualTo: currentUserId)
        .get();

    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {'seen': true, 'status': 'seen'});
    }

    batch.update(roomRef, {'unreadCounts.$currentUserId': 0});

    await batch.commit();
  }

  String generateChatRoomId(String user1, String user2) {
    return ChatHelper.generateChatRoomId(user1, user2);
  }

  Future<void> sendMessages() async {
    if (messageController.text.trim().isEmpty) return;
    if (currentUserId.isEmpty) return;

    final roomId = ChatHelper.generateChatRoomId(
      currentUserId,
      widget.chatPartnerId,
    );
    final message = messageController.text.trim();
    final roomRef = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final roomDoc = await transaction.get(roomRef);
        final Map<String, dynamic> unreadCounts = {};
        if (roomDoc.exists) {
          unreadCounts.addAll(roomDoc['unreadCounts'] ?? {});
        }
        final receiverCount = (unreadCounts[widget.chatPartnerId] ?? 0) + 1;
        unreadCounts[widget.chatPartnerId] = receiverCount;
        unreadCounts.putIfAbsent(currentUserId, () => 0);
        transaction.set(roomRef, {
          'unreadCounts': unreadCounts,
        }, SetOptions(merge: true));

        final messageReference = roomRef.collection('messages').doc();
        transaction.set(messageReference, {
          'senderId': currentUserId,
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
          'seen': false,
          'status': 'sent',
        });
      });
      messageController.clear();
    } catch (e) {
      print('error sending message ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('User not authenticated')),
      );
    }

    final roomId = generateChatRoomId(currentUserId, widget.chatPartnerId);
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatPartnerName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc(roomId)
                  .collection('messages')
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
                  return const Center(child: Text('No messages yet'));
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].data() as Map<String, dynamic>;
                    final isMe = msg['senderId'] == currentUserId;
                    if (!isMe && msg['status'] == 'sent') {
                      FirebaseFirestore.instance
                          .collection('chatRooms')
                          .doc(roomId)
                          .collection('messages')
                          .doc(messages[index].id)
                          .update({'status': 'delivered'});
                    }

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[100] : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isMe
                                ? const Radius.circular(12)
                                : Radius.zero,
                            bottomRight: isMe
                                ? Radius.zero
                                : const Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg['message'] ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  msg['timestamp'] != null
                                      ? DateFormat('hh:mm a').format(
                                          (msg['timestamp'] as Timestamp)
                                              .toDate(),
                                        )
                                      : '...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                if (isMe) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    msg['status'] == 'seen'
                                        ? Icons.done_all
                                        : msg['status'] == 'delivered'
                                        ? Icons.done_all
                                        : Icons.check,
                                    size: 16,
                                    color: msg['status'] == 'seen'
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: sendMessages,
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
