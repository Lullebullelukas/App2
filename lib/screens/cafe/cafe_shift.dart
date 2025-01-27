import 'package:flutter/material.dart';
import 'package:fsek_mobile/models/cafe/cafe_shift.dart';
import 'package:fsek_mobile/models/cafe/cafe_user.dart';
import 'package:fsek_mobile/services/cafe.service.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/util/time.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CafeShiftPage extends StatefulWidget {
  final int shiftId;
  final CafeUser? user;
  CafeShiftPage({Key? key, required this.shiftId, required this.user})
      : super(key: key);
  @override
  _CafeShiftPageState createState() => _CafeShiftPageState();
}

class _CafeShiftPageState extends State<CafeShiftPage> {
  CafeShift? shift;
  CafeUser? user;

  void initState() {
    user = widget.user;
    _update();
    super.initState();
  }

  Future<void> _update() async {
    locator<CafeService>()
        .getShift(widget.shiftId)
        .then((value) => setState(() {
              this.shift = value;
            }));
  }

  void signup(CafeShift shift) async {
    await locator<CafeService>()
        .cafeShiftSignup(shift)
        .then((value) => successSignup(), onError: (e) => failSignup());
    _update();
  }

  void unsign(CafeShift shift) async {
    user = null; // bcuz garbage api lul
    await locator<CafeService>()
        .cafeShiftUnsign(shift)
        .then((value) => successUnsign(), onError: (e) => failUnsign());
    _update();
  }

  Future<void> generalPopup(String title, String body) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> successSignup() {
    var t = AppLocalizations.of(context)!;
    return generalPopup(t.cafeShiftSignup, t.cafeShiftSignupText);
  }

  Future<void> failSignup() {
    var t = AppLocalizations.of(context)!;
    return generalPopup(t.cafeShiftFail, t.cafeShiftFailSignupText);
  }

  Future<void> successUnsign() {
    var t = AppLocalizations.of(context)!;
    return generalPopup(t.cafeShiftSuccessUnsign, t.cafeShiftSuccessUnsignText);
  }

  Future<void> failUnsign() {
    var t = AppLocalizations.of(context)!;
    return generalPopup(t.cafeShiftFail, t.cafeShiftFailUnsignText);
  }

  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    if (shift == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(t.cafeShiftCafeShift),
        ),
      );
    }

    // Different text if user is already signed up to shift
    // also different button for signup/unsignup
    String headerText = "";
    TextButton? signupButton;
    if (shift!.isme ?? false) {
      headerText = t.cafeShiftSignedUp;
      signupButton = TextButton(
        onPressed: () => unsign(shift!),
        child: Text(
          t.cafeShiftRemoveSignup,
          style: TextStyle(fontSize: 32, color: Theme.of(context).colorScheme.onError),
        ),
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(Size(300, 75)),
          backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.error),
        ),
      );
    } else {
      // if someone else is on the shift, or if it is an empty shift
      headerText = (user == null)
          ? t.cafeShiftSignup2
          : "${user!.name}\n${t.cafeShiftIsSignedUp} ";
      signupButton = (user == null)
          ? TextButton(
              onPressed: () => signup(shift!),
              child: Text(t.cafeShiftSignMeUp, style: TextStyle(fontSize: 32)),
              style: ButtonStyle(
                backgroundColor: Theme.of(context).textButtonTheme.style!.backgroundColor,
                fixedSize: MaterialStateProperty.all(Size(300, 75)),
              ),
            )
          : null; // if another person is on the shift, don't show a signup button
    }
    headerText +=
        "${t.cafeShiftForShift}\n${Time.format(shift!.start ?? DateTime.now(), "%D")}${t.cafeShiftClock}${shift!.duration}";
    return Scaffold(
      appBar: AppBar(
        title: Text(t.cafeShiftCafeShift),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              headerText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                decorationColor: Theme.of(context).colorScheme.primary,
                decorationThickness: 1.3,
              ),
            ),
            SizedBox(height: 100),
            if (signupButton != null) signupButton,
          ],
        ),
      ),
    );
  }
}
