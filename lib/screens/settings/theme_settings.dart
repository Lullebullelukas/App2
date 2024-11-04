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
    super.initState();
  }

  void _setTheme(BuildContext context, String? theme) {
    setState(
      () {
        this._theme = theme;
        // This is a bad way to do this
        if (theme == 'mat3ThemeLight') {
          context.read<ThemeCubit>().setTheme(mat3ThemeLight);
          // This is (probably) just for moose game etc. to load in the right images
          locator<ThemeService>().theme = mat3ThemeLight;
          print("Theme changed to light");
        } else if (theme == 'mat3ThemeDark') {
          context.read<ThemeCubit>().setTheme(mat3ThemeDark);
          locator<ThemeService>().theme = mat3ThemeDark;
          print("Theme changed to dark");
        } 
        changeLogInIcon();
      },
    );
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Theme"), //TODO: Translate
      ),
      body: Column(
        children: [
          RadioListTile<String>(
            title: Text("F-Ljust"),//TODO: Translate
            value: 'mat3ThemeLight',
            groupValue: _theme,
            onChanged: (value) => _setTheme(context, value),
          ),
          RadioListTile<String>(
            title: Text("nano-Grönt"),
            value: 'mat3ThemeDark',
            groupValue: _theme,
            onChanged: (value) => _setTheme(context, value),
          ),
        ],
      ),
    );
  }
} 
