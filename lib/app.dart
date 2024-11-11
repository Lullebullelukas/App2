import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fsek_mobile/content_wrapper.dart';
import 'package:fsek_mobile/services/abstract.service.dart';
import 'package:fsek_mobile/services/theme.service.dart';
import 'package:fsek_mobile/themes.dart';
import 'package:fsek_mobile/util/PushNotificationsManager.dart';
import 'package:fsek_mobile/util/app_exception.dart';
import 'package:fsek_mobile/util/storage_wrapper.dart';
import 'package:fsek_mobile/widgets/loading_widget.dart';

import 'app_background.dart';
import 'screens/login/login.dart';

import 'models/destination.dart';
import 'models/user/user.dart';

import 'services/navigation.service.dart';
import 'services/notifications.service.dart';
import 'services/service_locator.dart';
import 'services/user.service.dart';
import 'util/authentication/authentication_bloc.dart';
import 'util/authentication/authentication_event.dart';
import 'util/authentication/authentication_state.dart';
import 'util/errors/error_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FsekMobileApp extends StatefulWidget {
  final String initialThemeMode;

  // We pull the cached theme from storage in main.dart since that is async
  FsekMobileApp({required this.initialThemeMode});

  @override
  _FsekMobileAppState createState() => _FsekMobileAppState();
  static _FsekMobileAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_FsekMobileAppState>();
}

class _FsekMobileAppState extends State<FsekMobileApp> {
  PushNotificationsManager? pushManager;
  AuthenticationBloc? _authenticationBloc;
  UserService? _userService;
  TokenStorageWrapper? _storage;
  Locale? _locale;
  String? localeName;
  int backgroundIndex = 1;
  String? _themeMode = "themeF";

  User? _user;

  List<Destination> navbarDestinations = [];

  void setLocale(String locale) {
    setState(() {
      this._locale = Locale(locale);
      localeName = locale;
      /* Cache the locale */
      if (_storage != null) {
        _storage!.write(key: 'cached-locale', value: localeName);
      }
      AbstractService.updateApiUrl(locale == "sv");
    });
  }

  @override
  void initState() {
    _themeMode = widget.initialThemeMode;
    _locale = Locale('sv', '');
    _userService = locator<UserService>();
    //checkApiVersion();
    _storage = locator<TokenStorageWrapper>();
    _authenticationBloc = AuthenticationBloc(userService: _userService!);
    _authenticationBloc!.add(AppStarted());
    _authenticationBloc!.stream.listen((AuthenticationState state) async {
      if (state is AuthenticationUserFetched) {
        setState(() {
          _userService!.getUser().then((value) => setState(() {
                this._user = value;

                setupPushNotifications();
              }));
        });
      }
      /* If we have saved a language setting we use that*/
      if (_storage != null) {
        String? cachedLocale = await _storage!.read('cached-locale');
        if (cachedLocale != null) {
          setLocale(cachedLocale);
        }
      }
    });
    // Change background-listener
    locator<NavigationService>().onNavigation.stream.listen((event) {
      for (int i = 0;
          i < locator<NavigationService>().navbarDestinations.length;
          i++) {
        if (locator<NavigationService>()
                .navbarDestinations[i]
                .widget
                .runtimeType ==
            event) {
          setState(() {
            backgroundIndex = i + 1;
          });
          break;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => _authenticationBloc!,
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit()..setTheme(locator<ThemeService>().getThemeData(_themeMode)),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          locator<ThemeService>().changeLogInIcon();
          
          return MaterialApp(
            theme: theme,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              AppLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en', ''),
              Locale('sv', ''),
            ],
            locale: _locale,
            navigatorKey: locator<NavigationService>().navigatorKey,
            home: Stack(children: [
              AppBackground(
                  backgroundColors: locator<ThemeService>().backgroundColors),
              BlocConsumer<AuthenticationBloc, AuthenticationState>(
                bloc: _authenticationBloc,
                builder: (BuildContext context, AuthenticationState state) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 250),
                    child: _buildPage(context, state,
                        locator<NavigationService>().navbarDestinations),
                  );
                },
                listener: (context, state) {
                  if (state is AuthenticationDisconnected) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ErrorPage(
                                authenticationBloc: _authenticationBloc,
                                text:
                                    "We could not connect to Fsektionen.se. Please check your connection or try again later.")));
                  }
                  if (state is AuthenticationError) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ErrorPage(
                                authenticationBloc: _authenticationBloc,
                                text: state.error)));
                  }

                  // Background-animation stuff
                  if (state is! AuthenticationUserFetched &&
                      state is! AuthenticationAuthenticated) {
                    setState(() {
                      backgroundIndex = 0;
                    });
                  } else {
                    setState(() {
                      backgroundIndex = 1;
                    });
                  }
                },
              )
            ]),
        
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            // put named routes in main.dart please (add hot restart app if running)
          }..addAll(locator<NavigationService>().routes),
        );
        }
      )
    );
  }

  Widget? _buildPage(BuildContext context, AuthenticationState state,
      List<Destination> navbarDestinations) {
    if (state is AuthenticationUninitialized) {
      return LoadingWidget();
    }
    if (state is AuthenticationAuthenticated) {
      return ContentWrapper(navbarDestinations, null,
          locator<NavigationService>().onNavigation, []);
    }
    if (state is AuthenticationTokenRefreshed) {
      return ContentWrapper(navbarDestinations, _user,
          locator<NavigationService>().onNavigation, []);
    }
    if (state is AuthenticationUserFetched) {
      return ContentWrapper(navbarDestinations, _user,
          locator<NavigationService>().onNavigation, state.messages);
    }
    if (state is AuthenticationUnauthenticated) {
      return LoginPage(userService: _userService);
    }
    if (state is AuthenticationLoading) {
      return LoadingWidget();
    }
    return null;
  }

  void onDataError(dynamic error) {
    if (error is UnauthorisedException)
      _authenticationBloc!.add(TokenRevoked());
    else
      _authenticationBloc!.add(AppError(error: error.toString()));
  }

  void setupPushNotifications() async {
    pushManager = PushNotificationsManager();
    if (!kIsWeb) await pushManager!.init();

    try {
      String token = await pushManager!.getToken();
      locator<NotificationsService>().createPushDevice(token);

      String? oldId =
          await locator<TokenStorageWrapper>().read("notificationId");
      if (oldId == null || oldId != token) {
        User user = await locator<UserService>().getUser();
        if (user.id == null)
          locator<NotificationsService>().deletePushDevice(oldId!);

        locator<TokenStorageWrapper>()
            .write(key: "notificationId", value: token);
      }
    } catch (ex) {
      print(ex);
    }
  }

  @override
  void dispose() {
    _authenticationBloc!.close();
    super.dispose();
  }
}
