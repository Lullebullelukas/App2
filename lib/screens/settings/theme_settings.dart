import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fsek_mobile/app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fsek_mobile/services/abstract.service.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/theme.service.dart';
import 'package:fsek_mobile/themes.dart';

class ThemeSettingsPage extends StatefulWidget {
  ThemeSettingsPage({Key? key}) : super(key: key);

  @override
  ThemeSettingsState createState() => ThemeSettingsState();
}

class ThemeSettingsState<ThemeSettingsPage> extends State {

  String? _theme;

  void initState() {
    loadTheme();

    super.initState();
  }

  void loadTheme() {
    locator<ThemeService>().loadTheme().then((value) {
      setState(() {
        this._theme = value ?? 'themeF';
      });
    });
  }

  void _setTheme(BuildContext context, String theme, AppLocalizations t) {
    setState(
      () {
        this._theme = theme;

        // context.read has to be used here, not locator<ThemeCubit>().setTheme
        context.read<ThemeCubit>().setTheme(locator<ThemeService>().getThemeData(theme));
        locator<ThemeService>().theme = locator<ThemeService>().getThemeData(theme);
        
        locator<ThemeService>().changeLogInIcon();
        locator<ThemeService>().saveTheme(theme);

        // Send an angry message if the user picks a certain theme
        String? message = angryMessage(theme, t);
        if (message != null && theme != 'themeD') {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).clearSnackBars(); // Clear the queue
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message, style: TextStyle(fontFamily: 'Nabla')),
              duration: Duration(seconds: 4),
            ),
          );        
        } else if (message != null && theme == 'themeD') {
          // Send textbox instead of snackbar
          generalPopup(t.themeSettingsWarning, message);
        }
      },
    );
  }

  Future<void> generalPopup(String title, String body) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  String? angryMessage(String theme, AppLocalizations t) {
    switch (theme) {
      case 'themeF':
        return t.themeSettingsWarningTextF;
      case 'themeN':
        return t.themeSettingsWarningTextN;
      case 'themePi':
        return t.themeSettingsWarningTextPi;
      case 'themeD':
        return t.themeSettingsWarningTextD;
      case 'themeV':
        return t.themeSettingsWarningTextV;
      case 'themeO':
        return t.themeSettingsWarningTextO;
      default:
        return null;
    }
  }

  void changeLogInIcon() {
    // If this is not called, the color of some text will not change depending on the theme
    locator<ThemeService>().loginIcon = [
    CircleAvatar(
      radius: 40.0,
      backgroundImage: (locator<ThemeService>().theme.brightness == Brightness.dark ? 
        AssetImage("assets/img/f_logo_white.png") : AssetImage("assets/img/f_logo.png")),
      backgroundColor: Colors.transparent,
    ),
    SizedBox(width: 16),
    Text("F-sektionen",
      style: TextStyle(
        fontFamily: 'Helvetica Neue', 
        fontSize: 28.0, 
        // A grey color before the dark mode overhaul. Workaround but it looks fine on light mode. 
        color: locator<ThemeService>().theme.colorScheme.onBackground.withAlpha(170)
        )
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.themeSettingsTitle),
      ),
      body: Column(
        children: [
          RadioListTile<String>(
            title: Text(t.themeSettingsTheme1),
            value: 'themeF',
            groupValue: _theme,
            onChanged: (value) => _setTheme(context, value!, t),
          ),
          RadioListTile<String>(
            title: Text(t.themeSettingsTheme2),
            value: 'themeN',
            groupValue: _theme,
            onChanged: (value) => _setTheme(context, value!, t),
          ),
          RadioListTile<String>(
            title: Text(t.themeSettingsTheme3),
            value: 'themePi',
            groupValue: _theme,
            onChanged: (value) => _setTheme(context, value!, t),
          ),
          RadioListTile<String>(
            title: Text(t.themeSettingsTheme4),
            value: 'themeO',
            groupValue: _theme,
            onChanged: (value) => _setTheme(context, value!, t),
          ),
          RadioListTile<String>(
            title: Text(t.themeSettingsTheme5),
            value: 'themeD',
            groupValue: _theme,
            onChanged: (value) => _setTheme(context, value!, t),
          ),
          RadioListTile<String>(
            title: Text(t.themeSettingsTheme6),
            value: 'themeV',
            groupValue: _theme,
            onChanged: (value) => _setTheme(context, value!, t),
          ),
          SizedBox(
            width: double.infinity,
            child: Container(
              color: Theme.of(context).colorScheme.surfaceVariant,
              padding: EdgeInsets.fromLTRB(12, 28, 12, 28),
              child: Text(t.themeSettingsHelp),
            ),
          ),
        ],
      ),
    );
  }
} 