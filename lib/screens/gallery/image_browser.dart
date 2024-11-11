import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fsek_mobile/environments/environment.dart';
import 'package:fsek_mobile/models/gallery/album.dart';
import 'package:fsek_mobile/widgets/loading_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImageBrowserPage extends StatefulWidget {
  const ImageBrowserPage({Key? key, required this.album, required this.initial}) : super(key: key);

  final Album album;
  final int initial;

  @override
  State<ImageBrowserPage> createState() => _ImageBrowserPageState();
}

class _ImageBrowserPageState extends State<ImageBrowserPage> {
  var index;
  bool smallDownload = false;
  late Timer _timer;

  void indexUpdate(int index) {
    this.index = index;
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    index = widget.initial;
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.album.title!}"),
          actions: [
            Visibility(
              child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: <Color>[
                        const Color(0xFFFF0064),
                        const Color(0xFFFF7600),
                        const Color(0xFFFFD500),
                        const Color(0xFF8CFE00),
                        const Color(0xFF00E86C),
                        const Color(0xFF00F4F2),
                        const Color(0xFF00CCFF),
                        const Color(0xFF70A2FF),
                        const Color(0xFFA96CFF),
                      ],
                    ).createShader(bounds);
                  },
                  child: IconButton(
                    icon: Icon(Icons.download_for_offline_rounded, size: 40),
                    onPressed: () async {
                      try {
                        http.Response image = await http.get(
                            Uri.parse("${Environment.API_URL}${widget.album.images![index].file!.large!["url"]!}"));
                        ImageGallerySaver.saveImage(image.bodyBytes,
                            name: "${widget.album.images![index].filename!}", quality: 1);
                        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: Text("The JPEG god smiles upon you"),
                        ));
                      } on Exception catch (_) {
                        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: Text("JPEG broke :o"),
                        ));
                      }
                    },
                  )),
              visible: smallDownload,
            ),
            GestureDetector(
              child: IconButton(
                icon: Icon(Icons.download),
                onPressed: () async {
                  try {
                    http.Response image = await http
                        .get(Uri.parse("${Environment.API_URL}${widget.album.images![index].file!.large!["url"]!}"));
                    ImageGallerySaver.saveImage(image.bodyBytes,
                        name: "${widget.album.images![index].filename!}", quality: 100);
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                      content: Text(t.galleryImageDownloaded, style: Theme.of(context).textTheme.labelLarge,), 
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant
                    ));
                  } on Exception catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                      content: Text(t.galleryImageDownloadError, style: Theme.of(context).textTheme.labelLarge,),
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant
                    ));
                  }
                },
              ),
              onPanCancel: () => _timer.cancel(),
              onPanDown: (_) => {
                _timer = Timer(Duration(seconds: 4), () {
                  smallDownload = true;
                  setState(() {});
                })
              },
            )
          ],
        ),
        body: Center(
            child: PageViewBuilder(
          initial: widget.initial,
          album: widget.album,
          callback: indexUpdate,
          pageController: new PageController(initialPage: widget.initial),
        )));
  }
}

// These custom classes are here to solve the issue of
// panning a zoomed image also scrolling between the images.
// Simply put, it disables scrolling between images when the user is zoomed in on an image.

class PageViewBuilder extends StatefulWidget {
  final Album album;
  final int initial;
  // A function that sets the index in the main widget is passed down the widget-tree.
  // This weird passing-up-and-down of things isn't optimal, but was written to just
  // easily slot into the current image_browser page.
  final Function(int) callback;
  final PageController pageController;

  const PageViewBuilder(
      {Key? key, required this.album, required this.initial, required this.callback, required this.pageController})
      : super(key: key);

  @override
  _PageViewBuilderState createState() => _PageViewBuilderState();
}

class _PageViewBuilderState extends State<PageViewBuilder> {
  bool _pagingEnabled = true;
  var index;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: _pagingEnabled ? const PageScrollPhysics() : const NeverScrollableScrollPhysics(),
      itemCount: widget.album.images!.length,
      controller: widget.pageController,
      itemBuilder: (context, index) {
        widget.callback(index);
        final image = Image.network(
          "${Environment.API_URL}${widget.album.images![index].file!.large!["url"]!}",
          loadingBuilder: (context, widget, loadingProgress) {
            this.index = index;
            if (loadingProgress == null)
              return widget;
            else
              return LoadingWidget();
          },
        );
        return ImageContainer(
          image: image,
          album: widget.album,
          index: index,
          onScaleChanged: (scale) {
            setState(() {
              // Disabling scrolling if zoomed in.
              _pagingEnabled = scale <= 1.0;
            });
          },
        );
      },
    );
  }
}

class ImageContainer extends StatefulWidget {
  final Album album;
  final int index;
  final Image image;
  final double minScale;
  final double maxScale;
  final void Function(double)? onScaleChanged;

  const ImageContainer({
    Key? key,
    required this.image,
    this.minScale = 1.0,
    this.maxScale = 5.0,
    this.onScaleChanged,
    required this.index,
    required this.album,
  }) : super(key: key);

  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  final TransformationController _transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          transformationController: _transformationController,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          child: Column(children: [
            Padding(padding: EdgeInsets.fromLTRB(0, 45, 0, 45)),
            widget.image,
            Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 45)),
            Text(
              "${t.galleryTitle} ${widget.index + 1} ${t.galleryOf} ${widget.album.images!.length}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ]),
          onInteractionEnd: (scaleEndDetails) {
            double scale = _transformationController.value.getMaxScaleOnAxis();
            if (widget.onScaleChanged != null) {
              widget.onScaleChanged!(scale);
            }
          },
        ));
  }
}
