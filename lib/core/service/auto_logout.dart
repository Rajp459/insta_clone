import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/loginAndSignUp/login_page.dart';

class AutoLogout extends GetxController {
  Timer? _inactivityTimer;
  final Duration _inactivityDuration = Duration(seconds: 50);

  void startTimer() {
    _startInactivityTimer();
  }

  void resetInactivityTimer() {
    _startInactivityTimer();
  }

  void stopTimer() {
    _inactivityTimer?.cancel();
  }

  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_inactivityDuration, _performAutoLogout);
  }

  void _performAutoLogout() {
    print("Auto logout triggered due to inactivity.");
    FirebaseAuth.instance.signOut();
    Get.offAll(LoginPage());
  }
}
