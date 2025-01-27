import 'package:flutter/material.dart';
import 'package:fsek_mobile/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/util/storage_wrapper.dart';
import 'package:provider/provider.dart';


class ThemeService {
  // This should be defined before the app is built, but juuuust in case there are standard values I guess
  ThemeData theme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.orange[600],
  );
  List<Color> backgroundColors = [
    Color(0xFFf77e14),
    Color(0xFFe6660b),
  ];
  List<Widget> loginIcon = [
    CircleAvatar(
      radius: 36.0,
      backgroundImage: AssetImage("assets/img/fsektionen.png"),
      backgroundColor: Colors.transparent,
    ),
    SizedBox(width: 16),
    Image.asset('assets/img/text.png', scale: 3.6)
  ];

  ThemeData getThemeData(themeName) {
    switch (themeName) {
      case 'themeF':
        return themeF;
      case 'themeFdark':
        return themeFdark;
      case 'themeN':
        return themeN;
      case 'themePi':
        return themePi;
      case 'themeO':
        return themeO;
      case 'themeD':
        return themeD;
      case 'themeV':
        return themeV;
      default:
        print("Warning: Theme not found, returning light theme");
        return themeF;
    }
  }

  void saveTheme(themeName) async {
    TokenStorageWrapper? _storage;

    _storage = locator<TokenStorageWrapper>();

    if (_storage != null) {
      _storage.write(key: 'cached-theme', value: themeName);
    }
  }

  Future<String?> loadTheme() async {
    TokenStorageWrapper? _storage;
    Future<String?> cachedTheme = Future.value(null);

    _storage = locator<TokenStorageWrapper>();

    if (_storage != null) {
      cachedTheme = _storage.read('cached-theme');
    }

    return cachedTheme;
  }

  void setTheme(BuildContext context, String? theme) {
    /* Sets the theme based on the theme name and saves it to cache */

    ThemeData themeData = getThemeData(theme); 

    locator<ThemeCubit>().setTheme(themeData);
    locator<ThemeService>().theme = themeData;
    // This is (probably) just for moose game etc. to load in the right images
    this.theme = themeData;

    saveTheme(theme);
    print("Theme changed to $theme");
    changeLogInIcon();
  }

  void changeLogInIcon() {
    // If this is not called, the login page will not update properly
    this.loginIcon = [
    CircleAvatar(
      radius: 40.0,
      backgroundImage: (this.theme.brightness == Brightness.dark ? 
        AssetImage("assets/img/f_logo_white.png") : AssetImage("assets/img/f_logo.png")),
      backgroundColor: Colors.transparent,
    ),
    SizedBox(width: 16),
    Text("F-sektionen",
      style: TextStyle(
        fontFamily: 'Helvetica Neue', 
        fontSize: 28.0, 
        // A grey color before the dark mode overhaul. Workaround but it looks fine on light mode. 
        color: this.theme.colorScheme.onBackground.withAlpha(170)
        )
      ),
    ];
  }
}