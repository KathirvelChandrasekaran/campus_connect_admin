import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        shape: ShapeBorder.lerp(
          const RoundedRectangleBorder(),
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          0.5,
        ),
        backgroundColor: const Color(0XFFE3F6FD),
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
      ),
    );
  }

  void showErrorSnackBar({
    required String message,
  }) {
    showSnackBar(
      message: message,
    );
  }
}
