import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:app_links/app_links.dart';
import 'package:insta_clone/core/service/auto_logout_wrapper.dart';
import 'package:insta_clone/presentation/pages/account_page.dart';
import 'package:insta_clone/presentation/pages/post_page.dart';
import 'package:insta_clone/presentation/pages/reel_page.dart';
import 'package:insta_clone/presentation/pages/search_page.dart';
import 'core/service/auto_logout.dart';
import 'localization.dart';
import 'loginAndSignUp/auth_check.dart';
import 'package:flutter_localization/flutter_localization.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, _) => const AuthCheck()),
    GoRoute(path: '/details', builder: (_, _) => SearchPage()),
    GoRoute(path: '/profile', builder: (_, _) => AccountPage()),
    GoRoute(path: '/post', builder: (_, _) => PostPage()),
    GoRoute(path: '/reel', builder: (_, _) => ReelsPage()),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AutoLogout());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initDeepLinks();
    });
    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('hi', AppLocale.HI),
        const MapLocale('ja', AppLocale.JA),
      ],
      initLanguageCode: 'ja',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  void _initDeepLinks() async {
    _appLinks = AppLinks();
    try {
      final Uri? initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _handleIncomingLink(initialLink);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting initial link: $e');
      }
    }

    _sub = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _handleIncomingLink(uri);
      },
      onError: (err) {
        if (kDebugMode) {
          print("Deep link stream error: $err");
        }
      },
    );
  }

  void _handleIncomingLink(Uri uri) {
    if (kDebugMode) {
      print("Incoming URI: $uri");
      print("Scheme: ${uri.scheme}");
      print("Host: ${uri.host}");
      print("PathSegments: ${uri.pathSegments}");
    }

    String routePath = '/';

    if (uri.scheme.startsWith('http')) {
      // Universal link: strip domain and keep path
      if (uri.host == 'www.myapp.com' || uri.host == 'myapp.com') {
        if (uri.pathSegments.isNotEmpty) {
          routePath = '/${uri.pathSegments.join('/')}';
        }
      }
    } else if (uri.scheme == 'myapp') {
      // Custom scheme: use host or path segments
      if (uri.pathSegments.isNotEmpty) {
        routePath = '/${uri.pathSegments.join('/')}';
      } else if (uri.host.isNotEmpty) {
        routePath = '/${uri.host}';
      }
    }

    if (kDebugMode) {
      print("Navigating to: $routePath");
    }

    try {
      _router.push(routePath, extra: uri.queryParameters);
    } catch (e) {
      _router.go('/');
      Get.snackbar('Invalid Link', 'Unsupported deep link: $uri');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<AutoLogout>().startTimer();
    return AutoLogoutWrapper(
      child: MaterialApp.router(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        routerConfig: _router,
        locale: localization.currentLocale,
        supportedLocales: localization.supportedLocales,
        localizationsDelegates: localization.localizationsDelegates,
      ),
    );
  }
}
