import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../presentation/pages/account_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/post_page.dart';
import '../../presentation/pages/reel_page.dart';
import '../../presentation/pages/search_page.dart';

class BottomNavBarController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
    update();
  }

  List<Widget> get pages => [
    HomePage(),
    SearchPage(),
    PostPage(),
    ReelsPage(),
    AccountPage(),
  ];
}
