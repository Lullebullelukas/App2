import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutGuildMeetingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(
          title: Text(t.guildMeetingTitle),
        ),
        body: Container(
            padding: EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(t.guildMeetingCurr, style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: <TextSpan>[
                        TextSpan(text: t.guildMeetingNominateOne, style: TextStyle(height: 1.5)),
                        TextSpan(
                          text: " ${t.guildMeetingNominateTwo} ",
                          style: TextStyle(height: 1.5, color: Theme.of(context).colorScheme.primary),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse('https://fsektionen.se/val'));
                            },
                        ),
                        TextSpan(text: t.guildMeetingSendMotionOne, style: TextStyle(height: 1.5)),
                        TextSpan(
                          text: t.guildMeetingSendMotionTwo,
                          style: TextStyle(height: 1.5, color: Theme.of(context).colorScheme.primary),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse('mailto:sekreterare@fsektionen.se'));
                            },
                        ),
                        TextSpan(
                            text: " ${t.guildMeetingSendMotionThree}\n\n"
                                "${t.guildMeetingTimePlaceOne}\n${t.guildMeetingTimePlaceTwo}\n"
                                "${t.guildMeetingTimePlaceThree}\n\n"
                                "${t.guildMeetingDeadlinesOne}\n"
                                "${t.guildMeetingDeadlinesTwo}\n"
                                "${t.guildMeetingDeadlinesThree}\n"
                                "${t.guildMeetingDeadlinesFour}\n"
                                "${t.guildMeetingDeadlinesFive}\n\n"
                                "${t.guildMeetingETC}",
                            style: TextStyle(height: 1.5)),
                        TextSpan(
                          text: "${t.guildMeetingBoard}",
                          style: TextStyle(height: 1.5, color: Theme.of(context).colorScheme.primary),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse('mailto:styrelsen@fsektionen.se'));
                            },
                        ),
                        TextSpan(
                          text: ".\n\n${t.guildMeetingSignOff}",
                          style: TextStyle(height: 1.5),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text("${t.guildMeetingAboutTitle}", style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 8),
                  Text("${t.guildMeetingAboutOne}", style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: <TextSpan>[
                        TextSpan(
                            text: "${t.guildMeetingAboutTwo}"
                                "${t.guildMeetingAboutThree} ${t.guildMeetingAboutFour}",
                            style: TextStyle(height: 1.5)),
                        TextSpan(
                          text: " ${t.guildMeetingBoard} ",
                          style: TextStyle(height: 1.5, color: Theme.of(context).colorScheme.primary),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse('mailto:styrelsen@fsektionen.se'));
                            },
                        ),
                        TextSpan(text: "${t.guildMeetingAboutFive}", style: TextStyle(height: 1.5)),
                        TextSpan(
                          text: "${t.guildMeetingAboutSix}",
                          style: TextStyle(height: 1.5, color: Theme.of(context).colorScheme.primary),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse('https://fsektionen.se/kontakter'));
                            },
                        ),
                        TextSpan(
                            text: "${t.guildMeetingAboutSeven} ${t.guildMeetingAboutEight}",
                            style: TextStyle(height: 1.5)),
                        TextSpan(
                          text: "${t.guildMeetingAboutNine} ",
                          style: TextStyle(height: 1.5, color: Theme.of(context).colorScheme.primary),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse('mailto:sekreterare@fsektionen.se'));
                            },
                        ),
                        TextSpan(text: "${t.guildMeetingAboutTen}", style: TextStyle(height: 1.5))
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text("${t.guildMeetingElectionInfoOne}", style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: <TextSpan>[
                        TextSpan(text: "${t.guildMeetingElectionInfoTwo}", style: TextStyle(height: 1.5)),
                        TextSpan(
                          text: "${t.guildMeetingElectionInfoThree} ",
                          style: TextStyle(height: 1.5, color: Theme.of(context).colorScheme.primary),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse('https://fsektionen.se/val'));
                            },
                        ),
                        TextSpan(
                            text: "${t.guildMeetingElectionInfoFour} ${t.guildMeetingElectionInfoFive}",
                            style: TextStyle(height: 1.5)),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text("${t.guildMeetingElectionInfoSix}", style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8),
                  Text(
                      "${t.guildMeetingElectionInfoSeven}${t.guildMeetingElectionInfoEight}${t.guildMeetingElectionInfoNine}",
                      style: TextStyle(height: 1.5)),
                  SizedBox(height: 24),
                  Text("${t.guildMeetingBoardElectionOne}", style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8),
                  Text(
                      "${t.guildMeetingBoardElectionTwo}${t.guildMeetingBoardElectionThree}${t.guildMeetingBoardElectionFour}",
                      style: TextStyle(height: 1.5)),
                  SizedBox(height: 24),
                ],
              ),
            )));
  }
}
