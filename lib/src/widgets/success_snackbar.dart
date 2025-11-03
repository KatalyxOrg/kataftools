import 'package:flutter/material.dart';

class SuccessSnackbar {
  const SuccessSnackbar({required this.message});

  final String message;

  static show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green[50],
        content: Text(message, style: TextStyle(color: Colors.green[900])),
      ),
    );
  }
}
