import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fsek_mobile/themes.dart';
import 'package:fsek_mobile/april_fools.dart';
import 'models/destination.dart';
import 'models/user/user.dart';
import 'services/service_locator.dart';
import 'services/theme.service.dart';
import 'widgets/bottom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';

class ContentWrapper extends StatefulWidget {
  ContentWrapper(this.navbarDestinations, this.user, this.onNavigation, this.messages) : super();

  final List<Destination> navbarDestinations;
  final User? user;
  final StreamController? onNavigation;
  final List<String> messages;

  @override
  _ContentWrapperState createState() => _ContentWrapperState();
}

class _ContentWrapperState extends State<ContentWrapper> with TickerProviderStateMixin<ContentWrapper> {
  late List<Key> _destinationKeys;
  late List<AnimationController> _faders;
  int _currentIndex = 0;
  int _soundCounter = 0;

  // Time that the F-logo was first pressed, used to reset counter after a while
  DateTime? _logoFirstPress;

  // Has the logo been pressed yet
  bool _logoPressed = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // Sound behaviours on ios and android, mainly to make iphone use speakers properly
  final AudioContext audioContext = AudioContext(
    iOS: AudioContextIOS(
      //defaultToSpeaker: true,
      category: AVAudioSessionCategory.playback,
      options: {
        //AVAudioSessionOptions.defaultToSpeaker,
        AVAudioSessionOptions.mixWithOthers,
      },
    ),
    android: AudioContextAndroid(
      isSpeakerphoneOn: true,
      stayAwake: true,
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.game,
      audioFocus: AndroidAudioFocus.none,
    ),
  );

  @override
  void initState() {
    //generate animation controllers for all destinations so we can fade them in and out
    _faders = widget.navbarDestinations.map<AnimationController>((Destination destination) {
      return AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    }).toList();
    //set the fader of the starting page to 1 so it's visible
    _faders[_currentIndex].value = 1.0;
    //generate a list of globalkeys which we shall assign to our destinations
    //Each destination shall have its own key
    _destinationKeys = List<Key>.generate(widget.navbarDestinations.length, (int index) => GlobalKey()).toList();

    // For customizing sound behaviours
    AudioPlayer.global.setAudioContext(audioContext);

    super.initState();
  }

  @override
  void dispose() {
    for (AnimationController controller in _faders) controller.dispose();
    super.dispose();
  }

  playSound() async {
    List<String> files = ["moose.mp4", "moose2.mp4"];
    // Get a random index between 0 and 1 and play matching sound
    var random = new Random();
    int index = random.nextInt(2);
    String toPlay = files[index];
    AudioPlayer().play(AssetSource('audio/' + toPlay));
  }

  @override
  Widget build(BuildContext context) {
    //index to string
    var t = AppLocalizations.of(context)!;
    Map<int, String> indexToTitle = {
      0: t.news,
      1: t.calendar,
      2: t.home, //these maybe needs to change
      3: t.notifications,
      4: t.other,
    };
    // Shows state messages
    for (String message in widget.messages) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        // backgroundColor: Color(0xFFFFC38D),
      ));
    }
    widget.messages.clear(); // clears all showed messages

    Widget _header = Padding(
        padding: EdgeInsets.all(6),
        child: Row(
          children: [
            IconButton(
              icon: Image(
                image: (Theme.of(context).brightness == Brightness.dark ? 
                  AssetImage("assets/img/f_logo_white.png") : AssetImage("assets/img/f_logo_black.png")),
                width: 64,
              ),
              onPressed: () => {
                _soundCounter++,
                if (!_logoPressed)
                  {
                    _logoFirstPress = DateTime.now(),
                    _logoPressed = true,
                  }
                else if (DateTime.now().difference(_logoFirstPress!).inSeconds > 20)
                  {
                    _soundCounter = 1,
                    _logoFirstPress = DateTime.now(),
                    _logoPressed = true,
                  },
                if (_soundCounter == 3)
                  {
                    playSound(),
                    _soundCounter = 0,
                    _logoPressed = false,
                  }
              },
              padding: EdgeInsets.all(0.0),
              iconSize: 64,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              AppLocalizations.of(context)!.fGuildName,
              style: Theme.of(context).textTheme.headlineSmall,
            )
          ],
        ));

    //removes top appbar if current page is home page, remove after nollning!!!!!!!
    // if (_currentIndex == 4) _header = Container();

    return Stack(children: [
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: SafeArea(
              child: Column(children: [
            _header,
            Expanded(
                child: Stack(
                    children: widget.navbarDestinations.map((Destination destination) {
              final Widget view = FadeTransition(
                opacity: _faders[destination.index]
                    .drive(CurveTween(curve: Curves.fastOutSlowIn)), //set opacity according to animation
                child: KeyedSubtree(
                  //set a global key to a widget so we preserve its state and subtree on a tree rebuild
                  key: _destinationKeys[destination.index],
                  child: destination.widget,
                ),
              );
              //When currently selected destination we want to render and animate it
              if (destination.index == _currentIndex) {
                _faders[destination.index].forward();
                return view;
              } else {
                //when one of the other destinations
                _faders[destination.index].reverse();
                if (_faders[destination.index].isAnimating) {
                  //ignore pointer so the destinations aren't interactable when animating
                  return IgnorePointer(child: view);
                }
                return Offstage(child: view); //move offstage to ensure they aren't painted when not visible
              }
            }).toList())),
          ])),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            // This should be set to the same color as backgroundColor of FsekAppBar
            color: Theme.of(context).bottomAppBarTheme.color,
            child: FsekAppBar(
              selectedColor: Theme.of(context).colorScheme.onPrimaryContainer,
              color: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).bottomAppBarTheme.color,
              currentIndex: _currentIndex,
              centerItemText: "F-sektionen",
              onTabSelected: (int? index) {
                setState(() {
                  _currentIndex = index ?? 0;
                });
                widget.onNavigation!.add(widget.navbarDestinations[_currentIndex].widget.runtimeType);
              },
              items: [
                ...widget.navbarDestinations.map((Destination destination) {
                  return FsekAppBarItem(iconData: destination.icon, text: indexToTitle[destination.index]);
                }).toList()
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
