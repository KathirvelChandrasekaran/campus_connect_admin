import 'package:campus_connect_admin/screens/home_screen.dart';
import 'package:campus_connect_admin/screens/login_screen.dart';
import 'package:campus_connect_admin/screens/settings_screen.dart';
import 'package:campus_connect_admin/screens/splash_screen.dart';
import 'package:campus_connect_admin/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CampusConnectAdmin extends StatelessWidget {
  const CampusConnectAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = ref.watch(themingNotifer);
        return MaterialApp(
          title: 'Material App',
          debugShowCheckedModeBanner: false,
          theme: theme.darkTheme ? darkTheme : lightTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const HomeScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
        );
      },
    );
  }
}
