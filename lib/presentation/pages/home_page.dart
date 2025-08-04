import 'package:flutter/material.dart';
import '../../widgets/insta_story_section.dart';
import '../../widgets/post_section.dart';
import 'Appbar/instagram_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [const InstagramAppbar(), InstaStorySection(), PostSection()],
      ),
    );
  }
}
