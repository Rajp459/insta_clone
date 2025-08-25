import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:insta_clone/application/controllers/post_page_controller.dart';
import 'package:get/get.dart';
import 'package:insta_clone/localization.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocale.title.getString(context))),
      body: GetBuilder(
        init: PostPageController(),
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      controller.currentProfileImage.value,
                    ),
                  ),
                  title: Text(
                    controller.currentUserName.value,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(AppLocale.subtitle.getString(context)),
                ),
                const SizedBox(height: 20),

                // Post fields
                _buildTextField(
                  controller.postImageController,
                  AppLocale.postImageUrl.getString(context),
                ),
                _buildTextField(
                  controller.captionController,
                  AppLocale.caption.getString(context),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.createPost,
                  child: Text(AppLocale.title.getString(context)),
                ),
                NewWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  NewWidget({super.key});

  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            localization.translate('en');
          },
          child: Text('To English'),
        ),
        ElevatedButton(
          onPressed: () {
            localization.translate('hi');
          },
          child: Text('हिंदी में'),
        ),
        ElevatedButton(
          onPressed: () {
            localization.translate('ja');
          },
          child: Text('日本語で'),
        ),
      ],
    );
  }
}
