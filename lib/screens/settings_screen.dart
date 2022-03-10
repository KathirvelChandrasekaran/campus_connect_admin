import 'package:campus_connect_admin/utils/constants.dart';
import 'package:campus_connect_admin/utils/theme.dart';
import 'package:campus_connect_admin/widgets/rounded_button_widget.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool dark = false;
  Future<void> _signOut() async {
    final response = await supabase.auth.signOut();
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    }
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final themingListener = ref.watch(themingNotifer);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            leading: IconButton(
              icon: const Icon(FluentIcons.arrow_left_24_filled),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Theme settings',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).primaryColor,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Change theme',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: !dark
                                  ? Colors.black
                                  : Theme.of(context).colorScheme.secondary,
                            ),
                            child: !dark
                                ? const Icon(
                                    FluentIcons.lightbulb_filament_16_filled,
                                    color: Colors.yellow,
                                    size: 56,
                                  )
                                : const Icon(
                                    FluentIcons.dark_theme_24_regular,
                                    color: Colors.black,
                                    size: 56,
                                  ),
                          ),
                          Switch(
                            value: dark,
                            onChanged: (value) {
                              setState(() {
                                themingListener.toggleTheme();
                                dark = themingListener.darkTheme;
                              });
                            },
                            activeTrackColor: Colors.black,
                            activeColor: Colors.teal,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Account settings',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RoundedButtonWidget(
                    buttonText: "Logout",
                    width: MediaQuery.of(context).size.width * 0.80,
                    onpressed: _signOut),
              ),
            ],
          ),
        );
      },
    );
  }
}
