import 'package:fsek_mobile/april_fools.dart';
import 'package:flutter/material.dart';
import 'package:fsek_mobile/models/songbook/songbookEntry.dart';
import 'package:fsek_mobile/screens/songbook/song.dart';
import 'package:fsek_mobile/screens/songbook/hmmm.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/song.service.dart';
import 'package:fsek_mobile/services/songbook.service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fsek_mobile/screens/songbook/top_songs.dart';

class SongbookPage extends StatefulWidget {
  @override
  _SongbookPageState createState() => _SongbookPageState();
}

class _SongbookPageState extends State<SongbookPage>
    with TickerProviderStateMixin {
  List<SongbookEntry> songs = [];
  List<SongbookEntry> allSongs = [];
  List<SongbookEntry> topSongs = [];

  bool searchFocus = false;
  String initChar = "";

  TextEditingController _controller = TextEditingController();

  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1400),
    );

    // Fetch all songs
    locator<SongbookService>().getSongbook().then((value) {
      setState(() {
        this.songs = value;
        songs.sort((a, b) => a.title!.compareTo(b.title!)); // Handle null?
        allSongs = List.from(songs);
      });
      print("All songs loaded: ${songs.length}");
    });

    // Fetch top songs
    int num_songs = 3; // Number of top songs to fetch
    locator<SongbookService>().getTopSongs(num_songs).then((value) {
      setState(() {
        this.topSongs = value;
        topSongs.sort((a, b) => a.title!.compareTo(b.title!)); // Handle null?
      });
      print("Top songs loaded: ${topSongs.length}");
    });

    setRotation(360);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setRotation(int degrees) {
    final angle = degrees * 3.1415 / 180;
    animation =
        Tween<double>(begin: 0, end: angle).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return allSongs.isEmpty
        ? Scaffold(
            appBar: AppBar(
              title: Text(t.songbookSongbook),
            ),
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AnimatedBuilder(
              animation: animation,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(t.songbookSongbook),
                  actions: [
                    // Add actions here
                    IconButton(
                      icon: Icon(Icons.emoji_events, color: Theme.of(context).colorScheme.onPrimary), // Trophy icon
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TopSongsPage()),
                        );
                      },
                    ),
                  ],
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    FocusScope(
                      child: Focus(
                        onFocusChange: (focus) {
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
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    onPressed: () =>
                                        FocusScope.of(context).unfocus(),
                                  )
                                : Icon(
                                    Icons.search,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                            hintText: t.songbookSearch,
                            suffixIcon: _controller.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear),
                                    color: Theme.of(context).colorScheme.onSurface,
                                    onPressed: () => setState(() {
                                      _controller.clear();
                                      FocusScope.of(context).unfocus();
                                      songs = List.from(
                                          allSongs); // Reset songs list
                                    }),
                                  )
                                : SizedBox.shrink(),
                          ),
                          onChanged: (search) {
                            // Easter egg logic
                            if (search == "hmm") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HmmPage()),
                              );
                            } else if (search == "do a barrel roll") {
                              FocusScope.of(context).unfocus();
                              animationController.forward(from: 0);
                            }
                            List<String> searchTerms = search
                                .toLowerCase()
                                .trim()
                                .split(RegExp(r"\s+"));
                            setState(() {
                              initChar = "";
                              songs = allSongs.where((song) {
                                return searchTerms.every((term) =>
                                    song.title!.toLowerCase().contains(term));
                              }).toList();
                            });
                          },
                        ),
                      ),
                    ),
                    // End of search bar

                    // // Top Songs button with expansion
                    // if (topSongs.isNotEmpty) // Ensure topSongs is not empty
                    //   //create a button which goes to the top_songsPage when pressed
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 8.0),
                    //     child: SizedBox(
                    //       width:
                    //           double.infinity, // Make the button fill the width
                    //       child: ElevatedButton(
                    //         onPressed: () {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => TopSongsPage()),
                    //           );
                    //         },
                    //         style: ElevatedButton.styleFrom(
                    //           padding: EdgeInsets.all(
                    //               16.0), // Adjust padding inside the button
                    //           backgroundColor:
                    //               Colors.grey[300], // Button background color
                    //           elevation: 0, // Remove shadow
                    //         ),
                    //         child: Text(
                    //           "Vanligaste sångerna",
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold, // Bold text
                    //             color: Colors.black, // Black text color
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),

                    Expanded(
                      child: songs.isNotEmpty
                          ? ListView(
                              children: songs
                                  .map((song) => _generateSongTile(song))
                                  .toList(),
                            )
                          : Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(t.songbookNoMatches),
                            ),
                    ),
                    // End of list of songs
                  ],
                ),
              ),
              // Part of doing a barrel roll
              builder: (context, child) =>
                  Transform.rotate(angle: animation.value, child: child),
            ),
          );
  }

  Widget _generateSongTile(SongbookEntry song) {
    List<Widget> index = [];
    if (song.title![0] != initChar) {
      initChar = song.title![0];
      index.add(Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant),
        child: ListTile(
          title: Text(
            initChar,
            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      ));
    }
    return Column(
      children: index +
          [
            Container(
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Theme.of(context).colorScheme.surfaceVariant),
                )),
                child: InkWell(
                  onTap: () => openSong(song.id!),
                  child: ListTile(title: Text(song.title ?? "")),
                ))
          ],
    );
  }

  void openSong(int id) {
    locator<SongService>().getSong(id).then((song) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SongPage(song: song)));
    });
  }
}
