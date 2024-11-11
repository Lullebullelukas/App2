import 'package:flutter/material.dart';
import 'package:fsek_mobile/screens/cafe/cafe.dart';
import 'package:fsek_mobile/screens/contact/contact.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fsek_mobile/screens/gallery/gallery.dart';
import 'package:fsek_mobile/screens/moose_game/moose_game.dart';
import 'package:fsek_mobile/screens/other/aboutGuild.dart';
import 'package:fsek_mobile/screens/settings/language_settings.dart';
import 'package:fsek_mobile/screens/settings/settings.dart';
import 'package:fsek_mobile/screens/settings/theme_settings.dart';
import 'package:fsek_mobile/screens/songbook/songbook.dart';
import 'package:fsek_mobile/screens/placeholder/placeholder.dart';
import 'package:fsek_mobile/services/notifications.service.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/util/authentication/authentication_bloc.dart';
import 'package:fsek_mobile/util/authentication/authentication_event.dart';
import 'package:url_launcher/url_launcher.dart';

import 'fap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OtherContent extends StatelessWidget {
  //TODO fix this
  static List<String> categories = [];
  static List<String> about = [];
  static List<String> settings = [];
  static List<String> support = [];
  static Map<String, Widget> routeMap = {};

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    categories = [t.otherSongbook, t.otherGallery, t.otherCafe, "Moose Game"];
    about = [t.otherAboutGuild, t.otherFap];
    settings = [t.otherAccount, t.otherLanguage, t.otherTheme];
    support = [t.otherContact, t.otherAnon];

    // Temporary moose game reveal holdoff until 18:30 6th of September 2024, 
    // after that date, remove this please
    if (DateTime.now().isBefore(DateTime(2024, 9, 6, 18, 30))) {
      routeMap = {
        "Songbook": SongbookPage(),
        "Photo Gallery": GalleryPage(),
        "Hilbert Café": CafePage(),
        "Moose Game": PlaceholderPage(title: "Moose Game", disc: "Coming to a sittning near you..."),
        "The F guild": AboutGuildPage(),
        "The F-app": FapPage(),
        "Account": SettingsPage(),
        "Language": LanguageSettingsPage(),
        "Contact": ContactPage(),
        "Anonymous contact page": Container(),
        "Sångbok": SongbookPage(),
        "Bildgalleri": GalleryPage(),
        "F-sektionen": AboutGuildPage(),
        "F-appen": FapPage(),
        "Konto": SettingsPage(),
        "Språk": LanguageSettingsPage(),
        "Kontakt": ContactPage(),
        "Anonym kontaktsida": Container()
      };
    } else {
      /* I am so sorry for this Teo */
      routeMap = {
        "Songbook": SongbookPage(),
        "Photo Gallery": GalleryPage(),
        "Hilbert Café": CafePage(),
        "Moose Game": MooseGamePage(),
        "The F guild": AboutGuildPage(),
        "The F-app": FapPage(),
        "Account": SettingsPage(),
        "Language": LanguageSettingsPage(),
        "Theme": ThemeSettingsPage(),
        "Contact": ContactPage(),
        "Anonymous contact page": Container(),
        "Sångbok": SongbookPage(),
        "Bildgalleri": GalleryPage(),
        "F-sektionen": AboutGuildPage(),
        "F-appen": FapPage(),
        "Konto": SettingsPage(),
        "Språk": LanguageSettingsPage(),
        "Tema": ThemeSettingsPage(),
        "Kontakt": ContactPage(),
        "Anonym kontaktsida": Container()
      };
    }
    

    return ListView(
        children: _generateListTiles(categories, context) +
            [
              ListTile(
                  title: Text(
                t.otherAbout,
                style: _style(),
              ))
            ] +
            _generateListTiles(about, context) +
            [
              ListTile(
                  title: Text(
                t.otherSettings,
                style: _style(),
              ))
            ] +
            _generateListTiles(settings, context) +
            [ListTile(title: Text("Support", style: _style()))] +
            _generateListTiles(support, context) +
            [
              Card(
                margin: EdgeInsets.all(2),
                child: InkWell(
                    child: ListTile(
                  tileColor: Theme.of(context).colorScheme.error,
                  title: Text(
                    t.otherLogOut,
                    style: TextStyle(color: Theme.of(context).colorScheme.onError),
                  ),
                  onTap: () async {
                    bool? logout = await _confirmLogout(context);
                    if (logout ?? false) {
                      locator<NotificationsService>()
                          .logOutDevice()
                          .then((value) {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(LoggedOut());
                      });
                    }
                  },
                )),
              )
            ]);
  }

  Future<bool?> _confirmLogout(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(t.otherLogOutConfirm),
            actions: [
              TextButton(
                child: Text(t.otherCancel.toUpperCase()),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                child: Text(t.otherLogOut.toUpperCase()),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
  }

  List<Widget> _generateListTiles(
      List<String> tileTexts, BuildContext context) {
    List<Widget> tiles = [];
    var t = AppLocalizations.of(context)!;
    for (String tileText in tileTexts) {
      tiles.add(Card(
        color: Theme.of(context).colorScheme.surface,
        margin: EdgeInsets.all(2),
        child: InkWell(
            child: ListTile(
          title: Text(tileText),
          onTap: () => goToTilePage(tileText, context),
          trailing: tileText != t.otherAnon
              ? SizedBox.shrink()
              : Icon(Icons.open_in_new_rounded),
        )),
      ));
    }
    return tiles;
  }

  void goToTilePage(String title, BuildContext context) {
    var t = AppLocalizations.of(context)!;
    if (title == t.otherAnon) {
      launchUrl(Uri.parse(
          "https://docs.google.com/forms/d/e/1FAIpQLSdZdPl14DkdlZCKS3jzO59-FvVi2ug9nYer1jhYgERanbwHoQ/viewform"));
      return;
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => routeMap[title]!));
  }

  TextStyle _style() {
    return TextStyle(fontWeight: FontWeight.bold);
  }
}
