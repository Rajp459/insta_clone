import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../application/controllers/bottom_nav_bar_controller.dart';
import 'custom_bottom_navigation_bar.dart';

class NavigationPage extends StatelessWidget {
  final String title;
  const NavigationPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BottomNavBarController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: controller.pages[controller.selectedIndex],
          bottomNavigationBar: CustomBottomNavigationBar(
            selectedIndex: controller.selectedIndex,
            onItemTapped: controller.changeTabIndex,
          ),
        );
      },
    );
  }
}
