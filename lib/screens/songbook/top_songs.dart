import 'package:fsek_mobile/april_fools.dart';
import 'package:flutter/material.dart';
import 'package:fsek_mobile/models/songbook/songbookEntry.dart';
import 'package:fsek_mobile/screens/songbook/song.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/song.service.dart';
import 'package:fsek_mobile/services/songbook.service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopSongsPage extends StatefulWidget {
  @override
  _TopSongsPageState createState() => _TopSongsPageState();
}

class _TopSongsPageState extends State<TopSongsPage> with TickerProviderStateMixin {
  List<SongbookEntry> songs = [];
  List<SongbookEntry> TopSongs = [];

  //bad helpvariables that are most likely unneeded
  bool searchFocus = false;
  int initChar = 1;

  TextEditingController _controller = TextEditingController();

  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    int num_top_songs = 10;
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1400));
    locator<SongbookService>().getTopSongs(num_top_songs).then((value) => setState(() {
          this.songs = value;
          songs.sort((a, b) => a.title!.compareTo(b.title!)); // handle null?
          TopSongs = List.from(songs);
        }));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return TopSongs == []
        ? Scaffold(
            //change text
            appBar: AppBar(title: Text(t.songbookSongbook)),
            body: Center(child: CircularProgressIndicator(color: (isAprilFools ? Color(0xFFF17F9F) : Colors.orange[600]))))
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                  appBar: AppBar(
                    title: Text(t.songbookSongbook),
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: songs.isNotEmpty
                            ? ListView(
                                children: songs.map((song) => _generateSongTile(song)).toList(),
                              )
                            : Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(t.songbookNoMatches),
                              ),
                      )
                    ],
                  ),
                ),
              );
  }

  Widget _generateSongTile(SongbookEntry song) {
    Color color;

    List<Widget> index = [];
    //deciding colour
    if (initChar == 1)
      color = Color.fromARGB(255, 255, 215, 0);
    else if (initChar == 2)
      color = Color.fromARGB(255, 192, 192, 192);
    else if (initChar == 3)
      color = Color.fromARGB(255, 205, 127, 50);
    else
      color = Color.fromARGB(255, 243, 240, 241);

    index.add(Container(
      decoration: BoxDecoration(color: color),
      child: ListTile(
        title: Text(
          initChar.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ));
    initChar += 1;

    return Column(
      children: index +
          [
            Container(
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.grey[400]!),
                )),
                child: InkWell(
                  onTap: () => openSong(song.id!),
                  child: ListTile(title: Text(song.title == null ? "" : song.title!)),
                ))
          ],
    );
  }

  void openSong(int id) {
    locator<SongService>().getSong(id).then((song) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SongPage(song: song)));
    });
  }
}
