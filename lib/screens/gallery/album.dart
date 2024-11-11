import 'package:flutter/material.dart';
import 'package:fsek_mobile/april_fools.dart';
import 'package:fsek_mobile/environments/environment.dart';
import 'package:fsek_mobile/models/gallery/album.dart';
import 'package:fsek_mobile/screens/gallery/image_browser.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({Key? key, required this.album}) : super(key: key);

  final Album album;

  @override
  build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(
          title: Text(album.title!),
          actions: [],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  children: generateImages(context),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
              child: ExpansionTile(
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                childrenPadding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                title: Text(
                  "Mer info",
                ),
                children: [
                  SizedBox(
                    height: 8,
                    width: double.infinity,
                  ),
                  Text(
                    album.title ?? "-",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(album.description!),
                  SizedBox(height: 10),
                  RichText(
                      text: TextSpan(
                          text: t.albumPhotographers,
                          style: Theme.of(context).textTheme.bodyMedium?.apply(
                              color: Theme.of(context).primaryColor),
                          children: [
                        TextSpan(
                            text: album.photographers?.join(", ") ??
                                t.albumNoPhotographers,
                            style: Theme.of(context).textTheme.bodyMedium)
                      ])),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget generateDiscripton() {
    return Container();
  }

  List<Widget> generateImages(BuildContext context) {
    List<Widget> result = [];
    for (int i = 0; i < album.images!.length; i++) {
      Ink ink = Ink.image(
          image: AssetImage("assets/img/f_logo.png"),
          fit: BoxFit.cover,
          child: InkWell(
            onTap: () => openImageBrowser(context, i),
          )); //default pic

      if (album.images![i].file!.thumb!["url"] != null) {
        ink = Ink.image(
            image: NetworkImage(
                "${Environment.API_URL}${album.images![i].file!.thumb!["url"]}"),
            fit: BoxFit.cover,
            child: InkWell(
              onTap: () => openImageBrowser(context, i),
            ));
      }
      result.add(ink);
    }

    return result;
  }

  void openImageBrowser(BuildContext context, int imageIndex) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImageBrowserPage(
                  album: album,
                  initial: imageIndex,
                )));
  }
}
