import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auto_logout.dart';

class AutoLogoutWrapper extends StatelessWidget {
  final Widget child;

  const AutoLogoutWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final AutoLogout autoLogout = Get.find();

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => autoLogout.resetInactivityTimer(),
      onPointerMove: (_) => autoLogout.resetInactivityTimer(),
      onPointerHover: (_) => autoLogout.resetInactivityTimer(),
      onPointerSignal: (_) => autoLogout.resetInactivityTimer(),
      child: child,
    );
  }
}
