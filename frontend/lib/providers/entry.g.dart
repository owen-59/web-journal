// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(entry)
final entryProvider = EntryFamily._();

final class EntryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Response<dynamic>>,
          Response<dynamic>,
          FutureOr<Response<dynamic>>
        >
    with
        $FutureModifier<Response<dynamic>>,
        $FutureProvider<Response<dynamic>> {
  EntryProvider._({
    required EntryFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'entryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$entryHash();

  @override
  String toString() {
    return r'entryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Response<dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Response<dynamic>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return entry(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EntryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$entryHash() => r'55a7f6c94bd5b28c0b3d045ef509d124cf14e767';

final class EntryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Response<dynamic>>, DateTime> {
  EntryFamily._()
    : super(
        retry: null,
        name: r'entryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EntryProvider call(DateTime dt) => EntryProvider._(argument: dt, from: this);

  @override
  String toString() => r'entryProvider';
}
