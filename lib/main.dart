import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fsek_mobile/app.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fsek_mobile/screens/news/news.dart';
import 'package:fsek_mobile/screens/calendar/calendar.dart';
import 'package:fsek_mobile/screens/nollning/messaging/messages.dart';
import 'package:fsek_mobile/screens/nollning/nolleguide/manners.dart';
import 'package:fsek_mobile/screens/nollning/nolleguide/people.dart';
import 'package:fsek_mobile/screens/nollning/nolleguide-24/wordlist.dart';
import 'package:fsek_mobile/screens/notiser/notiser.dart';
import 'package:fsek_mobile/screens/other/other.dart';
import 'package:fsek_mobile/models/destination.dart';
import 'package:fsek_mobile/screens/nollning/adventure_missions.dart';
import 'package:fsek_mobile/screens/nollning/emergency_contacts.dart';
import 'package:fsek_mobile/screens/nollning/nolleguide/nolleguide.dart';
import 'package:fsek_mobile/screens/songbook/songbook.dart';
import 'package:fsek_mobile/screens/nollning/chant_book.dart';
import 'package:fsek_mobile/screens/home/home.dart';
import 'package:fsek_mobile/services/navigation.service.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/theme.service.dart';
import 'package:fsek_mobile/util/storage_wrapper.dart';

// Shows the transitions between currentstate and nextstate for all blocs
class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition.toString());
    super.onTransition(bloc, transition);
  }
}

void main() async {
  setupLocator();
  var route = locator<NavigationService>();
  final List<Destination> navbarDestinations = <Destination>[
    Destination(0, Icons.feed_outlined, NewsPage()),
    Destination(1, Icons.calendar_today, Calendar()),
    Destination(2, Icons.home, HomePage()),
    Destination(3, Icons.notifications, NotificationsPage()),
    Destination(4, Icons.list, OtherContent()),
  ];

  route.navbarDestinations = navbarDestinations;
  route.routes = {
    '/adventure_missions': (context) => AdventureMissionsPage(),
    '/emergency_contacts': (context) => EmergencyContactsPage(),
    '/messages': (context) => MessagesPage(),
    '/chant_book': (context) => ChantBookPage(),
    '/song_book': (context) => SongbookPage(),
    '/homepage': (context) => HomePage(),
    '/nolleguide': (context) => GuidePage(),
    '/manners': (context) => MannersPage(),
    '/people': (context) => PeoplePage(),
    '/wordlist': (context) => WordListPage(),
  }; 
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      // In development mode, simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode, send it to the FlutterError.onError function
      // which we have overwritten
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  Bloc.observer = SimpleBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_backgroundMessagingHandler);

  // We load the theme here because async is needed, then we pass it to the app 
  // where ThemeCubit gets initialised with the cached theme
  TokenStorageWrapper? _storage;
  String? cachedTheme = null;

  _storage = locator<TokenStorageWrapper>();

  cachedTheme = await _storage.read('cached-theme');

  if (cachedTheme == null) {
    cachedTheme = 'themeF';
  }

  locator<ThemeService>().theme = locator<ThemeService>().getThemeData(cachedTheme);

  runApp(FsekMobileApp(initialThemeMode: cachedTheme));

  // Whenever an error occurs, call the `_reportError` function. This sends
  // Dart errors to the dev console or Sentry depending on the environment.
  // we removed this stuff now, it should be fine without.
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  // Print the exception to the console.
  print('Caught error: $error');
  if (isInDebugMode) {
    // Print the full stacktrace in debug mode.
    print(stackTrace);
  } else {
    // Send the Exception and Stacktrace to Sentry in Production mode. (fuck sentry, all my homies hate sentry, use catcher instead)
    /*_sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );*/
  }
}

Future<void> _backgroundMessagingHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  print(message.data);
  print(message.notification);
  print(message.messageType);
  print(message.category);
}
