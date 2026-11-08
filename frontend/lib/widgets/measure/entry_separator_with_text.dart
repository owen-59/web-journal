import "package:flutter/widgets.dart";
import "package:frontend/widgets/entry_card_separator.dart";
import "package:measured/measured.dart";

class EntrySeparatorWithTextMeasurer extends StatelessWidget {
  final void Function(double) onChanged;
  const EntrySeparatorWithTextMeasurer({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      child: Measured(
        onChanged: (size) => onChanged(size.height),
        child: EntryCardSeparator(
          aboveEntryDt: DateTime(1970),
          belowEntryDt: DateTime(1971),
        ),
      ),
    );
  }
}
