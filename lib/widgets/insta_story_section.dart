import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_clone/application/controllers/story_controller.dart';

class InstaStorySection extends StatelessWidget {
  const InstaStorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: GetBuilder<StoryController>(
        init: StoryController(),
        builder: (controller) {
          if (controller.allUsers.isEmpty) {}
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.allUsers.length,
            itemBuilder: (context, index) {
              final user = controller.allUsers[index];
              final String name = user['name'] ?? 'unknown';
              final String imageUrl = user['profile_image'] ?? '';

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFF58529),
                              Color(0xFFDD2A7B),
                              Color(0xFF8134AF),
                              Color(0xFF515BD4),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: imageUrl.isNotEmpty
                                ? AssetImage(imageUrl)
                                : AssetImage('assets/users/default.png'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      name,
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
