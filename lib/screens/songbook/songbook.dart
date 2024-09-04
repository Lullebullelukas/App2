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
                color: (isAprilFools ? Color(0xFFF17F9F) : Colors.orange[600]),
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
                      icon: Icon(Icons.emoji_events, color: Colors.grey[900]), // Trophy icon
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
                                      color: Colors.grey[800],
                                    ),
                                    onPressed: () =>
                                        FocusScope.of(context).unfocus(),
                                  )
                                : Icon(
                                    Icons.search,
                                    color: Colors.grey[800],
                                  ),
                            hintText: t.songbookSearch,
                            suffixIcon: _controller.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear),
                                    color: Colors.grey[800],
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
        decoration: BoxDecoration(color: Colors.grey[300]),
        child: ListTile(
          title: Text(
            initChar,
            style: TextStyle(fontWeight: FontWeight.bold),
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
                  bottom: BorderSide(color: Colors.grey[400]!),
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

// import 'package:fsek_mobile/april_fools.dart';
// import 'package:flutter/material.dart';
// import 'package:fsek_mobile/models/songbook/songbookEntry.dart';
// import 'package:fsek_mobile/screens/songbook/song.dart';
// import 'package:fsek_mobile/screens/songbook/hmmm.dart';
// import 'package:fsek_mobile/services/service_locator.dart';
// import 'package:fsek_mobile/services/song.service.dart';
// import 'package:fsek_mobile/services/songbook.service.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class SongbookPage extends StatefulWidget {
//   @override
//   _SongbookPageState createState() => _SongbookPageState();
// }

// class _SongbookPageState extends State<SongbookPage>
//     with TickerProviderStateMixin {
//   List<SongbookEntry> songs = [];
//   List<SongbookEntry> allSongs = [];
//   List<SongbookEntry> topSongs = [];

//   // Variables that might not be necessary
//   bool searchFocus = false;
//   String initChar = "";

//   TextEditingController _controller = TextEditingController();

//   late AnimationController animationController;
//   late Animation<double> animation;

//   @override
//   void initState() {
//     animationController = AnimationController(
//         vsync: this, duration: Duration(milliseconds: 1400));

//     // Fetch all songs
//     locator<SongbookService>().getSongbook().then((value) => setState(() {
//           this.songs = value;
//           songs.sort((a, b) => a.title!.compareTo(b.title!)); // handle null?
//           allSongs = List.from(songs);
//         }));

//     // Fetch top songs
//     int num_songs = 5; // Number of top songs to fetch
//     locator<SongbookService>()
//         .getTopSongs(num_songs)
//         .then((value) => setState(() {
//               this.topSongs = value;
//               topSongs
//                   .sort((a, b) => a.title!.compareTo(b.title!)); // handle null?
//             }));

//     setRotation(360);

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void setRotation(int degrees) {
//     final angle = degrees * 3.1415 / 180;
//     animation =
//         Tween<double>(begin: 0, end: angle).animate(animationController);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var t = AppLocalizations.of(context)!;
//     return allSongs.isEmpty
//         ? Scaffold(
//             appBar: AppBar(title: Text(t.songbookSongbook)),
//             body: Center(
//               child: CircularProgressIndicator(
//                 color: (isAprilFools ? Color(0xFFF17F9F) : Colors.orange[600]),
//               ),
//             ),
//           )
//         : GestureDetector(
//             onTap: () => FocusScope.of(context).unfocus(),
//             child: AnimatedBuilder(
//               animation: animation,
//               child: Scaffold(
//                 appBar: AppBar(
//                   title: Text(t.songbookSongbook),
//                 ),
//                 body: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Search bar
//                     FocusScope(
//                       child: Focus(
//                         onFocusChange: (focus) {
//                           setState(() {
//                             searchFocus = focus;
//                           });
//                         },
//                         child: TextField(
//                           controller: _controller,
//                           decoration: InputDecoration(
//                             prefixIcon: searchFocus
//                                 ? IconButton(
//                                     icon: Icon(
//                                       Icons.arrow_back,
//                                       color: Colors.grey[800],
//                                     ),
//                                     onPressed: () =>
//                                         FocusScope.of(context).unfocus(),
//                                   )
//                                 : Icon(
//                                     Icons.search,
//                                     color: Colors.grey[800],
//                                   ),
//                             hintText: t.songbookSearch,
//                             suffixIcon: _controller.text.isNotEmpty
//                                 ? IconButton(
//                                     icon: Icon(Icons.clear),
//                                     color: Colors.grey[800],
//                                     onPressed: () => setState(() {
//                                       _controller.clear();
//                                       FocusScope.of(context).unfocus();
//                                       songs = List.from(
//                                           allSongs); // Reset songs list
//                                     }),
//                                   )
//                                 : SizedBox.shrink(),
//                           ),
//                           onChanged: (search) {
//                             // Easter egg logic
//                             if (search == "hmm") {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => HmmPage()),
//                               );
//                             } else if (search == "do a barrel roll") {
//                               FocusScope.of(context).unfocus();
//                               animationController.forward(from: 0);
//                             }
//                             List<String> searchTerms = search
//                                 .toLowerCase()
//                                 .trim()
//                                 .split(RegExp(r"\s+"));
//                             setState(() {
//                               initChar = "";
//                               songs = allSongs.where((song) {
//                                 return searchTerms.every((term) =>
//                                     song.title!.toLowerCase().contains(term));
//                               }).toList();
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     // End of search bar

//                     // Top Songs button with expansion
//                     ExpansionTile(
//                       title: Text(
//                         'Top Songs',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       children: topSongs
//                           .map((song) => _generateSongTile(song))
//                           .toList(),
//                     ),
//                     // End of Top Songs button

//                     // List of songs
//                     Expanded(
//                       child: songs.isNotEmpty
//                           ? ListView(
//                               children: songs
//                                   .map((song) => _generateSongTile(song))
//                                   .toList(),
//                             )
//                           : Padding(
//                               padding: EdgeInsets.all(16),
//                               child: Text(t.songbookNoMatches),
//                             ),
//                     ),
//                     // End of list of songs
//                   ],
//                 ),
//               ),
//               // Part of doing a barrel roll
//               builder: (context, child) =>
//                   Transform.rotate(angle: animation.value, child: child),
//             ),
//           );
//   }

//   Widget _generateSongTile(SongbookEntry song) {
//     List<Widget> index = [];
//     if (song.title![0] != initChar) {
//       initChar = song.title![0];
//       index.add(Container(
//         decoration: BoxDecoration(color: Colors.grey[300]),
//         child: ListTile(
//           title: Text(
//             initChar,
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ));
//     }
//     return Column(
//       children: index +
//           [
//             Container(
//                 decoration: BoxDecoration(
//                     border: Border(
//                   bottom: BorderSide(color: Colors.grey[400]!),
//                 )),
//                 child: InkWell(
//                   onTap: () => openSong(song.id!),
//                   child: ListTile(title: Text(song.title ?? "")),
//                 ))
//           ],
//     );
//   }

//   void openSong(int id) {
//     locator<SongService>().getSong(id).then((song) {
//       Navigator.push(context,
//           MaterialPageRoute(builder: (context) => SongPage(song: song)));
//     });
//   }
// }








// import 'package:fsek_mobile/april_fools.dart';
// import 'package:flutter/material.dart';
// import 'package:fsek_mobile/models/songbook/songbookEntry.dart';
// import 'package:fsek_mobile/screens/songbook/song.dart';
// import 'package:fsek_mobile/screens/songbook/hmmm.dart';
// import 'package:fsek_mobile/services/service_locator.dart';
// import 'package:fsek_mobile/services/song.service.dart';
// import 'package:fsek_mobile/services/songbook.service.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:fsek_mobile/screens/songbook/top_songs.dart';

// class SongbookPage extends StatefulWidget {
//   @override
//   _SongbookPageState createState() => _SongbookPageState();
// }

// class _SongbookPageState extends State<SongbookPage>
//     with TickerProviderStateMixin {
//   List<SongbookEntry> songs = [];
//   List<SongbookEntry> allSongs = [];
//   List<SongbookEntry> topSongs = [];

//   //bad helpvariables that are most likely unneeded
//   bool searchFocus = false;
//   String initChar = "";

//   TextEditingController _controller = TextEditingController();

//   late AnimationController animationController;
//   late Animation<double> animation;

//   @override
//   void initState() {
//     animationController = AnimationController(
//         vsync: this, duration: Duration(milliseconds: 1400));
//     locator<SongbookService>().getSongbook().then((value) => setState(() {
//           this.songs = value;
//           songs.sort((a, b) => a.title!.compareTo(b.title!)); // handle null?
//           allSongs = List.from(songs);
//         }));


//         //Where should the number of songs variable be set?
//     int num_songs = 5;
//     locator<SongbookService>()
//         .getTopSongs(num_songs)
//         .then((value) => setState(() {
//               this.topSongs = value;
//               topSongs
//                   .sort((a, b) => a.title!.compareTo(b.title!)); // handle null?
//             }));

//     setRotation(360);

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void setRotation(int degrees) {
//     final angle = degrees * 3.1415 / 180;

//     animation =
//         Tween<double>(begin: 0, end: angle).animate(animationController);
//   }

//   Widget build(BuildContext context) {
//     var t = AppLocalizations.of(context)!;
//     return allSongs.isEmpty
//         ? Scaffold(
//             appBar: AppBar(title: Text(t.songbookSongbook)),
//             body: Center(
//               child: CircularProgressIndicator(
//                 color: (isAprilFools ? Color(0xFFF17F9F) : Colors.orange[600]),
//               ),
//             ),
//           )
//         : GestureDetector(
//             onTap: () => FocusScope.of(context).unfocus(),
//             child: AnimatedBuilder(
//               animation: animation,
//               child: Scaffold(
//                 appBar: AppBar(
//                   title: Text(t.songbookSongbook),
//                 ),
//                 body: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     FocusScope(
//                       child: Focus(
//                         onFocusChange: (focus) {
//                           setState(() {
//                             searchFocus = focus;
//                           });
//                         },
//                         child: TextField(
//                           controller: _controller,
//                           decoration: InputDecoration(
//                             prefixIcon: searchFocus
//                                 ? IconButton(
//                                     icon: Icon(
//                                       Icons.arrow_back,
//                                       color: Colors.grey[800],
//                                     ),
//                                     onPressed: () =>
//                                         FocusScope.of(context).unfocus(),
//                                   )
//                                 : Icon(
//                                     Icons.search,
//                                     color: Colors.grey[800],
//                                   ),
//                             hintText: t.songbookSearch,
//                             suffixIcon: _controller.text.length > 0
//                                 ? IconButton(
//                                     icon: Icon(Icons.clear),
//                                     color: Colors.grey[800],
//                                     onPressed: () => setState(() {
//                                       _controller.clear();
//                                       FocusScope.of(context).unfocus();
//                                       songs = allSongs;
//                                     }),
//                                   )
//                                 : SizedBox.shrink(),
//                           ),
//                           onChanged: (search) {
//                             // Easter egg logic
//                             if (search == "hmm") {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => HmmPage()),
//                               );
//                             } else if (search == "do a barrel roll") {
//                               FocusScope.of(context).unfocus();
//                               animationController.forward(from: 0);
//                             }
//                             List<String> searchTerms = search
//                                 .toLowerCase()
//                                 .trim()
//                                 .split(RegExp(r"\s+"));
//                             setState(() {
//                               initChar = "";
//                               songs = allSongs.where((song) {
//                                 return searchTerms.every((term) =>
//                                     song.title!.toLowerCase().contains(term));
//                               }).toList();
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     // New widget
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     NewPage()), // Replace NewPage with your widget
//                           );
//                         },
//                         child: Container(
//                           padding: EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Colors.blue,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'Go to New Page',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     // The list of songs or the message when no songs match
//                     Expanded(
//                       child: songs.isNotEmpty
//                           ? ListView(
//                               children: songs
//                                   .map((song) => _generateSongTile(song))
//                                   .toList(),
//                             )
//                           : Padding(
//                               padding: EdgeInsets.all(16),
//                               child: Text(t.songbookNoMatches),
//                             ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Part of doing a barrel roll
//               builder: (context, child) =>
//                   Transform.rotate(angle: animation.value, child: child),
//             ),
//           );
//   }

//   // Widget build(BuildContext context) {
//   //   var t = AppLocalizations.of(context)!;
//   //   return allSongs == []
//   //       ? Scaffold(
//   //           appBar: AppBar(title: Text(t.songbookSongbook)),
//   //           body: Center(
//   //               child: CircularProgressIndicator(
//   //                   color: (isAprilFools
//   //                       ? Color(0xFFF17F9F)
//   //                       : Colors.orange[600]))))
//   //       : GestureDetector(
//   //           onTap: () => FocusScope.of(context).unfocus(),
//   //           child: AnimatedBuilder(
//   //               animation: animation,
//   //               child: Scaffold(
//   //                 appBar: AppBar(
//   //                   title: Text(t.songbookSongbook),
//   //                 ),
//   //                 body: Column(
//   //                   crossAxisAlignment: CrossAxisAlignment.start,
//   //                   children: [
//   //                     FocusScope(
//   //                         child: Focus(
//   //                       onFocusChange: (focus) {
//   //                         setState(() {
//   //                           searchFocus = focus;
//   //                         });
//   //                       },
//   //                       child: TextField(
//   //                         controller: _controller,
//   //                         decoration: InputDecoration(
//   //                             prefixIcon: searchFocus
//   //                                 ? IconButton(
//   //                                     icon: Icon(
//   //                                       Icons.arrow_back,
//   //                                       color: Colors.grey[800],
//   //                                     ),
//   //                                     onPressed: () =>
//   //                                         FocusScope.of(context).unfocus())
//   //                                 : Icon(
//   //                                     Icons.search,
//   //                                     color: Colors.grey[800],
//   //                                   ),
//   //                             hintText: t.songbookSearch,
//   //                             suffixIcon: _controller.text.length > 0
//   //                                 ? IconButton(
//   //                                     icon: Icon(Icons.clear),
//   //                                     color: Colors.grey[800],
//   //                                     onPressed: () => setState(() {
//   //                                           _controller.clear();
//   //                                           FocusScope.of(context).unfocus();
//   //                                           songs = allSongs;
//   //                                         }))
//   //                                 : SizedBox.shrink()),
//   //                         onChanged: (search) {
//   //                           //Easteregg:
//   //                           if (search == "hmm") {
//   //                             Navigator.push(
//   //                                 context,
//   //                                 MaterialPageRoute(
//   //                                     builder: (context) => HmmPage()));
//   //                           } else if (search == "do a barrel roll") {
//   //                             FocusScope.of(context).unfocus();
//   //                             animationController.forward(from: 0);
//   //                           }
//   //                           List<String> searchTerms = search
//   //                               .toLowerCase()
//   //                               .trim()
//   //                               .split(new RegExp(r"\s+"));
//   //                           setState(() {
//   //                             initChar = "";
//   //                             songs = allSongs.where((song) {
//   //                               return searchTerms.every((term) =>
//   //                                   song.title!.toLowerCase().contains(term));
//   //                             }).toList();
//   //                           });
//   //                         },
//   //                       ),
//   //                     )),
//   //                     Expanded(
//   //                       child: songs.isNotEmpty
//   //                           ? ListView(
//   //                               children: songs
//   //                                   .map((song) => _generateSongTile(song))
//   //                                   .toList(),
//   //                             )
//   //                           : Padding(
//   //                               padding: EdgeInsets.all(16),
//   //                               child: Text(t.songbookNoMatches),
//   //                             ),
//   //                     )
//   //                   ],
//   //                 ),
//   //               ),
//   //               //Part of doing a barrel roll
//   //               builder: (context, child) =>
//   //                   Transform.rotate(angle: animation.value, child: child)));
//   // }

//   Widget _generateSongTile(SongbookEntry song) {
//     //This way of doing it is probably really stupid. but so be it
//     List<Widget> index = [];
//     if (song.title![0] != initChar) {
//       initChar = song.title![0];
//       index.add(Container(
//         decoration: BoxDecoration(color: Colors.grey[300]),
//         child: ListTile(
//           title: Text(
//             initChar,
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ));
//     }
//     return Column(
//       children: index +
//           [
//             Container(
//                 decoration: BoxDecoration(
//                     border: Border(
//                   bottom: BorderSide(color: Colors.grey[400]!),
//                 )),
//                 child: InkWell(
//                   onTap: () => openSong(song.id!),
//                   child: ListTile(
//                       title: Text(song.title == null ? "" : song.title!)),
//                 ))
//           ],
//     );
//   }

//   Widget _generateSongTile(SongbookEntry song) {
//     //This way of doing it is probably really stupid. but so be it
//     List<Widget> index = [];
//     if (song.title![0] != initChar) {
//       initChar = song.title![0];
//       index.add(Container(
//         decoration: BoxDecoration(color: Colors.grey[300]),
//         child: ListTile(
//           title: Text(
//             initChar,
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ));
//     }
//     return Column(
//       children: index +
//           [
//             Container(
//                 decoration: BoxDecoration(
//                     border: Border(
//                   bottom: BorderSide(color: Colors.grey[400]!),
//                 )),
//                 child: InkWell(
//                   onTap: () => openSong(song.id!),
//                   child: ListTile(
//                       title: Text(song.title == null ? "" : song.title!)),
//                 ))
//           ],
//     );
//   }

//   void openSong(int id) {
//     locator<SongService>().getSong(id).then((song) {
//       Navigator.push(context,
//           MaterialPageRoute(builder: (context) => SongPage(song: song)));
//     });
//   }
// }
