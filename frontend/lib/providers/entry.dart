import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:frontend/exceptions.dart";
import "package:frontend/logger.dart";
import "package:frontend/models/entry.dart";
import "package:frontend/providers/dio_client.dart";
import "package:intl/intl.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "entry.g.dart";

@riverpod
Future<Response<dynamic>> entry(Ref ref, DateTime dt) async {
  logger.i("Making request.");
  final dio = ref.read(dioProvider);
  final res = await dio.get(DateFormat("'/api/entry/'y/MM/dd/HH/mm").format(dt));
  final data = res.data;
  if (data is! Map) {
    throw ResponseNotMapException(data);
  }
  logger.i("data.tags: ${data["tags"].runtimeType}: ${data["tags"]}");
  logger.i("data.images: ${data["images"].runtimeType}: ${data["images"]}");
  logger.i("data: $data");
  try {
    final entry = parseEntryObject(data);
  } catch (err, stacktrace) {
    // logger.e(stacktrace);
    rethrow;
  }
  return res;
}
