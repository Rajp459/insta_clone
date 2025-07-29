import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReelsPage extends StatelessWidget {
  const ReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future signOut ()async{
      await FirebaseAuth.instance.signOut();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: signOut, icon: Icon(Icons.arrow_left)),
        Center(child: Text('Scroll Reels', style: TextStyle(fontSize: 20))),
      ],
    );
  }
}
