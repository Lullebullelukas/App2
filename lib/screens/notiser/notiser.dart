import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fsek_mobile/april_fools.dart';
import 'package:fsek_mobile/models/notiser/notis.dart';
import 'package:fsek_mobile/screens/event/event.dart';
import 'package:fsek_mobile/services/notiser.service.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsPage extends StatefulWidget {
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final Map<String, Style> _htmlStyle = {
    "body": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
    "p": Style(
        padding: HtmlPaddings.zero,
        margin: Margins.zero,
        fontSize: FontSize(17))
  };

  final PagingController<int, Notis> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      loadMoreMessages(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return Container(
      child: PagedListView<int, Notis>(
        pagingController: _pagingController,
        shrinkWrap: true,
        builderDelegate: PagedChildBuilderDelegate<Notis>(
            itemBuilder: (context, notis, index) {
          if (notis.data == null) return Container();

          return Card(
              color: notis.visited ?? false
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.surfaceTint,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => seeNotis(notis),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Html(
                          data: notis.data?["body"],
                          style: _htmlStyle,
                        ),
                        SizedBox(height: 4),
                        notis.data?["extra"] != null
                            ? Text(notis.data!["extra"]!)
                            : Container(),
                        Text(t.notificationsSent +
                            (DateFormat('EEE d LLL y kk:mm')
                                .format(notis.created_at!))),
                      ]),
                ),
              ));
        }, noItemsFoundIndicatorBuilder: (context) {
          return Container(
              height: 400,
              child: Center(
                  child: Text(t.notificationsNone,
                      style: Theme.of(context).textTheme.titleLarge)));
        }),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void loadMoreMessages(int page) {
    locator<NotiserService>().getMoreMessages(page).then((value) {
      if (value.meta?.next_page == null) {
        _pagingController.appendLastPage(value.notifications ?? []);
      } else {
        _pagingController.appendPage(value.notifications ?? [], page + 1);
      }
    });
  }

  void seeNotis(Notis notis) {
    locator<NotiserService>().visitNotis(notis.id!);
    setState(() {
      _pagingController.itemList!
          .singleWhere((element) => element.id == notis.id)
          .visited = true;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventPage(eventId: notis.event_id!)));
  }
}
