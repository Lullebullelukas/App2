import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fsek_mobile/models/user/user.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/user.service.dart';
import 'package:fsek_mobile/widgets/input_dialog.dart';
import 'package:fsek_mobile/services/game.service.dart';
import 'package:fsek_mobile/models/moose_game/game_score_entry.dart';

class HighscorePage extends StatefulWidget {
  @override
  _HighscorePageState createState() => _HighscorePageState();
}

class _HighscorePageState extends State<HighscorePage>
    with TickerProviderStateMixin {
  // Change to user when implemented with api

  // list for what is being shown on screen (the "results of a search")
  // even when nothing has been searched. does change throughout.
  List<GameScoreEntry> results = [];

  // actual list of all users that gets sorted, never changed
  List<GameScoreEntry> allScores = [];

  User? user;

  //idk i "borrowed" the songbook and they were bad and probably not needed but here they are.
  bool searchFocus = false;
  String initChar = "";

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    locator<GameScoreService>().getScores().then((value) => setState(() {
          allScores = value;
          allScores
              .sort((a, b) => b.score!.compareTo(a.score!)); // handle null?
          results = List.from(allScores);
        }));
    locator<UserService>().getUser().then((value) async {
      user = value;
      //Set users nickname if first time playing game
      // TODO add translate var
      if (user!.game_nickname != null) return;
        
      String? enteredName = "";
      
      while(enteredName!.isEmpty) {

        enteredName = await inputDialog(context,
            "Enter a nickname (can be changed in settings)", "Name", true);

        // If cancelled then go back
        if (enteredName == null) return;
        if (enteredName.isEmpty) continue;

        // I hate this btw
        // This is a empty char added for version control
        enteredName = enteredName + "\u{200E}";

        user!.game_nickname = enteredName;
        
        try {//Try setting nickname in backend. Fails if it was not unique
          await locator<UserService>().updateUser(user!);
        } catch(err) {
          continue;
        }
      }

      // If no name is entered then use the users real name
      //Vi får collisions här ändå
      // user!.game_nickname = nickname == "" ? user!.firstname : nickname;
    

      //Här också tar bort för att det är ett objekt som användaren inte har förrän spel klart 
      // setState(() {
      //   user!.game_score = 0;
      // });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    return GestureDetector(
        onTap: () => {
              FocusScope.of(context).unfocus(),
            },
        child: Scaffold(
          appBar: AppBar(title: Text("Highscore!")),
          body: Column(
            children: [
              FocusScope(
                  child: Focus(
                onFocusChange: (focus) {
                  print(focus);
                  setState(() {
                    searchFocus = focus;
                  });
                },
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      prefixIcon: searchFocus
                          ? IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.grey[800],
                              ),
                              onPressed: () => FocusScope.of(context).unfocus())
                          : Icon(
                              Icons.search,
                              color: Colors.grey[800],
                            ),
                      hintText: t.songbookSearch,
                      suffixIcon: _controller.text.length > 0
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              color: Colors.grey[800],
                              onPressed: () => setState(() {
                                    _controller.clear();
                                    FocusScope.of(context).unfocus();
                                    results = allScores;
                                  }))
                          : SizedBox.shrink()),
                  onChanged: (search) {
                    List<String> searchTerms =
                        search.toLowerCase().trim().split(new RegExp(r"\s+"));
                    setState(() {
                      initChar = "";
                      //TODO change this with api so it looks better
                      results = allScores.where((test_person) {
                        return searchTerms.every((term) => test_person
                            .user!.game_nickname!
                            .toLowerCase()
                            .contains(term));
                      }).toList();
                    });
                  },
                ),
              )),
              Expanded(
                  child: results.length > 0
                      ? ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                shape: ContinuousRectangleBorder(
                                    side: BorderSide(color: Color(0xFFf77e14))),
                                child: ListTile(
                                  leading: allScores.indexOf(results[index]) < 3
                                      ? _findMedal(
                                          allScores.indexOf(results[index]))
                                      : Text(
                                          "${allScores.indexOf(results[index]) + 1}."),
                                  title: results[index].user!.game_nickname !=
                                          null
                                      ? Text(
                                          "${results[index].user!.game_nickname}")
                                      : Text(
                                          "${results[index].user!.firstname}"),
                                  trailing: Text(
                                      "${results[index].score ?? 0}"),
                                ));
                          },
                        ) // change for translate variable later
                      : const Center(child: Text('No items'))),
            ],
          ), //change to translate var
        ));
  }

  Image _findMedal(int index) {
    switch (index) {
      case 0:
        return Image(image: AssetImage("assets/img/moose_game/gold_medal.png"), width: 36);
      case 1:
        return Image(
            image: AssetImage("assets/img/moose_game/silver_medal.png"), width: 30);
      case 2:
        return Image(
            image: AssetImage("assets/img/moose_game/bronze_medal.png"), width: 25);
      default:
        throw new Exception("Bad index for medal image");
    }
  }
}
