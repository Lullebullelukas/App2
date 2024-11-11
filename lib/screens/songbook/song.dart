import 'package:fsek_mobile/april_fools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fsek_mobile/models/songbook/song.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SongPage extends StatelessWidget {
  const SongPage({Key? key, required this.song}) : super(key: key);

  final Song song;

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant),
            padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 2, 0, 16),
                child: Text(
                  song.title!,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              song.melody != null && song.melody != ""
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "${t.songbookMelody}: ",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                          TextSpan(
                              text: song.melody!,
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))
                        ]),
                      ),
                    )
                  : SizedBox.shrink(),
              song.author != null && song.author != ""
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "${t.songbookAuthor}: ",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                          TextSpan(
                              text: song.author!,
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))
                        ]),
                      ),
                    )
                  : SizedBox.shrink(),
            ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14, 6, 14, 14),
            child: Html(
              data: song.content!,
              style: {
                "p": Style(fontSize: FontSize(16), lineHeight: LineHeight(1.5))
              },
            ),
          )
        ])));
  }
}
