import 'package:fsek_mobile/models/songbook/songbookEntry.dart';

import 'package:fsek_mobile/services/abstract.service.dart';

class BookService extends AbstractService {
  Future<List<BookEntry>> getBook() async {
    Map json = await AbstractService.get("/books");
    List<BookEntry> result = (json['books'] as List)
        .map((data) => BookEntry.fromJson(data))
        .toList();
    return result;
  }

  Future<List<SongbookEntry>> getChantbook() async {
    Map json = await AbstractService.get("/songs/chants");
    List<SongbookEntry> result = (json['songs'] as List)
        .map((data) => SongbookEntry.fromJson(data))
        .toList();
    return result;
  }
}
