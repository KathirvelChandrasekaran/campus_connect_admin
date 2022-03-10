import 'package:campus_connect_admin/widgets/rounded_button_widget.dart';
import 'package:campus_connect_admin/utils/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase/supabase.dart';
import 'package:campus_connect_admin/utils/constants.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  late final TextEditingController _emailController;

  bool _isEmailValid(String? email) {
    return email == 'kathir98vel@gmail.com';
  }

  Future<void> _signIn() async {
    if (_isEmailValid(_emailController.text)) {
      setState(() {
        _isLoading = true;
      });
      final response = await supabase.auth.signIn(
          email: _emailController.text,
          options: AuthOptions(
              redirectTo: kIsWeb
                  ? null
                  : 'io.supabase.campusconnectadmin://login-callback/'));
      final error = response.error;
      if (error != null) {
        context.showErrorSnackBar(message: error.message);
      } else {
        context.showSnackBar(message: 'Check your email for login link!');
        _emailController.clear();
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      context.showSnackBar(message: 'Not a valid email address');
    }
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'.toUpperCase()),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final theme = ref.watch(themingNotifer);
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              children: [
                Image.asset('assets/Email.png'),
                TextFormField(
                  cursorColor: theme.darkTheme
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      FluentIcons.mail_16_filled,
                      color: theme.darkTheme
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: theme.darkTheme
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: theme.darkTheme
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      ),
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: theme.darkTheme ? Colors.white : Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                      color: theme.darkTheme ? Colors.white : Colors.black),
                ),
                const SizedBox(height: 20),
                RoundedButtonWidget(
                  buttonText: "Send Login Link",
                  width: MediaQuery.of(context).size.width * 0.80,
                  onpressed: _signIn,
                ),
                const SizedBox(height: 30),
                _emailController.text.isNotEmpty
                    ? Container()
                    : Text(
                        'Please enter your email to get login link',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                const SizedBox(height: 20),
                _isLoading
                    ? LinearProgressIndicator(
                        color: theme.darkTheme
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
