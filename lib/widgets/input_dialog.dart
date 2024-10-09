import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<String?> inputDialog(
    BuildContext context, String title, String fieldText, bool popTwice) {
  // Pop twice is used for if dialog is opened as you change window,
  // so if poptwice = true you go back to actual previous window
  // might have more or less application but i think thats how it would be used.
  // basically go back two screens

  TextEditingController _textFieldController = TextEditingController();
  var t = AppLocalizations.of(context)!;
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          keyboardType: TextInputType.text,
          controller: _textFieldController,
          decoration: InputDecoration(
            hintText: fieldText,
          ),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              if (popTwice) {
                NavigatorState nav = Navigator.of(context);
                nav.pop();
                nav.pop();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          TextButton(
            child: Text('Enter'),
            onPressed: () {
              Navigator.pop(context, _textFieldController.text);
            },
          ),
        ],
      );
    },
  );
}
