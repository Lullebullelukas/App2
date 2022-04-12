import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fsek_mobile/app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSettingsPage extends StatefulWidget {
  LanguageSettingsPage({Key? key}) : super(key: key);

  @override
  LanguageSettingsState createState() => LanguageSettingsState();
}

class LanguageSettingsState<LanguageSettingsPage> extends State {
  String? _locale;

  void initState() {
    super.initState();
    _locale = FsekMobileApp.of(context)?.localeName;
  }

  void _setLocale(BuildContext context, String? locale) {
    setState(
      () {
        this._locale = locale!;
        FsekMobileApp.of(context)!.setLocale(locale);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.language),
      ),
      body: Column(
        children: [
          RadioListTile<String>(
            title: Text(AppLocalizations.of(context)!.swedish),
            value: 'sv',
            groupValue: _locale,
            onChanged: (value) => _setLocale(context, value),
          ),
          RadioListTile<String>(
            title: Text(AppLocalizations.of(context)!.english),
            value: 'en',
            groupValue: _locale,
            onChanged: (value) => _setLocale(context, value),
          ),
        ],
      ),
    );
  }
}

/*
Column(
          children: [
            InkWell(
              onTap: () {
                FsekMobileApp.of(context)!.setLocale('sv');
              },
              child: Card(
                child: Text("Byt språk lol"),
              ),
            ),
          ],*/