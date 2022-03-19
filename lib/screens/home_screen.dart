import 'package:campus_connect_admin/screens/news_feed_screen.dart';
import 'package:campus_connect_admin/screens/profile_screen.dart';
import 'package:campus_connect_admin/screens/search_screen.dart';
import 'package:campus_connect_admin/utils/theme.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _currentIndex = 0;
  final List<Widget> _screens = [
    const NewsFeedScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: ((context, ref, child) {
        final theme = ref.watch(themingNotifer);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Campus Connect'),
            centerTitle: false,
            actions: [
              IconButton(
                icon: Icon(
                  FluentIcons.alert_24_filled,
                  color: theme.darkTheme
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  FluentIcons.settings_24_regular,
                  color: theme.darkTheme
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
          ),
          body: _screens.elementAt(_currentIndex),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            unselectedItemColor:
                theme.darkTheme ? Theme.of(context).primaryColor : Colors.black,
            items: [
              SalomonBottomBarItem(
                icon: const Icon(FluentIcons.broad_activity_feed_24_regular),
                title: const Text("Activity"),
                selectedColor: Colors.purple,
              ),
              SalomonBottomBarItem(
                icon: const Icon(FluentIcons.search_square_24_filled),
                title: const Text("Search"),
                selectedColor: Colors.blue,
              ),
              SalomonBottomBarItem(
                icon: const Icon(
                  FluentIcons.person_32_regular,
                ),
                title: const Text("Profile"),
                selectedColor: Colors.teal,
              ),
            ],
          ),
        );
      }),
    );
  }
}
