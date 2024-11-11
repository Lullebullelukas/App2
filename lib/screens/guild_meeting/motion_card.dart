import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fsek_mobile/april_fools.dart';
import 'package:fsek_mobile/models/documents/election_document.dart';
import 'package:fsek_mobile/screens/guild_meeting/pdf.dart';

class MotionCard extends StatefulWidget {
  final ElectionDocument? motion;
  final ElectionDocument? motionResponse;

  const MotionCard({Key? key, required this.motion, this.motionResponse})
      : super(key: key);

  @override
  _MotionCardState createState() => _MotionCardState();
}

class _MotionCardState extends State<MotionCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color button_color =
      Theme.of(context).colorScheme.surfaceTint;
    Color background_color =
      Theme.of(context).colorScheme.surfaceTint.withOpacity(0.4);
    Color bottom_color = Theme.of(context).colorScheme.onBackground.withOpacity(0.4);
    var t = AppLocalizations.of(context)!;
    return widget.motion == null
        ? Container()
        : Container(
            decoration: BoxDecoration(
                color: background_color,
                border: Border(bottom: BorderSide(color: bottom_color))),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Column(children: [
              Center(
                  child: Text(
                widget.motion!.document_name!,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                      child: InkWell(
                          onTap: () => {openFile(widget.motion!)},
                          child: ListTile(
                            tileColor: button_color,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            title: Center(
                                child: Text(
                              t.readMotion,
                            )),
                            visualDensity: VisualDensity(vertical: -3),
                          ))),
                  SizedBox(
                      width: widget.motionResponse != null
                          ? MediaQuery.of(context).size.width / 100
                          : 0),
                  if (widget.motionResponse != null)
                    (Flexible(
                        child: Container(
                      child: InkWell(
                          onTap: () => {openFile(widget.motionResponse!)},
                          child: ListTile(
                              tileColor: button_color,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              visualDensity: VisualDensity(vertical: -3),
                              title: Center(child: Text(t.readMotionAnswer)))),
                      padding: EdgeInsets.only(top: 3),
                    ))),
                ],
              )
            ]));
  }

  void openFile(ElectionDocument document) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PdfPage(url: document.url!, title: document.document_name!)));
  }
}
