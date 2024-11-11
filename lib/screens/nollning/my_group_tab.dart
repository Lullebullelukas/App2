import 'package:fsek_mobile/april_fools.dart';
import 'package:flutter/material.dart';
import 'package:fsek_mobile/models/nollning/adventure_data.dart';
import 'package:fsek_mobile/models/nollning/adventure_mission_week.dart';
import 'package:fsek_mobile/services/nollning.service.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyGroupTab extends StatefulWidget {
  @override
  _MyGroupTabState createState() => _MyGroupTabState();
}

class _MyGroupTabState extends State<MyGroupTab> {
  List<AdventureMissionWeek>? _adventureWeeks;
  List<int>? totalMissionsList;
  List<int>? acceptedMissionsList;
  List<double>? progressList;
  int? totalPoints;
  int? maxTotalPoints;
  AdventureData? adventureData;

  void initState() {
    locator<NollningService>().getAdventureWeeks().then((value) => setState(() {
          this._adventureWeeks = value;
          this.totalMissionsList = totalMissions(_adventureWeeks!);
          this.acceptedMissionsList = acceptedMissions(_adventureWeeks!);
          this.progressList = List.empty(growable: true);
        }));

    locator<NollningService>().getAdventures().then((value) => setState(() {
          this.adventureData = value;
          totalPoints = value.total_group_points ?? 0;
          maxTotalPoints = _getMaxTotal();
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_adventureWeeks == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }
    //fuck it! For loop time
    for (var i = 0; i < 5; i++) {
      if (totalMissionsList!.elementAt(i) == 0) {
        progressList!.add(0);
      } else {
        progressList!.add(acceptedMissionsList!.elementAt(i) /
            totalMissionsList!.elementAt(i));
      }
    }
    double circleSize = MediaQuery.of(context).size.height / 7;
    var t = AppLocalizations.of(context)!;
    return Stack(
      children: [
        Image.asset(
          "assets/img/nollning-23/uppdrag/uppdrag-homescreen.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height / 35),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, right: 10, left: 10),
                        child: Text(
                          adventureData?.group_name ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: circleSize / 2),
                        child: Text(
                          "$totalPoints ${t.introductionPoints2}",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _weekProgressCircle(
                        imgPath:
                            "assets/img/nollning-23/uppdrag/uppdrag-button-v0.png",
                        progress: progressList!.elementAt(0),
                        borderColor: Colors.white,
                        size: circleSize,
                        //text: "${t.introductionWeek} 0"
                      ),
                      _weekProgressCircle(
                        imgPath:
                            "assets/img/nollning-23/uppdrag/uppdrag-button-v1.png",
                        progress: progressList!.elementAt(1),
                        borderColor: Colors.white,
                        size: circleSize,
                        //text: "${t.introductionWeek} 1",
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: circleSize / 4)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _weekProgressCircle(
                        imgPath:
                            "assets/img/nollning-23/uppdrag/uppdrag-button-v2.png",
                        progress: progressList!.elementAt(2),
                        borderColor: Colors.white,
                        size: circleSize,
                        //text: "${t.introductionWeek} 2",
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: circleSize / 4)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _weekProgressCircle(
                        imgPath:
                            "assets/img/nollning-23/uppdrag/uppdrag-button-v3.png",
                        progress: progressList!.elementAt(3),
                        borderColor: Colors.white,
                        size: circleSize,
                        //text: "${t.introductionWeek} 3"
                      ),
                      _weekProgressCircle(
                        imgPath:
                            "assets/img/nollning-23/uppdrag/uppdrag-button-v4.png",
                        progress: progressList!.elementAt(4),
                        borderColor: Colors.white,
                        size: circleSize,
                        //text: "${t.introductionWeek} 4",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _weekProgressCircle(
      {required String imgPath,
      required double progress,
      Color borderColor = Colors.black,
      bool active = true,
      double size = 150,
      String? text}) {
    Widget textBox = Container();
    if (text != null) {
      textBox = Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 18),
      );
    }

    return Column(children: [
      Stack(alignment: Alignment.center, children: [
        Container(
          foregroundDecoration: BoxDecoration(
            // Only grey out img if not active
            color: active ? Colors.transparent : Colors.grey,
            backgroundBlendMode: BlendMode.saturation,
            borderRadius: BorderRadius.circular(150),
          ),
          child: Image.asset(
            imgPath,
            height: size,
          ),
        ),
        SizedBox(
          child: CircularProgressIndicator(
            value: progress,
            color: borderColor,
            strokeWidth: 6.0,
          ),
          width: size,
          height: size,
        ),
      ]),
      textBox
    ]);
  }

  List<int> totalMissions(List<AdventureMissionWeek> adventureMissionWeeks) {
    List<int> missionsPerWeek = List.empty(growable: true);
    adventureMissionWeeks.forEach((week) {
      missionsPerWeek.add(week.adventure_missions!.length);
    });
    //fuck it! While loop
    while (missionsPerWeek.length <= 5) {
      missionsPerWeek.add(0);
    }
    return missionsPerWeek;
  }

  List<int> acceptedMissions(List<AdventureMissionWeek> adventureMissionWeeks) {
    List<int> acceptedPerWeek = List.empty(growable: true);
    adventureMissionWeeks.forEach((week) {
      acceptedPerWeek.add(week.missions_accepted ?? 0);
    });
    //fuck it! While loop
    while (acceptedPerWeek.length <= 5) {
      acceptedPerWeek.add(0);
    }
    return acceptedPerWeek;
  }

  int _getMaxTotal() {
    Map<String, List<AdventureMissionWeek>> map = adventureData!.adventures!;
    int points = 0;
    map.entries.forEach((entry) {
      if (entry.key == "adventures") {
        entry.value.forEach((week) {
          week.adventure_missions!.forEach((mission) {
            points += mission.max_points ?? 0;
          });
        });
      }
    });
    return points;
  }
}
