import 'package:flutter/material.dart';

class TabbButton extends StatefulWidget {
  const TabbButton({super.key});

  @override
  State<TabbButton> createState() => _TabbButtonState();
}

class _TabbButtonState extends State<TabbButton> {
  String selectedValue = 'surah';

  @override
  Widget build(BuildContext context) {
    void onSelectionChanged(Set<String> newSelection) {
      setState(() {
        selectedValue = newSelection.first;
      });
    }

    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'surah', label: Text('Surah')),
        ButtonSegment(value: 'pages', label: Text('Pages')),
      ],
      selected: selectedValue == 'surah' ? {'surah'} : {'pages'},
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
