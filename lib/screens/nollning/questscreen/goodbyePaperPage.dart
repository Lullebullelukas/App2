import 'package:flutter/material.dart';

class GoodbyePaperPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String locale = Localizations.localeOf(context).toString();
    String woodBoardPath = "assets/img/nollning-24/uppdrag/questscreen_woodboard_background.png";
    String goodbyePaperPath = locale == "sv" ? "assets/img/nollning-24/uppdrag/questscreen_goodbye_paper_cropped.png" : "assets/img/nollning-24/uppdrag/questscreen_goodbye_paper_english.png";

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 70, 43, 17),
          //Color.fromARGB(255, 125, 80, 38),// Transparent background
          elevation: 0, // Remove shadow
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary), // Back arrow icon
            onPressed: () {
              Navigator.pop(context); // Go back to the previous screen
            },
          ),
        ),
        body: Stack(
          children: [
            //Background
            Positioned.fill(
                child: Image.asset(
              woodBoardPath,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            )),
            Center(
                child: Image.asset(
              goodbyePaperPath,
              width: MediaQuery.of(context).size.width * 0.9, // Adjust width as needed

              height: MediaQuery.of(context).size.height * 0.8,
              fit: BoxFit.contain,
            )),
          ],
        ));
  }
}
