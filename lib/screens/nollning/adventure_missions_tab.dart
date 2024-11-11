import 'package:fsek_mobile/april_fools.dart';
import 'package:flutter/material.dart';
import 'package:fsek_mobile/models/nollning/adventure_mission.dart';
import 'package:fsek_mobile/models/nollning/adventure_mission_week.dart';
import 'package:fsek_mobile/services/nollning.service.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdventureMissionsTab extends StatefulWidget {
  @override
  _AdventureMissionsTabState createState() => _AdventureMissionsTabState();
}

class _AdventureMissionsTabState extends State<AdventureMissionsTab> {
  List<AdventureMissionWeek>? _adventureWeeks;

  void initState() {
    locator<NollningService>().getAdventureWeeks().then((value) => setState(() {
          this._adventureWeeks = value;
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
    int weekCount = _adventureWeeks!.length;
    return DefaultTabController(
      length: _adventureWeeks!.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // no back button on this appbar
          flexibleSpace: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              new TabBar(
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                tabs: List.generate(
                  weekCount,
                  (index) => Tab(
                    text: _adventureWeeks![index].title,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: List.generate(weekCount, (index) => _showAdventureWeek(_adventureWeeks![index])),
        ),
      ),
      initialIndex: weekCount - 1, // make sure the current week is chosen as default
    );
  }

  Widget _showAdventureWeek(AdventureMissionWeek missionWeek) {
    List<AdventureMission> missions = missionWeek.adventure_missions!;
    return RefreshIndicator(
      child: ListView(
        children: List.generate(
          missions.length,
          (index) => _adventureMissionTile(missions[index]),
        ),
        physics: const AlwaysScrollableScrollPhysics(),
      ),
      onRefresh: () async {
        this._adventureWeeks = await locator<NollningService>().getAdventureWeeks();
        setState(() {});
      },
    );
  }

  Widget _adventureMissionTile(AdventureMission mission) {
    var t = AppLocalizations.of(context)!;
    return InkWell(
      // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MissionPage(mission: mission))),
      child: StatefulBuilder(
        builder: (context, setState) {
          return ListTile(
            title: Text(mission.title!),
            // subtitle has to change wether or not we have variable amount of points
            subtitle: mission.variable_points!
                ? Text("1-${mission.max_points} " + t.introductionPoints2.toLowerCase())
                : Text("${mission.max_points} " + t.introductionPoints2.toLowerCase()),
            trailing: locator<NollningService>().is_mentor
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _getIconDescription(mission),
                      IconButton(
                        onPressed: mission.locked ?? false
                            ? null
                            : () => {_setCompletedState(mission).then((value) => setState(() {}))},
                        icon: _getIcon(mission),
                      ),
                    ],
                  )
                : null,
            tileColor: _getTileColor(mission),
          );
        },
      ),
    );
  }

  Color _getTileColor(AdventureMission mission) {
    if (mission.is_accepted!) {
      return Colors.greenAccent.shade100;
    } else if (mission.is_pending!) {
      return Colors.yellowAccent.shade100;
    } else if (mission.locked ?? false) {
      return Colors.grey.shade300;
    } else {
      return Colors.transparent;
    }
  }

  Widget _getIcon(AdventureMission mission) {
    if (mission.locked ?? false) {
      return Icon(
        Icons.lock,
        color: Colors.grey,
      );
    } else if (mission.is_accepted! || mission.is_pending!) {
      return Icon(
        Icons.cancel_rounded,
        color: Colors.red,
      );
    } else {
      return Icon(
        Icons.check_box_rounded,
        color: Colors.green,
      );
    }
  }

  Widget _getIconDescription(AdventureMission mission) {
    var t = AppLocalizations.of(context)!;
    if (mission.locked ?? false) {
      return Text(
        t.introductionLocked,
      );
    } else if (mission.is_accepted! || mission.is_pending!) {
      return Text(
        t.introductionInterrupt,
      );
    } else {
      return Text(
        t.introductionApprove,
      );
    }
  }

  Future<void> _setCompletedState(AdventureMission mission) async {
    var t = AppLocalizations.of(context)!;
    try {
      // if the mission isn't already handed in yet (either completed or pending)
      if (!(mission.is_accepted! || mission.is_pending!)) {
        // if the mission has variable points, let them fill in the amount,
        // else just post instantly
        if (mission.variable_points!) {
          int? points = await _variablePointsDialog(context, mission.max_points!);
          if (points != null) {
            Map json = await locator<NollningService>().finishAdventureMission(mission.id!, points);
            _changeLookOnMissionOrThrowError(mission, json);
          }
        } else {
          Map json = await locator<NollningService>().finishAdventureMission(mission.id!, mission.max_points!);
          _changeLookOnMissionOrThrowError(mission, json);
        }
      } else {
        bool? remove = await _resetMissionDialog(context);
        if (remove == true) {
          Map json = await locator<NollningService>().resetAdventureMission(mission.id!);
          _changeLookOnMissionOrThrowError(mission, json);
        }
      }
    } on Exception {
      _failedToUpdateDialog(context, t.introductionError);
    }
  }

  void _changeLookOnMissionOrThrowError(AdventureMission mission, Map json) {
    // TODO: fix with error handling!
    // At this point only throws error in AbstractService, want to catch it here
    // When trying with try{}catch{} it did not seem to fix the problem...
    if (json.containsKey('error')) {
      _failedToUpdateDialog(context, json['error']);
    } else {
      if (mission.is_accepted!) {
        mission.is_accepted = false;
      } else if (mission.is_pending!) {
        mission.is_pending = false;
      } else {
        if (mission.require_acceptance!) {
          mission.is_pending = true;
        } else {
          mission.is_accepted = true;
        }
      }
    }
  }

  Future<void> _failedToUpdateDialog(BuildContext context, String errorMessage) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(errorMessage),
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

  Future<int?> _variablePointsDialog(BuildContext context, int max_points) {
    // final _formKey = GlobalKey<FormState>();
    TextEditingController _textFieldController = TextEditingController();
    int? points;
    var t = AppLocalizations.of(context)!;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${t.introductionPoints}(1-$max_points)"),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: _textFieldController,
            decoration: InputDecoration(
              hintText: "1-$max_points",
            ),
          ),
          actions: [
            TextButton(
              child: Text(t.introductionInterrupt2),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (_isValidInput(_textFieldController.text, max_points)) {
                  points = int.parse(_textFieldController.text);
                  Navigator.pop(context, points);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _resetMissionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          var t = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(t.introductionDestroyMission),
            actions: [
              TextButton(
                child: Text(t.introductionInterrupt3),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(t.introductionDestroy),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
  }

  bool _isValidInput(String value, int max_points) {
    if (value.isNotEmpty) {
      try {
        int number = int.parse(value);
        return (number > 0 && number <= max_points);
      } on FormatException {
        // not even an int
        return false;
      }
    }
    return false;
  }
}
