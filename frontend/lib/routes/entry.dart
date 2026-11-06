import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:frontend/providers/entry.dart";

@RoutePage()
class EntryPage extends ConsumerStatefulWidget {
  final String id;

  const EntryPage({super.key, @PathParam("id") required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends ConsumerState<EntryPage> {
  @override
  Widget build(BuildContext context) {
    final entry = ref.watch(entryProvider(DateTime.parse(widget.id)));
    return Scaffold(
      body: Column(
        children: [
          switch (entry) {
            AsyncData(value: final entry) => Text(entry.toString()),
            AsyncError(:final error) => Text("Error: $error"),
            _ => CircularProgressIndicator(),
          },
          Center(child: Text(widget.id))
        ],
      )
    );
  }
}
