import 'package:flutter/material.dart';

class AwesomeSnackbar {
  static void show(BuildContext context, String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white), 
            const SizedBox(width: 8.0),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        elevation: 6.0, 
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), 
        ),
        duration: const  Duration(seconds: 4), 
      ),
    );
  }
}
