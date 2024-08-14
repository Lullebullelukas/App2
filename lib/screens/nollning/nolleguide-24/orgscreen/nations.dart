import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';


class NationScreenPage extends StatefulWidget {
  @override
  _NationScreenState createState() => _NationScreenState();
}



class _NationScreenState extends State<NationScreenPage> {

  void initState(){
    super.initState();
  }


  Widget build(BuildContext context){

    var t =  AppLocalizations.of(context)!;

    String backgroundPaperPath = "assets/img/nollning-24/nolleguide/nolleguide_paper.png";
    String backgroundWoodPath = "assets/img/nollning-24/nolleguide/wood_background.png";

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
      ),
      body: InteractiveViewer(
        child: Container(
          child:
            Stack(
              children: [
                Positioned.fill(child: Image.asset(backgroundWoodPath, fit: BoxFit.fill)),
                Positioned.fill(child: Image.asset(backgroundPaperPath, fit: BoxFit.fill,)),
                Container(
                  margin: EdgeInsets.only(top: 70, left: 50, right: 50),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child:
                      Text(
                        t.nations,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Testament",
                            fontSize: screenWidth/10,
                            color: Color(0xFF540909)
                        )
                      )
                    ),
                    SizedBox(height: 10),
                    Text(
                      t.nationsInfo,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: screenWidth/25,
                        ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                              onPressed: () {launchUrl(Uri.parse(t.nationsWebsite));}, 
                              style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(),
                                    shape: BeveledRectangleBorder(
                                      borderRadius: BorderRadius.horizontal()
                                    ),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    minimumSize: Size(0,0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap
                                    ),
                              child: Text(
                                t.nationsWebsite,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF5269D1),
                                  fontSize: screenWidth/25
                                )
                              )
                        )
                  ],
                )
                )
              ],
            )
        )
      ),
    );

  }
}