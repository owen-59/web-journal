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

  Future<void> addEntry(DateTime dt) async {
    state = await AsyncValue.guard(() async {
      final current = state.requireValue;
      final index = lowerBound(current, dt, compare: (a, b) => -a.compareTo(b));
      current.insert(index, dt);
      return current;
    });
  }

  Future<DateTime> newEntry() async {
    final dio = ref.watch(dioProvider);
    final res = await dio.post("/api/entry/new");
    final data = res.data;
    if (data is! String) throw ResponseValueInvalidException<String>(data);
    final dt = DateTime.tryParse(data);
    if (dt is! DateTime) throw ResponseValueInvalidException<DateTime>(dt);
    await addEntry(dt.toLocal());
    return dt.toLocal();
  }
}
