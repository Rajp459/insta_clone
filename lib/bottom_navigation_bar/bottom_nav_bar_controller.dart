import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../presentations/AccountPages/account_page.dart';
import '../presentations/HomePage/home_page.dart';
import '../presentations/PostPage/post_page.dart';
import '../presentations/ReelPage/reel_page.dart';
import '../presentations/SearchPage/search_page.dart';

class BottomNavBarController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  List<Widget> get pages => [
    HomePage(),
    SearchPage(),
    PostPage(),
    ReelsPage(),
    AccountPage(),
  ];
}
