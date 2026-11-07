import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:frontend/logger.dart";
import "package:frontend/providers/entry.dart";
import "package:markdown_editor_live/markdown_editor_live.dart";

@RoutePage()
class EntryPage extends ConsumerStatefulWidget {
  final String id;

  const EntryPage({super.key, @PathParam("id") required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends ConsumerState<EntryPage> {
  String body = "";
  bool hasBeenEdited = false;
  var timer = Timer(const Duration(), () {});

  Future<void> _updateEntry() async {
    logger.i("Should update entry with $body");
    ref
        .read(entryProvider(DateTime.parse(widget.id)).notifier)
        .writeWith(body: body);
  }

  @override
  Widget build(BuildContext context) {
    final entry = ref.watch(entryProvider(DateTime.parse(widget.id)));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.router.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: switch (entry) {
        AsyncData(value: final entry) => PopScope(
          onPopInvokedWithResult: (didPop, _) => logger.i("didPop: $didPop"),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarkdownEditor(
                initialValue: entry.body,
                onChanged: (text) => setState(() {
                  body = text;
                  hasBeenEdited = true;
                  timer.cancel();
                  timer = Timer(Duration(milliseconds: 500), _updateEntry);
                }), // todo implement
              ),
              // todo location
              // todo tags
              // todo images
              // todo actions
            ],
          ),
        ),
        AsyncError(:final error) => Text("Error: $error"),
        _ => CircularProgressIndicator(),
      },
    );
  }
}
