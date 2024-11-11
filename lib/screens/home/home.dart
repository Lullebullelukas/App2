import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';

import 'package:fsek_mobile/screens/cafe/cafe.dart';
import 'package:fsek_mobile/screens/gallery/gallery.dart';
import 'package:fsek_mobile/screens/guild_meeting/candidacy_poster.dart';
import 'package:fsek_mobile/screens/guild_meeting/other_documents.dart';
import 'package:fsek_mobile/screens/guild_meeting/about_guild_meeting.dart';
import 'package:fsek_mobile/screens/guild_meeting/propositions.dart';
import 'package:fsek_mobile/screens/guild_meeting/motions.dart';
import 'package:fsek_mobile/screens/nollning/map_page.dart';
import 'package:fsek_mobile/screens/nollning/nolleguide-24/nolleguidescreen.dart';
import 'package:fsek_mobile/screens/nollning/schedule.dart';
import 'package:fsek_mobile/screens/placeholder/placeholder.dart';
import 'package:fsek_mobile/screens/nollning/adventure_missions_new.dart';

import 'package:fsek_mobile/models/documents/election_document.dart';

import 'package:fsek_mobile/util/nollning/week_tracker.dart';

import 'package:fsek_mobile/services/preload_asset.service.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/document.service.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ElectionDocument>? backgroundDocuments;
  String? backgroundUrl;
  bool? election;

  void initState() {
    locator<DocumentService>().getOthers("Bakgrund").then((value) => setState(() {
          // Value is null if getothers parameter doesnt exist, empty list if it exists but no documents in it.
          if (!listEquals(value, []) && value != null) {
            this.backgroundDocuments = value;
            // title cant be empty so it is always a string
            if (value.last.document_name!.toLowerCase().startsWith("ht") || value.last.document_name!.toLowerCase().startsWith("vt")) {
              // if the pictured background is named ht or vt means we are in ht or vt and should use that button layout
              this.election = true;
            } else {
              this.election = false;
            }
            this.backgroundUrl = value.last.url;
          }
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var t = AppLocalizations.of(context)!;
    double circleSize = MediaQuery.of(context).size.height / 8;

    // double edgePadding = MediaQuery.of(context).size.width / 25;
    // String defaultBackground = "assets/img/default_background.png";

    String locale = Localizations.localeOf(context).toString();

    // if it for some reason is something different dont break everything
    if (locale != "sv" && locale != "en") {
      locale = "sv";
    }

    int week = WeekTracker.determineWeek();
    String backgroundPath = "assets/img/nollning-24/homescreen/background-v$week.png";
    String nolleguidePath = "assets/img/nollning-24/homescreen/button-nolleguide.png";
    String uppdragPath = "assets/img/nollning-24/homescreen/button-adventure-missions.png";
    String schedulePath = "assets/img/nollning-24/homescreen/button-schedule.png";
    String mapPath = "assets/img/nollning-24/homescreen/button-map.png";
    String emergencyPath = "assets/img/nollning-24/homescreen/button-emergency.png";
    String messagesPath = "assets/img/nollning-24/homescreen/button-messages.png";

    return Stack(children: [
      Image.asset(
        backgroundPath,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            //testtext
            InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(circleSize * 1.6)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MapView()));
              },
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 25),
                child: Image.asset(mapPath, height: circleSize * 1.5),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(circleSize)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdventureMissionsPageNew()));
                      },
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Image.asset(uppdragPath, height: circleSize),
                      ),
                    ),
                    Column(children: [
                      InkWell(
                        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(circleSize)),
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                          await preloadAssets(context, "nolleGuideScreenPaths");
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NolleGuideScreenPage()));
                        },
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Image.asset(nolleguidePath, height: circleSize),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 28) // Box to make middle button float higher than right and left
                    ]),
                    InkWell(
                      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(circleSize)),
                      onTap: () {
                        Navigator.pushNamed(context, "/messages");
                      },
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Image.asset(messagesPath, height: circleSize),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                    InkWell(
                      customBorder: CircleBorder(),
                      onTap: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                        await preloadAssets(context, "schedulePaths");
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleScreenPage()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            schedulePath,
                            height: circleSize / 1.5,
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 5, right: 5)),
                    InkWell(
                      customBorder: CircleBorder(),
                      onTap: () {
                        Navigator.pushNamed(context, "/emergency_contacts");
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            emergencyPath,
                            height: circleSize / 1.5,
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 60),
              ],
            ),
          ]),
        ),
      ),
    ]);
  }

  // Currently unused, used in nollning 2023
  // Widget _pageFlipButton(Widget destination, String assetPath, int week, double circleSize, double inkwellCurvature, double padding) {
  //   return InkWell(
  //     customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(inkwellCurvature)),
  //     onTap: () => Navigator.push(context, TurnPageRoute(builder: (context) => destination, overleafColor: WeekTracker.weekColors[week])),
  //     child: Padding(
  //       padding: EdgeInsets.only(left: padding, right: padding),
  //       child: Image.asset(assetPath, height: circleSize),
  //     ),
  //   );
  // }

  Widget button(String text, Widget destination) {
    return TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      },
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Theme.of(context).colorScheme.onBackground,
          elevation: 10,
          minimumSize: Size(MediaQuery.of(context).size.width / 2.4, 80)),
    );
  }

  List<Widget> _getStandardButtons() {
    // This returns the buttons that are used for the standard design of the homepage
    var t = AppLocalizations.of(context)!;
    return [
      Spacer(flex: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // button(t.songbookSongbook, SongbookPage()),
          button("Map test", MapView()),
          button(t.otherGallery, GalleryPage()),
        ],
      ),
      Spacer(flex: 2),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          button(t.otherCafe, CafePage()),
          button(t.game, PlaceholderPage(title: t.game, disc: t.gameDescription)),
        ],
      ),
      Spacer(flex: 4)
    ];
  }

  List<Widget> _getElectionButtons() {
    var t = AppLocalizations.of(context)!;

    return [
      Spacer(flex: 6),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          button(t.guildMeetingButtonAbout, AboutGuildMeetingPage()),
          button(t.guildMeetingButtonPoster, CandidacyPosterPage()),
        ],
      ),
      Spacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          button(t.guildMeetingButtonMotions, MotionsPage()),
          button(t.guildMeetingButtonProposition, PropositionsPage()),
        ],
      ),
      Spacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width / 48), // space so that the fifth button matches up with the grid above
          button(t.guildMeetingButtonOther, OtherDocumentsPage()),
        ],
      ),
      Spacer(flex: 2),
    ];
  }
}
