import "package:frontend/exceptions.dart";
import "package:frontend/logger.dart";
import "package:frontend/models/entry.dart";
import "package:frontend/models/location.dart";
import "package:frontend/providers/dio_client.dart";
import "package:intl/intl.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "entry.g.dart";

@riverpod
class EntryNotifier extends _$EntryNotifier {
  @override
  Future<Entry> build(DateTime dt) async {
    logger.i("Making request.");
    final dio = ref.read(dioProvider);
    final res = await dio.get(
      DateFormat("'/api/entry/'y/MM/dd/HH/mm").format(dt),
    );
    final data = res.data;
    if (data is! Map) {
      throw ResponseNotMapException(data);
    }
    logger.i("data.tags: ${data["tags"].runtimeType}: ${data["tags"]}");
    logger.i("data.images: ${data["images"].runtimeType}: ${data["images"]}");
    logger.i("data: $data");
    try {
      final entry = parseEntryObject(data);
      return entry;
    } catch (err) {
      logger.e("Error whening parsing entry object: $err");
      throw ResponseParsingException();
    }
  }

  Future<void> writeWith({
    String? body,
    DateTime? datetime,
    List<String>? tags,
    Location? location,
  }) async {
    final dio = ref.read(dioProvider);
    final entry = await future;

    final changesDatetime = dt != datetime && datetime != null;

    if (!changesDatetime) {
      final newEntry = entry.copyWith(
        body: body,
        datetime: datetime,
        tags: tags,
        location: location,
      );

      await dio.put(
        DateFormat("'/api/entry/'y/MM/dd/HH/mm").format(dt),
        data: newEntry.encode(),
      );
      logger.d("Wrote entry at $dt");
    } else {
      throw UnimplementedError();
    }
  }
}
