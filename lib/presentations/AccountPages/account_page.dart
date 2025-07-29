import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text("User data not found");
                  }

                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Text(
                    "${userData['user_name']}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                },
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
