import 'package:fsek_mobile/services/abstract.service.dart';
import 'package:fsek_mobile/models/moose_game/game_score_entry.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/user.service.dart';
import 'package:fsek_mobile/models/user/user.dart';

class GameScoreService extends AbstractService {
  User? user;

  Future<List<GameScoreEntry>> getScores() async {
    Map json = await AbstractService.get("/game_scores");

    List<GameScoreEntry> result = (json['game_scores'] as List)
        .map((data) => GameScoreEntry.fromJson(data))
        .toList();

    // remove all users which use their real name
    // If this isn't done I would have to mess with real names
    // to get version control and stop bad actors
    result.removeWhere((element) => element.user!.game_nickname == null);

    // remove all names without a blank char in them to stop bad actors on old versions
    // All users who update their names on the new version will have a blank char in them
    // therefore (pretty much) only users on old versions will be removed
    result.removeWhere((element) => !element.user!.game_nickname!.contains("\u{200E}"));
    return result;
  }
  Future<Map> postScore({ score = int }) async {
    return AbstractService.post("/game_scores", mapBody: { 
      "score": score,
      "user": await locator<UserService>().getUser()
    });
  }
  Future<Map> resetScore() async {
    return AbstractService.post("/game_scores", mapBody: { 
      "score": 0,
      "user": await locator<UserService>().getUser()
    });
  }
  Future<Map> resetName() async {
    user = await locator<UserService>().getUser();

    user!.game_nickname = null;

    return await locator<UserService>().updateUser(user!);
  }
}