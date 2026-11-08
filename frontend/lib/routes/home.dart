import "package:flutter/material.dart";
import "package:auto_route/auto_route.dart";
import "package:flutter/rendering.dart";
import "package:flutter_web_scroll/flutter_web_scroll.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:frontend/providers/entry_list.dart";
import "package:frontend/widgets/measure/entry_card.dart";
import "package:frontend/widgets/measure/entry_separator_with_text.dart";
import "package:frontend/widgets/measure/entry_separator_without_text.dart";
import "package:frontend/widgets/sliver_entry_list.dart";

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _scrollController = ScrollController();
  double _entryCardTemplateHeight = 0;
  double _entrySeparatorWithTextHeight = 0;
  double _entrySeparatorWithoutTextHeight = 0;

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(entryListProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Journal")),
      body: Stack(
        children: [
          switch (entries) {
            AsyncData(value: final entries) => SmoothScrollWeb(
              controller: _scrollController,
              config: SmoothScrollConfig.native(
                scrollSpeed: 1.0,
                enableMomentum: true,
                momentumFactor: 0.6,
              ),
              child: CustomScrollView(
                controller: _scrollController,
                scrollCacheExtent: ScrollCacheExtent.viewport(2),
                slivers: [
                  SliverEntryList(
                    entries: entries,
                    entryCardTemplateHeight: _entryCardTemplateHeight,
                    entrySeparatorWithTextHeight: _entrySeparatorWithTextHeight,
                    entrySeparatorWithoutTextHeight:
                        _entrySeparatorWithoutTextHeight,
                  ),
                ],
              ),
            ),
            AsyncError(:final error, :final stackTrace) => Center(
              child: Text("$error:\n$stackTrace"),
            ),
            AsyncLoading() => Center(child: const CircularProgressIndicator()),
          },
          EntryCardMeasurer(
            onChanged: (height) =>
                setState(() => _entryCardTemplateHeight = height),
          ),
          EntrySeparatorWithoutTextMeasurer(
            onChanged: (height) =>
                setState(() => _entrySeparatorWithoutTextHeight = height),
          ),
          EntrySeparatorWithTextMeasurer(
            onChanged: (height) =>
                setState(() => _entrySeparatorWithTextHeight = height),
          ),
        ],
      ),
    );
  }
}
