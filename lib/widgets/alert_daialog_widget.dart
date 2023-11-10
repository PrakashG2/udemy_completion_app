import 'package:api_prov_try/provider/comments_data_class.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CommentAlertDialog extends StatefulWidget {
  const CommentAlertDialog({super.key});

  @override
  State<CommentAlertDialog> createState() => _CommentAlertDialogState();
}

class _CommentAlertDialogState extends State<CommentAlertDialog> {
  bool checkbox = false;

  @override
  Widget build(BuildContext context) {
        final providerData = Provider.of<CommentsProvider>(context, listen: false);

    return AlertDialog(
      title: const Text("DISCLAIMER"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Make sure not to include any illegal, innapropriate and abusive phrases and follow community guidelines",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Be respectfull with what you are commenting...",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 255, 0, 0),
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: checkbox,
                onChanged: (bool? value) {
                  setState(() {
                    checkbox = !checkbox;
                  });
                },
              ),
              const Text("I Understand"),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        ElevatedButton(
          onPressed: checkbox
              ? () {
                  Navigator.of(context).pop(true);
                }
              : null,
          child: const Text("OK"),
        ),
      ],
    );
  }
}
