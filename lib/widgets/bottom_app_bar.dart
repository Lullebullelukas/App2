import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fsek_mobile/screens/moose_game/moose_game.dart';
import 'package:fsek_mobile/widgets/easterEgg/animated_nils.dart';
import 'package:fsek_mobile/widgets/easterEgg/easteregg_code_dialog.dart';
import 'package:fsek_mobile/widgets/easterEgg/familyGuyFoset.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/game.service.dart';

class FsekAppBarItem {
  FsekAppBarItem({this.iconData, this.text});
  IconData? iconData;
  String? text;
}

class FsekAppBar extends StatefulWidget {
  FsekAppBar({
    this.items,
    this.centerItemText,
    this.height = 60.0,
    this.iconSize = 24.0,
    this.color,
    this.selectedColor,
    this.notchedShape,
    required this.onTabSelected,
    required this.currentIndex,
  }) {
    assert(this.items!.length == 2 || this.items!.length == 5);
  }
  final List<FsekAppBarItem>? items;
  final String? centerItemText;
  final double height;
  final double iconSize;
  final Color? color;
  final Color? selectedColor;
  final NotchedShape? notchedShape;
  final ValueChanged<int?> onTabSelected;
  final int currentIndex;
  final List<int> easterEggClicksGoal = [6, 1, 2, 2];
  @override
  State<StatefulWidget> createState() => FsekAppBarState();
}

class FsekAppBarState extends State<FsekAppBar> {
  List<int> appBarItemsClickedAmounts = [0, 0, 0, 0]; //For activating easter egg codes
  DateTime lastEasterEggClick = DateTime.now();
  bool bababoeActive = false;
  bool fosetActive = false;

  void _processEasterEggClick(int? index) async {
    // takes index of which nav bar item was clicked
    if (index == null) return;
    if (DateTime.now().difference(lastEasterEggClick).inSeconds > 5) {
      appBarItemsClickedAmounts = [0, 0, 0, 0];
    }
    lastEasterEggClick = DateTime.now();

    for (int i = 0; i < index; i++) {
      if (appBarItemsClickedAmounts[i] != widget.easterEggClicksGoal[i]) {
        return; // Not registering clicks at index beyond completed ones
      }
    }
    appBarItemsClickedAmounts[index]++;
    if (!listEquals(appBarItemsClickedAmounts, widget.easterEggClicksGoal)) {
      return;
    }
    // 6 1 2 2 clicked: Easter egg codes activated
    String? easterEggCode = await easterEggCodeDialog(context);
    if (easterEggCode == null) return; // User cancels dialog i think
    // EDIT: yes it is, without it it goes on forever
    //For more than one code, please don't stack else if's
    switch (easterEggCode) {
      case "bababoe":
        setState(() {
          bababoeActive = true;
          Future.delayed(const Duration(seconds: 9), () {
            setState(() {
              bababoeActive = false;
            });
          });
        });
        break;

      case "wow":
        AudioPlayer().play(AssetSource('audio/wow.mp3'));
        break;

      case "föset":
        setState(() {
          fosetActive = true;
          Future.delayed(const Duration(seconds: 14), () {
            setState(() {
              fosetActive = false;
            });
          });
        });
        break;

      case "moosegame":
        Navigator.push(context, MaterialPageRoute(builder: (context) => (MooseGamePage())));
        break;

      case "reset score":
        locator<GameScoreService>().resetScore();
        break;

      case "reset name":
        locator<GameScoreService>().resetName();
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items!.length, (int index) {
      return _buildTabItem(
        item: widget.items![index],
        index: index,
        onPressed: (i) => {
          _processEasterEggClick(i),
          widget.onTabSelected(i),
        },
      );
    });
    // Creates a middle space for the FloatingActionButton (usually nollning-button)
    // items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
        shape: widget.notchedShape,
        padding: EdgeInsets.zero,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Visibility(child: AnimatedNils(), visible: bababoeActive),
            Visibility(child: familyGuyFoset(), visible: fosetActive),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items,
            ),
          ],
        ));
  }

  // Widget _buildMiddleTabItem() {
  //   return Expanded(
  //     child: SizedBox(
  //       height: widget.height,
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           SizedBox(height: widget.iconSize),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTabItem({
    required FsekAppBarItem item,
    int? index,
    ValueChanged<int?>? onPressed,
  }) {
    Color? color = widget.currentIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      key: Key(item.text!.toLowerCase() + "_btn"),
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed!(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: widget.iconSize),
                Text(
                  item.text!,
                  style: TextStyle(color: color),
                  softWrap: false,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
