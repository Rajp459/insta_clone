import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/importantdata/user_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../presentation/pages/ChatPage/chat_person_item.dart';

class ChatDetailController extends GetxController {
  final TextEditingController messageController = TextEditingController();

  final String chatPartnerId;
  final String chatPartnerName;
  final UserService userService = UserService(); // FIXED
  late final String currentUserId;
  late String roomId;

  var isInitialized = false.obs;

  ChatDetailController({
    required this.chatPartnerId,
    required this.chatPartnerName,
  });

  @override
  void onInit() {
    super.onInit();
    initializeController();
  }

  Future<void> initializeController() async {
    chatPartnerId;
    chatPartnerName;
    try {
      currentUserId = userService.getCurrentUserId();
      if (currentUserId.isEmpty) {
        throw Exception("Current user ID not available");
      }

      roomId = generateChatRoomId(currentUserId, chatPartnerId);

      await resetUnreadCount();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        markMessagesAsSeen(roomId);
      });

      isInitialized.value = true;
    } catch (e) {
      Get.snackbar('Error', '$e', colorText: Colors.blue);
    }
  }

  Future<void> resetUnreadCount() async {
    try {
      final chatRoomRef = FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(roomId);

      await chatRoomRef.set({
        'unreadCounts': {currentUserId: 0},
      }, SetOptions(merge: true));
      update();
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
  }

  Future<void> markMessagesAsSeen(String roomId) async {
    try {
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
      update();
    } catch (e) {
      //Get.snackbar('Error', '${e}');
    }
  }

  String generateChatRoomId(String user1, String user2) {
    return ChatHelper.generateChatRoomId(user1, user2);
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  Future<void> sendMessages() async {
    if (messageController.text.trim().isEmpty) return;
    if (!isInitialized.value) {
      await initializeController();
      if (!isInitialized.value) return;
    }

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
        final receiverCount = (unreadCounts[chatPartnerId] ?? 0) + 1;
        unreadCounts[chatPartnerId] = receiverCount;
        unreadCounts.putIfAbsent(currentUserId, () => 0);

        final messageReference = roomRef.collection('messages').doc();
        transaction.set(messageReference, {
          'senderId': currentUserId,
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
          'seen': false,
          'status': 'sent',
        });

        transaction.set(roomRef, {
          'participants': {currentUserId: true, chatPartnerId: true},
          'unreadCounts': unreadCounts,
          'lastMessage': message,
          'lastMessageTime': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });
      update();
      messageController.clear();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send message',
        colorText: Colors.black,
        backgroundColor: Colors.red.shade100,
      );
    }
  }
}
