import 'package:campus_connect_admin/utils/theme.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = ref.watch(themingNotifer);

        return Scaffold(
          appBar: AppBar(
            title: const Text('News Feed'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add_students');
            },
            child: Icon(
              FluentIcons.add_24_filled,
              color: theme.darkTheme ? Colors.black : Colors.white,
            ),
          ),
        );
      },
    );
  }
}
