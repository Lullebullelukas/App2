import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fsek_mobile/screens/guild_meeting/pdf.dart';
import 'package:fsek_mobile/models/documents/election_document.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/document.service.dart';

class CandidacyPosterPage extends StatefulWidget {
  @override
  _CandidacyPosterPageState createState() => _CandidacyPosterPageState();
}

class _CandidacyPosterPageState extends State<CandidacyPosterPage> {
  List<ElectionDocument>? otherList;
  final String posterName = "Kandidaturplansch";

  @override
  void initState() {
    locator<DocumentService>().getOthers("Val").then((value) => setState(() {
          this.otherList = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    if (otherList == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }
    ElectionDocument? candidacyPoster = findCandidacyPoster(posterName, otherList!);
    if (candidacyPoster == null) {
      // exists no poster with the given name
      return Scaffold(
          appBar: AppBar(),
          body: Center(child: Text(t.noCandidacyPoster, style: TextStyle(fontStyle: FontStyle.italic))));
    } else {
      return PdfPage(url: candidacyPoster.url!, title: candidacyPoster.document_name!);
    }
  }

  ElectionDocument? findCandidacyPoster(String name, List<ElectionDocument> documentList) {
    for (ElectionDocument doc in documentList) {
      if (doc.document_name == name) {
        return doc;
      }
    }
    return null;
  }
}
