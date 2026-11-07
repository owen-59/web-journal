import "package:dio/dio.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "dio_client.g.dart";

@riverpod
Dio dio(Ref ref) {
  return Dio(BaseOptions(baseUrl: "http://localhost:3000"));
}
