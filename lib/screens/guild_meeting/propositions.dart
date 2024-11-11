import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fsek_mobile/models/documents/election_document.dart';
import 'package:fsek_mobile/screens/guild_meeting/proposition_card.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/document.service.dart';
import 'package:fsek_mobile/april_fools.dart';

class PropositionsPage extends StatefulWidget {
  @override
  _PropositionsPageState createState() => _PropositionsPageState();
}

class _PropositionsPageState extends State<PropositionsPage> with TickerProviderStateMixin {
  List<ElectionDocument>? documents = [];
  List<ElectionDocument>? allDocuments = [];

  //bad helpvariables that are most likely unneeded
  bool searchFocus = false;
  String initChar = "";

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    locator<DocumentService>().getPropositions("Val").then((value) => setState(() {
          if (!listEquals(value, [])) {
            this.documents = value!;
            documents!.sort((a, b) => a.document_name!.compareTo(b.document_name!)); // handle null?
            allDocuments = List.from(documents!);
          } else {
            this.documents = null;
            allDocuments = null;
          }
        }));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return listEquals(allDocuments, [])
        ? Scaffold(
            appBar: AppBar(title: Text(t.propositionsPageTitle)),
            body: Center(
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)))
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(title: Text(t.propositionsPageTitle)),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FocusScope(
                      child: Focus(
                    onFocusChange: (focus) {
                      print(focus);
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
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  onPressed: () => FocusScope.of(context).unfocus())
                              : Icon(
                                  Icons.search,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                          hintText: t.songbookSearch,
                          suffixIcon: _controller.text.length > 0
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  color: Theme.of(context).colorScheme.onSurface,
                                  onPressed: () => setState(() {
                                        _controller.clear();
                                        FocusScope.of(context).unfocus();
                                        documents = allDocuments;
                                      }))
                              : SizedBox.shrink()),
                      onChanged: (search) {
                        List<String> searchTerms = search.toLowerCase().trim().split(new RegExp(r"\s+"));
                        setState(() {
                          initChar = "";
                          if (allDocuments != null) {
                            documents = allDocuments!.where((document) {
                              return searchTerms.every((term) => document.document_name!.toLowerCase().contains(term));
                            }).toList();
                          }
                        });
                      },
                    ),
                  )),
                  Expanded(
                    child: documents != null
                        ? Material(
                            child: ListView(
                            children: documents!.map((document) => _generateDocumentTile(document)).toList(),
                          ))
                        : Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(t.noProposition),
                          ),
                  )
                ],
              ),
            ));
  }

  Widget _generateDocumentTile(ElectionDocument document) {
    return Column(
      children: [PropositionCard(proposition: document)],
    );
  }
}
