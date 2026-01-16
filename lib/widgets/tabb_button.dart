import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hifzh_buddy/providers/quran_data_provider.dart';

class TabbButton extends ConsumerStatefulWidget {
  const TabbButton({super.key});

  @override
  ConsumerState<TabbButton> createState() => _TabbButtonState();
}

class _TabbButtonState extends ConsumerState<TabbButton> {
  @override
  Widget build(BuildContext context) {
    final selectedValue = ref.watch(activeTabProvider);

    void onSelectionChanged(Set<String> newSelection) {
      ref.read(activeTabProvider.notifier).state = newSelection;
    }

    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'surah', label: Text('Surah')),
        ButtonSegment(value: 'pages', label: Text('Pages')),
      ],
      selected: selectedValue,
      onSelectionChanged: onSelectionChanged,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xff14b881); // selected
          }
          return Colors.transparent; // unselected
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Colors.black87;
        }),
        side: WidgetStateProperty.all(
          const BorderSide(color: Color(0xff14b881)),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
