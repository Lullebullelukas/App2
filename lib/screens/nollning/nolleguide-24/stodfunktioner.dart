import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO fix refactor, dont do this... mvh Samuel

class StodFunktionerScreenPage extends StatefulWidget {
  @override
  _StodFunktionerScreenState createState() => _StodFunktionerScreenState();
}

Future<void> _launchPhoneNumber(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

Future<void> _launchMail(String email) async {
  final Uri launchUri = Uri(
    scheme: 'mailto',
    path: email,
  );
  await launchUrl(launchUri);
}

Future<void> _launchAdress(String adress) async {
  final Uri launchUri = Uri(
    scheme: 'geo',
    queryParameters: {'q': adress},
  );
  await launchUrl(launchUri);
}

class _StodFunktionerScreenState extends State<StodFunktionerScreenPage> {
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    String backgroundPaperPath = "assets/img/nollning-24/nolleguide/nolleguide_paper.png";
    String backgroundWoodPath = "assets/img/nollning-24/nolleguide/wood_background.png";

    double screenWidth = MediaQuery.of(context).size.width;

    var t = AppLocalizations.of(context)!;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
        ),
        body: InteractiveViewer(
            panEnabled: true,
            child: SingleChildScrollView(
                child: Stack(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset(backgroundWoodPath),
                        Image.asset(backgroundPaperPath),
                        Container(
                            margin: EdgeInsets.only(top: 100, left: 50, right: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(t.supportFunctions, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Testament", fontSize: screenWidth / 15, color: Color(0xFF540909))),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  t.supportIntro,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, fontSize: screenWidth / 29),
                                ),
                                SizedBox(height: 50),
                                Text(
                                  t.supportImportantContacts,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Testament", fontSize: screenWidth / 24, color: Color(0xFF540909)),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  t.supportImportantContactsContent,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  t.supportEmergency,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: screenWidth / 29),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  t.schoolCareerCousellor,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  t.schoolCareerCousellorContent,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  t.careerCounsellorOne,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                                ),
                                Row(
                                  children: [
                                    Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                    ElevatedButton(
                                        onPressed: () {
                                          _launchPhoneNumber(t.careerCounsellorOneNumber);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.only(),
                                            shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            surfaceTintColor: Colors.transparent,
                                            minimumSize: Size(0, 0),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                        child: Text(t.careerCounsellorOneNumber,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenWidth / 29,
                                              color: Color(0xFF5269D1),
                                            ))),
                                  ],
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _launchMail(t.careerCounsellorOneEmail);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                    child: Text(t.careerCounsellorOneEmail, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29)))
                              ],
                            ))
                      ],
                    ),
                    Stack(
                      children: [
                        Image.asset(backgroundWoodPath),
                        Image.asset(backgroundPaperPath),
                        Container(
                            margin: EdgeInsets.only(top: 100, left: 50, right: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.careerCounsellorTwo,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                                ),
                                Row(
                                  children: [
                                    Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                    ElevatedButton(
                                        onPressed: () {
                                          _launchPhoneNumber(t.careerCounsellorTwoNumber);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.only(),
                                            shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            surfaceTintColor: Colors.transparent,
                                            minimumSize: Size(0, 0),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                        child: Text(t.careerCounsellorTwoNumber,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenWidth / 29,
                                              color: Color(0xFF5269D1),
                                            ))),
                                  ],
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _launchMail(t.careerCounsellorTwoEmail);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                    child: Text(t.careerCounsellorTwoEmail, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                SizedBox(height: 20),
                                Text(
                                  t.careerCounsellorThree,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                                ),
                                Row(
                                  children: [
                                    Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                    ElevatedButton(
                                        onPressed: () {
                                          _launchPhoneNumber(t.careerCounsellorThreeNumber);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.only(),
                                            shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            surfaceTintColor: Colors.transparent,
                                            minimumSize: Size(0, 0),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                        child: Text(t.careerCounsellorThreeNumber,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenWidth / 29,
                                              color: Color(0xFF5269D1),
                                            ))),
                                  ],
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _launchMail(t.careerCounsellorThreeEmail);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                    child: Text(t.careerCounsellorThreeEmail, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                SizedBox(height: 40),
                                Text(
                                  t.internationalCoordinators,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  t.internationalCoordinatorsContent,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      launchUrl(Uri.parse(t.internationalCoordinatorsWebsite));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                    child: Text(t.internationalCoordinatorsWebsite, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                SizedBox(height: 40),
                                Text(
                                  t.counsellor,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  t.counsellorContent,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  t.counsellorOne,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                                ),
                                Row(
                                  children: [
                                    Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                    ElevatedButton(
                                        onPressed: () {
                                          _launchPhoneNumber(t.counsellorOneNumber);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.only(),
                                            shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            surfaceTintColor: Colors.transparent,
                                            minimumSize: Size(0, 0),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                        child: Text(t.counsellorOneNumber, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                  ],
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _launchMail(t.counsellorOneEmail);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.only(),
                                      shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      surfaceTintColor: Colors.transparent,
                                      minimumSize: Size(0, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(t.counsellorOneEmail, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                SizedBox(height: 30),
                                Text(
                                  t.studentHealthCenter,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  t.studentHealthCenterContent,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                    ElevatedButton(
                                        onPressed: () {
                                          _launchPhoneNumber(t.studentHealthCenterNumber);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.only(),
                                          shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          surfaceTintColor: Colors.transparent,
                                          minimumSize: Size(0, 0),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(t.studentHealthCenterNumber, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                  ],
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _launchAdress(t.studentHealthCenterAdress);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.only(),
                                      shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      surfaceTintColor: Colors.transparent,
                                      minimumSize: Size(0, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(t.studentHealthCenterAdress, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                ElevatedButton(
                                    onPressed: () {
                                      launchUrl(Uri.parse(t.studentHealthCenterWebsite));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.only(),
                                      shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      surfaceTintColor: Colors.transparent,
                                      minimumSize: Size(0, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(t.studentHealthCenterWebsite, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                              ],
                            ))
                      ],
                    ),
                    Stack(
                      children: [
                        Image.asset(backgroundWoodPath),
                        Image.asset(backgroundPaperPath),
                        Container(
                            margin: EdgeInsets.only(top: 130, left: 50, right: 50),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                t.libuAndSafetyRespresentatives,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                              ),
                              SizedBox(height: 5),
                              Text(
                                t.libuAndSafetyRespresentativesContent,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 28),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(t.presidentOfStudentEqualityComittee, style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 28)),
                                  ElevatedButton(
                                      onPressed: () {
                                        _launchMail(t.presidentOfStudentEqualityComitteeEmail);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(t.presidentOfStudentEqualityComitteeEmail, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 28))),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(t.masterOfConscience, style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 28)),
                                  ElevatedButton(
                                      onPressed: () {
                                        _launchMail(t.masterOfConscienceEmail);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(t.masterOfConscienceEmail, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 28))),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("LiBU: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 28)),
                                  ElevatedButton(
                                      onPressed: () {
                                        _launchMail(t.libuEmail);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(t.libuEmail, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 28))),
                                ],
                              ),
                              SizedBox(height: 100),
                              Text(
                                t.guildAnonContact,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    (launchUrl(Uri.parse(t.guildAnonContactPage)));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(),
                                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(t.guildAnonContactPage, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 28))),
                            ]))
                      ],
                    ),
                    Stack(
                      children: [
                        Image.asset(backgroundWoodPath),
                        Image.asset(backgroundPaperPath),
                        Container(
                            margin: EdgeInsets.only(top: 130, left: 50, right: 50),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                t.supportThereIsHelp,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                              ),
                              SizedBox(height: 5),
                              Text(
                                t.supportThereIsHelpInfoOne,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    (launchUrl(Uri.parse(t.complainPage)));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(),
                                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(t.complainPage, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 28))),
                              SizedBox(height: 20),
                              Text(
                                t.supportThereIsHelpInfoTwo,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                  ElevatedButton(
                                      onPressed: () {
                                        (_launchPhoneNumber(t.supportThereIsHelpNumber));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(t.supportThereIsHelpNumber, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    (_launchMail(t.supportThereIsHelpEmail));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(),
                                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(t.supportThereIsHelpEmail, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                              SizedBox(height: 50),
                              Text(t.supportSelection, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Testament", fontSize: screenWidth / 24, color: Color(0xFF540909))),
                              SizedBox(height: 20),
                              Text(
                                "UMO",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                              ),
                              SizedBox(height: 5),
                              Text(
                                t.umoInfo,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                  ElevatedButton(
                                      onPressed: () {
                                        (_launchPhoneNumber(t.umoNumber));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(t.umoNumber, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                ],
                              ),
                              SizedBox(height: 50),
                              Text(
                                t.psychotherapyClinic,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                              ),
                              SizedBox(height: 5),
                              Text(
                                t.psychotherapyClinicInfo,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                  ElevatedButton(
                                      onPressed: () {
                                        (_launchPhoneNumber(t.psychotherapyClinicNumber));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(t.psychotherapyClinicNumber, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    (_launchMail(t.psychotherapyClinicEmail));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(),
                                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(t.psychotherapyClinicEmail, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                            ]))
                      ],
                    ),
                    Stack(
                      children: [
                        Image.asset(backgroundWoodPath),
                        Image.asset(backgroundPaperPath),
                        Container(
                            margin: EdgeInsets.only(top: 150, left: 50, right: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.healthCenter,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  t.healthCenterInfo,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                                ),
                                SizedBox(height: 60),
                                Text(
                                  t.youngAdultsInLund,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  t.youngAdultsInLundInfo,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                    ElevatedButton(
                                        onPressed: () {
                                          (_launchPhoneNumber(t.youngAdultsInLundNumber));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.only(),
                                          shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          surfaceTintColor: Colors.transparent,
                                          minimumSize: Size(0, 0),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(t.youngAdultsInLundNumber, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                  ],
                                ),
                                SizedBox(height: 60),
                                Text(
                                  t.studentPriests,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  t.studentPriestsInfo,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                    ElevatedButton(
                                        onPressed: () {
                                          (_launchPhoneNumber(t.studentPriestsNumber));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.only(),
                                          shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          surfaceTintColor: Colors.transparent,
                                          minimumSize: Size(0, 0),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(t.studentPriestsNumber, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                  ],
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      (_launchMail(t.studentPriestsEmail));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.only(),
                                      shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      surfaceTintColor: Colors.transparent,
                                      minimumSize: Size(0, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(t.studentPriestsEmail, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                SizedBox(height: 60),
                                Text(
                                  t.girlAndTransgenderHotlineLund,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  t.girlAndTransgenderHotlineLundInfo,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                    onPressed: () {
                                      (launchUrl(Uri.parse(t.girlAndTransgenderHotlineLundWebsite)));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.only(),
                                      shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      surfaceTintColor: Colors.transparent,
                                      minimumSize: Size(0, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(t.girlAndTransgenderHotlineLundWebsite, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                              ],
                            ))
                      ],
                    ),
                    Stack(
                      children: [
                        Image.asset(backgroundWoodPath),
                        Image.asset(backgroundPaperPath),
                        Container(
                            margin: EdgeInsets.only(top: 130, left: 50, right: 50),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                t.kvinnojourenLund,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                              ),
                              SizedBox(height: 5),
                              Text(
                                t.kvinnojourenLundInfo,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                  ElevatedButton(
                                      onPressed: () {
                                        (_launchPhoneNumber(t.kvinnojourenLundNumber));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(t.kvinnojourenLundNumber, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    (_launchMail(t.kvinnojourenLundEmail));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(),
                                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(t.kvinnojourenLundEmail, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                              ElevatedButton(
                                  onPressed: () {
                                    (launchUrl(Uri.parse(t.kvinnojourenlundWebsite)));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(),
                                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(t.kvinnojourenlundWebsite, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                              SizedBox(height: 30),
                              Text(
                                t.mansjouren,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                              ),
                              SizedBox(height: 5),
                              Text(
                                t.mansjourenInfo,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                  ElevatedButton(
                                      onPressed: () {
                                        (_launchPhoneNumber(t.mansjourenNumber));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(t.mansjourenNumber, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    (launchUrl(Uri.parse(t.mansjourenWebsite)));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(),
                                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(t.mansjourenWebsite, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                              SizedBox(height: 30),
                              Text(
                                t.adultPsychEmergencyClinic,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                              ),
                              SizedBox(height: 5),
                              Text(
                                t.adultPsychEmergencyClinicInfo,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                  ElevatedButton(
                                      onPressed: () {
                                        (_launchPhoneNumber(t.adultPsychEmergencyClinicNumber));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(t.adultPsychEmergencyClinicNumber, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                ],
                              ),
                              SizedBox(height: 30),
                              Text(
                                t.mindSuicidehotlite,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                              ),
                              SizedBox(height: 5),
                              Text(
                                t.mindSuicidehotliteInfo,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                  ElevatedButton(
                                      onPressed: () {
                                        (_launchPhoneNumber(t.mindSuicidehotliteNumber));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(t.mindSuicidehotliteNumber, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                ],
                              ),
                              SizedBox(height: 30),
                              Text(
                                t.onCallPerson,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                              ),
                              SizedBox(height: 5),
                              Text(
                                t.onCallPersonInfo,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                  ElevatedButton(
                                      onPressed: () {
                                        (_launchPhoneNumber(t.onCallPersonNumber));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(t.onCallPersonNumber, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                ],
                              ),
                              SizedBox(height: 30),
                              Text(
                                t.onCallPriest,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                              ),
                              SizedBox(height: 5),
                              Text(
                                t.onCallPriestInfo,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                            ]))
                      ],
                    ),
                    Stack(
                      children: [
                        Image.asset(backgroundWoodPath),
                        Image.asset(backgroundPaperPath),
                        Container(
                            margin: EdgeInsets.only(top: 200, left: 50, right: 50),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                t.mariaClinic,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                              ),
                              SizedBox(height: 5),
                              Text(
                                t.mariaClinicInfo,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                  ElevatedButton(
                                      onPressed: () {
                                        (_launchPhoneNumber(t.mariaClinicNumber));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(t.mariaClinicNumber, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    (launchUrl(Uri.parse(t.skaneVardWebsite)));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(),
                                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(t.skaneVardWebsite, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                              SizedBox(height: 100),
                              Text(
                                t.triangleAddictionClinic,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                              ),
                              SizedBox(height: 5),
                              Text(
                                t.triangleAddictionClinicInfo,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Tel: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                  ElevatedButton(
                                      onPressed: () {
                                        (_launchPhoneNumber(t.triangleAddictionClinicNumber));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(t.triangleAddictionClinicNumber, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    (launchUrl(Uri.parse(t.skaneVardWebsite)));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(),
                                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(t.skaneVardWebsite, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                              SizedBox(height: 100),
                              Text(
                                t.thePolice,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth / 27),
                              ),
                              SizedBox(height: 5),
                              Text(
                                t.thePoliceInfo,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(t.contact, style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                  ElevatedButton(
                                      onPressed: () {
                                        (_launchPhoneNumber('114 14'));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(),
                                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(" 114 14 ", style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                                  Text(t.forUrgentHelp, style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29)),
                                ],
                              ),
                            ]))
                      ],
                    ),
                    Stack(
                      children: [
                        Image.asset(backgroundWoodPath),
                        Image.asset(backgroundPaperPath),
                        Container(
                            margin: EdgeInsets.only(top: 130, left: 50, right: 50),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(t.hereForYou, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Testament", fontSize: screenWidth / 17, color: Color(0xFF540909))),
                              SizedBox(height: 10),
                              Text(
                                t.hereForYouInfo,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                              SizedBox(height: 50),
                              Row(
                                children: [Expanded(child: Image.asset("assets/img/nollning-24/nolleguide/supp.jpg"))],
                              ),
                              SizedBox(height: 20),
                              Text(
                                t.hereForYouReachUs,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                  onPressed: () {
                                    (_launchMail(t.overfosEmail));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(),
                                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(t.overfosEmail, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                              ElevatedButton(
                                  onPressed: () {
                                    (_launchMail(t.fosetEmail));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(),
                                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.horizontal()),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(t.fosetEmail, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF5269D1), fontSize: screenWidth / 29))),
                              SizedBox(height: 20),
                              Text(
                                t.hereForYouTakeCare,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth / 29),
                              ),
                            ]))
                      ],
                    )
                  ],
                )
              ],
            ))));
  }
}
