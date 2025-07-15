import 'package:flutter/material.dart';

class PostSection extends StatelessWidget {
  PostSection({super.key});

  final List<Map<String, String>> posts = [
    {
      'name': 'Shiva',
      'profile_image': 'images/users/office-man.png',
      'post_image': 'images/posts/post1.jpeg',
      'caption': 'This is my new post',
      'time' : '2 hours ago'
    },
    {
      'name': 'Rahul',
      'profile_image': 'images/users/man.png',
      'post_image': 'images/posts/post2.jpeg',
      'caption': 'This is my new post',
      'time' : '3 hours ago'
    },
    {
      'name': 'Rohan',
      'profile_image': 'images/users/man.png',
      'post_image': 'images/posts/post3.jpeg',
      'caption': 'This is my new post',
      'time' : '1 hours ago'
    },
    {
      'name': 'shyam',
      'profile_image': 'images/users/man.png',
      'post_image': 'images/posts/post4.jpeg',
      'caption': 'This is my new post',
      'time' : '7 hours ago'
    },
    {
      'name': 'kishan',
      'profile_image': 'images/users/man.png',
      'post_image': 'images/posts/post1.jpeg',
      'caption': 'This is my new post',
      'time' : '12 hours ago'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: posts.map((post) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage(post['profile_image']!),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['name']!,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(height: 2),
                      Text(
                        post['time']!,
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
                ],
              ),
            ),
            SizedBox(height: 10),
            // Post Image
            Image.asset(
              post['post_image']!,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 2),
            Row(
              children: [
                IconButton(onPressed: (){
                  Colors.red;
                }, icon: Icon(Icons.favorite_outline)),
                Text('50.2K'),
                IconButton(onPressed: (){}, icon: Icon(Icons.chat_bubble_outline)),
                Text('121'),
                IconButton(onPressed: (){}, icon: Icon(Icons.send)),
                Text('10'),
                Spacer(),
                IconButton(onPressed: (){}, icon: Icon(Icons.save_alt)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(post['caption']!),
            ),
            SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }
}
