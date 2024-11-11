import 'package:fsek_mobile/april_fools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fsek_mobile/screens/guild_meeting/pdf.dart';
import 'package:fsek_mobile/models/documents/election_document.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/document.service.dart';

class OtherDocumentsPage extends StatefulWidget {
  @override
  _OtherDocumentsPageState createState() => _OtherDocumentsPageState();
}

class _OtherDocumentsPageState extends State<OtherDocumentsPage> {
  List<ElectionDocument>? otherList; // Håller alla "övriga" dokument

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
    return Scaffold(
        appBar: AppBar(title: Text(t.otherDocuments)),
        body: otherList == null
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary))
            : !listEquals([],
                    otherList) //listEquals är mycket viktigt, annars jämför den pointers
                ? Column(//Det finns övriga dokument
                    children: [
                    Expanded(
                        child: ListView(
                      children: otherList!
                          .map((document) => _generateDocumentWidget(document))
                          .toList(),
                    ))
                  ])
                : Center(
                    child: Text(t.noOtherDocuments,
                        style: TextStyle(
                            fontStyle:
                                FontStyle.italic))) //Inga övriga dokument
        );
  }

  Widget _generateDocumentWidget(ElectionDocument document) {
    var t = AppLocalizations.of(context)!;
    return Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4)),
        )),
        child: InkWell(
          onTap: () => openDocument(document),
          child: ListTile(
              title: Text(document.document_name == null
                  ? t.otherTitleMissing
                  : document.document_name!)),
        ));
  }

  void openDocument(ElectionDocument document) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PdfPage(url: document.url!, title: document.document_name!)));
  }
}
