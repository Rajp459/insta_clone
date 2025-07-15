import 'package:flutter/material.dart';

class InstaStorySection extends StatelessWidget {

  final List<Map<String, String>> stories = [
    {'name': 'Your Story', 'image': 'images/users/office-man.png'},
    {'name': 'rahul', 'image': 'images/users/man.png'},
    {'name': 'rohan', 'image': 'images/users/man.png'},
    {'name': 'shyam', 'image': 'images/users/man.png'},
    {'name': 'kishan', 'image': 'images/users/man.png'},
    {'name': 'rahul', 'image': 'images/users/man.png'},
    {'name': 'rohan', 'image': 'images/users/man.png'},
    {'name': 'shyam', 'image': 'images/users/man.png'},
    {'name': 'kishan', 'image': 'images/users/man.png'},
  ];

  InstaStorySection({super.key});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: stories.length,
          itemBuilder: (context, index){
            final story = stories[index];
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
                          gradient: LinearGradient(colors: [
                            Color(0xFFF58529),
                            Color(0xFFDD2A7B),
                            Color(0xFF8134AF),
                            Color(0xFF515BD4),
                          ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,)
                      ),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(story['image']!),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2,),
                  Text(
                    story['name']!,
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}
