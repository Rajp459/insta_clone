import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_clone/presentations/ChatPage/chat_page_controller.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatPageController());
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white10,
            border: Border(bottom: BorderSide(color: Colors.black, width: 0.5)),
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            leadingWidth: 130,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Obx(
                () => Text(
                  controller.currentUserName.value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.attach_file_sharp)),
              IconButton(onPressed: () {}, icon: Icon(Icons.add_box_outlined)),
              IconButton(onPressed: () {}, icon: Icon(Icons.menu_outlined)),
            ],
          ),
        ),
      ),
    );
  }
}
