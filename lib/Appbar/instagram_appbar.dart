import 'package:flutter/material.dart';
class InstagramAppbar extends StatelessWidget implements PreferredSizeWidget {
  const InstagramAppbar({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top:25.0),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 0.5
              )
            )
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            leadingWidth: 130,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Image.asset(
                'images/logos/instaAppbarLogo.png',
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            actions: [
              IconButton(
                onPressed: (){}, icon: Icon(Icons.favorite_border_outlined),
              ),
              IconButton(
                  onPressed: (){}, icon: Icon(Icons.message_outlined)
              )
            ],
          ),
        ),
      ),
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
