import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bottom_navigation_bar/bottom_nav_bar_controller.dart';
import 'bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'loginAndSignUp/auth_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: AuthCheck(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final BottomNavBarController navBarController = Get.put(
      BottomNavBarController(),
    );
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        body: navBarController.pages[navBarController.selectedIndex.value],
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: navBarController.selectedIndex.value,
          onItemTapped: navBarController.changeTabIndex,
        ),
      );
    });
  }
}
