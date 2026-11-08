import "package:collection/collection.dart";
import "package:frontend/exceptions.dart";
import "package:frontend/providers/dio_client.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "entry_list.g.dart";

@Riverpod(keepAlive: true)
class EntryList extends _$EntryList {
  @override
  Future<List<DateTime>> build() async {
    final dio = ref.watch(dioProvider);
    final res = await dio.get("/api/entry-list");
    final data = res.data;
    if (data is! List) throw ResponseValueInvalidException<List>(data);
    final dtStings = List<String>.from(data);
    final dts = dtStings
        .map((dtString) => DateTime.parse(dtString))
        .toList()
        .sorted((a, b) => -a.compareTo(b));
    return dts;
  }
}
