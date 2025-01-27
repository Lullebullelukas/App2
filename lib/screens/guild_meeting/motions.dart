import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fsek_mobile/models/documents/election_document.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/document.service.dart';

import 'motion_card.dart';

class MotionsPage extends StatefulWidget {
  @override
  _MotionsPageState createState() => _MotionsPageState();
}

class _MotionsPageState extends State<MotionsPage> with TickerProviderStateMixin {
  List<List<ElectionDocument?>>? documents = [];
  List<List<ElectionDocument?>>? allDocuments = [];

  //bad helpvariables that are most likely unneeded
  bool searchFocus = false;
  String initChar = "";

  TextEditingController _controller = TextEditingController();

  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    locator<DocumentService>().getMotionsAndAnswers("Val").then((value) => setState(() {
          if (!listEquals(value, [])) {
            this.documents = value;
            // 0th value is the motion, which should always exist if we get a non null response
            documents!.sort((a, b) => a[0]!.document_name!.compareTo(b[0]!.document_name!));
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
            appBar: AppBar(title: Text(t.motionsPageTitle)),
            body: Center(
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)))
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(title: Text(t.motionsPageTitle)),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FocusScope(
                      child: Focus(
                    onFocusChange: (focus) {
                      //print(focus);
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
                          if (documents != null) {
                            documents = allDocuments!.where((document) {
                              return searchTerms
                                  .every((term) => document[0]!.document_name!.toLowerCase().contains(term));
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
                            children: documents!
                                .map((document) =>
                                    _generateDocumentTile(document[0]!, document.length > 1 ? document[1] : null))
                                .toList(),
                          ))
                        : Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(t.noMotions),
                          ),
                  )
                ],
              ),
            ));
  }

  Widget _generateDocumentTile(ElectionDocument motion, ElectionDocument? motion_answer) {
    return Column(children: [
      MotionCard(motion: motion, motionResponse: motion_answer),
    ]);
  }
}
