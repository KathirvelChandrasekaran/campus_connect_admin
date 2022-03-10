import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: const Color(0XFFE3F6FD),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: const Color(0XFFE8DEF5),
    onSecondary: const Color(0XFFF1F1F1),
    onPrimary: Colors.black,
    error: const Color(0XFFE83A14),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
    ),
    centerTitle: true,
    iconTheme: IconThemeData(
      color: Color(0XFFE3F6FD),
    ),
  ),
  primaryTextTheme: Typography(platform: TargetPlatform.android).black,
  textTheme: Typography(platform: TargetPlatform.android).black,
);

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0XFF1E1E1E),
  primaryColor: const Color(0XFFE3F6FD),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: const Color(0XFFE8DEF5),
    onSecondary: const Color(0XFFF1F1F1),
    onPrimary: Colors.black,
    error: const Color(0XFFE83A14),
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0XFF1E1E1E),
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Color(0XFFF1F1F1),
      fontSize: 20,
    ),
    centerTitle: true,
    iconTheme: IconThemeData(
      color: Color(0XFFE3F6FD),
    ),
  ),
  primaryTextTheme: Typography(platform: TargetPlatform.android).white,
  textTheme: Typography(platform: TargetPlatform.android).white,
);

class ThemeNotifer extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _prefs;
  bool? _dakTheme;

  ThemeNotifer() {
    _dakTheme = true;
    _loadFromPreference();
  }

  bool get darkTheme => _dakTheme!;

  toggleTheme() {
    _dakTheme = !_dakTheme!;
    _saveToPreference();
    notifyListeners();
  }

  _initiatePreference() async {
    // ignore: prefer_conditional_assignment, unnecessary_null_comparison
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPreference() async {
    await _initiatePreference();
    _dakTheme = _prefs!.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPreference() async {
    await _initiatePreference();
    _prefs!.setBool(key, _dakTheme!);
  }
}

final themingNotifer = ChangeNotifierProvider(
  (ref) => ThemeNotifer(),
);
